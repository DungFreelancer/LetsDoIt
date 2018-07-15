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
     
    @IBOutlet weak var imgScrollView: UIScrollView!
  
    @IBOutlet weak var videoPlayerView: UIView!
    
    //Fake navigationbar
    @IBOutlet weak var btnBack: UIButton!
        {
            didSet{
                btnBack.addTarget(self, action: #selector(backHandler), for: .touchUpInside)
            }
        }
    @IBOutlet weak var btnShare: UIButton!
        {
            didSet{
                btnShare.isEnabled = false
                btnShare.addTarget(self, action: #selector(shareHandler), for: .touchUpInside)
            }
        }
    
    var url: URL?
    var player: AVPlayer?
    var isPlaying: Bool = false
    var imgShare: UIImage?
    var recordType: RecordType?
    var havingImageOrVideo: Bool = false
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideNavigationBar(true)
        imgScrollView.delegate = self 
        Log.debug(recordType!)
        popupActionSheet()
        minAndMaxScaleOfScrollView()

    }
    
    // Action:
    @objc func backHandler() {
        AudioPlayerService.sharedInstance.playSound(soundFileName: "onclick")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareHandler() {
        AudioPlayerService.sharedInstance.playSound(soundFileName: "onclick")
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
    
    func minAndMaxScaleOfScrollView() {
        self.imgScrollView.minimumZoomScale = 1.0
        self.imgScrollView.maximumZoomScale = 3.0
    }
 
}
extension RecordVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            let type = info[UIImagePickerControllerMediaType] as! String
            if (type == "public.image") {
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                let imageSize = image.imageWithSize(size:image.size)
                self.imgSnapshot.image = imageSize
                
                self.btnShare?.isEnabled = true
                
                //Add logo
                let logo = UIImageView(image: UIImage(named: "logoVP")!)
                Log.debug(logo.frame.height)
                Log.debug(self.imgSnapshot.frame.height)
                logo.frame = CGRect(x: 8, y: self.imgSnapshot.frame.height-logo.frame.size.height + 150, width: 100, height: 100)
                self.imgSnapshot.addSubview(logo)
                
                let size = self.imgSnapshot.bounds.size
                let rec = self.imgSnapshot.bounds
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                self.imgSnapshot.drawHierarchy(in: rec, afterScreenUpdates: true)
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                UIImageWriteToSavedPhotosAlbum(result!, nil, nil, nil)
                // Share the result image here
                UIGraphicsBeginImageContext(self.imgSnapshot.frame.size)
                self.imgSnapshot.layer.render(in: UIGraphicsGetCurrentContext()!)
                self.imgShare = UIGraphicsGetImageFromCurrentImageContext()
         
            } else {
                let videoURL = info[UIImagePickerControllerMediaURL] as? URL
                let logo = UIImage(named: "logoVP")!
                
                HUDHelper.showLoading()
                Merge(config: .custom).overlayVideo(video: AVAsset(url: videoURL!), overlayImage: logo, completion: { (url) in
                    // Share the result video here
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url!)
                        self.url = url 
                        
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
                self.btnShare?.isEnabled = true
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgSnapshot
    }
}

