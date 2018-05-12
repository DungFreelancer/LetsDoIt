//
//  CardVC.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

protocol PassImgCardtoCardSelectionVC {
    func passImgCard(type: UIImage) -> UIImage
}
class CardVC: BaseVC {
    @IBOutlet weak var imgCard: UIImageView!
    
    @IBOutlet weak var textTitle: UITextField!
    
    var delegate: PassImgCardtoCardSelectionVC?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImgCard)))
        self.imgCard.isUserInteractionEnabled = true
        
    }
    // MARK: - Action
    @objc func handleImgCard() {
        let picker = UIImagePickerController()
        picker.delegate = self
        Log.debug("handleImgCard is working")
        AlertHelper.showActionSheet(on: self, title: "Photo Source", message: nil, firstButton: "Camera", firstComplete: { (action: UIAlertAction) in
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        picker.sourceType = .camera
                        self.present(picker,animated: true, completion: nil)
                    } else {
                        Log.error("Camera is not available")
                        }
            }, secondButton: "Photo Library", secondComplete: { (action:UIAlertAction) in
                    picker.sourceType = .photoLibrary
                    self.present(picker,animated: true, completion: nil)
            }, thirdButton: nil, thirdComplete: nil)
    }

}

extension CardVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?

        if let editedImage = info["UIimagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            self.imgCard.image = selectedImage
            self.delegate?.passImgCard(type: selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

