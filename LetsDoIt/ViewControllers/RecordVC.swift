//
//  RecordVC.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices

class RecordVC: BaseVC {
    
   
    @IBOutlet weak var imgSnapshot: UIImageView!

    @IBOutlet weak var videoPlayerView: UIView!
    
    var url: URL?
    var player: AVPlayer?
    var isPlaying: Bool = false
    var imgShare: UIImage?
    var recordType: RecordType?
    var havingImageOrVideo: Bool = false
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share1"), style: .plain, target: self, action: #selector(shareHandler))
        navigationItem.rightBarButtonItem?.isEnabled = false
        Log.debug(recordType!)
        popupActionSheet()

    }

    // Action:
    @objc func shareHandler() {
        if videoPlayerView.isHidden {
            let activityViewController = UIActivityViewController(activityItems: [imgShare!], applicationActivities: nil)
            self.present(activityViewController,animated: true,completion: nil)
        } else {
            let activityViewController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            self.present(activityViewController,animated: true,completion: nil)
        }
    }

    //popup ActionSheet to select record or snapshot
    func popupActionSheet() {
        let picker = UIImagePickerController()
        picker.delegate = self
        if recordType == RecordType.Snapshot {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    picker.sourceType = .camera
                    self.present(picker,animated: true,completion: nil)
                } else {
                    Log.error("Camera is not available!!!")
                }
        } else if recordType == RecordType.Video {
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
        }
    }
}
extension RecordVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            let type = info[UIImagePickerControllerMediaType] as! String
            if (type == "public.image") {
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                self.imgSnapshot.image = image
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                //Add logo
                let logo = UIImageView(image: UIImage(named: "Logo")!)
                logo.frame = CGRect(x: 0, y: self.imgSnapshot.frame.height-logo.frame.size.height-10, width: 100, height: 100)
                self.imgSnapshot.addSubview(logo)
                
                let size = self.imgSnapshot.bounds.size
                let rec = self.imgSnapshot.bounds
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                self.imgSnapshot.drawHierarchy(in: rec, afterScreenUpdates: true)
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                UIImageWriteToSavedPhotosAlbum(result!, nil, nil, nil)
                // Share the result image here
                UIGraphicsBeginImageContext(self.view.frame.size)
                self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
                self.imgShare = UIGraphicsGetImageFromCurrentImageContext()
         
            } else {
                self.url = info[UIImagePickerControllerMediaURL] as? URL
                let logo = UIImage(named: "Logo")!
                
                HUDHelper.showLoading()
                Merge(config: .custom).overlayVideo(video: AVAsset(url: self.url!), overlayImage: logo, completion: { (url) in
                    // Share the result video here
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url!)
                    }, completionHandler: { (success, error) in
                        DispatchQueue.main.async {
                            self.videoPlayerView.isHidden = false
                            self.player = AVPlayer(url: url!)
                            let playerLayer = AVPlayerLayer.init(player: self.player!)
                            playerLayer.frame = self.videoPlayerView.bounds
                            self.videoPlayerView.layer.addSublayer(playerLayer)
                            HUDHelper.hideLoading()
                            self.player?.play()
                        }
                    })
                }) { (progress) in }
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

