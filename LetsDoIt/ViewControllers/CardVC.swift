//
//  CardVC.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

protocol CardVCDelegate {
    func passCard(_ card: Card)
}

class CardVC: BaseVC {
    
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var txtTitle: UITextField!
    
    var cardDefault: Card?
    
    var delegate: CardVCDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onClickAdd))
        
        self.txtTitle.text = self.cardDefault?.title
        self.imgCard.image = self.cardDefault?.image
        self.imgCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageCard)))
        self.imgCard.isUserInteractionEnabled = true
    }
    
    // MARK: - Action
    @objc func handleImageCard() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        AlertHelper.showActionSheet(on: self, title: "Photo Source", message: nil, firstButton: "Camera", firstComplete: { (action: UIAlertAction) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    picker.sourceType = .camera
                    self.present(picker,animated: true, completion: nil)
                } else {
                    Log.error("Camera is not available!!!")
                }
            }, secondButton: "Photo Library", secondComplete: { (action:UIAlertAction) in
                picker.sourceType = .photoLibrary
                self.present(picker,animated: true, completion: nil)
            })
    }
    
    @objc func onClickAdd() {
        self.delegate?.passCard(Card(image: self.imgCard.image!,
                                     title: self.txtTitle.text!))
        self.navigationController?.popViewController(animated: true)
    }

}

extension CardVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.imgCard.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

