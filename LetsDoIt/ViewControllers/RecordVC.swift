//
//  RecordVC.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit
import AVKit
import Photos
import MobileCoreServices
import FBSDKShareKit
import FBSDKCoreKit

class RecordVC: BaseVC {
    
    @IBOutlet weak var imgSnapshot: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupActionSheet()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action:  #selector(handleShare))
    }
   
    // Action:
    
    //popup ActionSheet to select record or snapshot
    func popupActionSheet() {
        let picker = UIImagePickerController()
        picker.delegate = self
        AlertHelper.showActionSheet(on: self, title: "Save This Moment".localized(), message: nil, firstButton: "Snapshot".localized(), firstComplete: { (action:UIAlertAction) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    picker.sourceType = .camera
                    self.present(picker,animated: true,completion: nil)
                } else {
                    Log.error("Camera is not available!!!")
                }
            }, secondButton: "Short Video".localized(), secondComplete: { (action:UIAlertAction) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    picker.sourceType = .camera
                    picker.videoMaximumDuration = 5
                    picker.mediaTypes = [kUTTypeMovie as String]
                    picker.allowsEditing = false
                    picker.showsCameraControls = true
                    self.present(picker,animated: true,completion: nil)
                } else {
                    Log.error("Camera is not available!!!")
                }
            })
        }
    
    @objc func handleShare() {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        let activityViewController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController,animated: true,completion: nil)
    }
    
}

extension RecordVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            let type = info[UIImagePickerControllerMediaType] as! String
            if (type == "public.image") {
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                self.imgSnapshot.image = image
                
                let logo = UIImageView(image: UIImage(named: "Logo")!)
                logo.frame = CGRect(x: 0, y: self.view.frame.height-logo.frame.size.height-44, width: 100, height: 100)
                self.imgSnapshot.addSubview(logo)
                
                let size = self.imgSnapshot.bounds.size
                let rec = self.imgSnapshot.bounds
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                self.imgSnapshot.drawHierarchy(in: rec, afterScreenUpdates: true)
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                UIImageWriteToSavedPhotosAlbum(result!, nil, nil, nil)
                // Share the result image here
//                let photo: FBSDKSharePhoto = FBSDKSharePhoto()
//
//                photo.image = result
//                photo.isUserGenerated = true
//
//                let content:FBSDKSharePhotoContent = FBSDKSharePhotoContent()
//                content.photos = [photo]
                
            } else {
                let videoURL = info[UIImagePickerControllerMediaURL] as! URL
                let logo = UIImage(named: "Logo")!
                
                HUDHelper.showLoading()
                Merge(config: .custom).overlayVideo(video: AVAsset(url: videoURL), overlayImage: logo, completion: { (url) in
                    // Share the result video here
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url!)
                    }, completionHandler: { (success, error) in
                        let playerVC = AVPlayerViewController()
                        playerVC.view.frame = self.view.bounds
                        playerVC.player = AVPlayer(url: url!)
                        
                        self.present(playerVC, animated: true) {
                            HUDHelper.hideLoading()
                            playerVC.player?.play()
                        }
                    })
                }) { (progress) in }
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

