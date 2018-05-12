//
//  CardSelectionVC.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class CardSelectionVC: BaseVC {
    
    let cardSelectionVM = CardSelectionVM()
    let cardCell = CardCell()
    
    @IBOutlet weak var clCard: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
        self.clCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImgCard)))
     
    }
    
    // Mark: -Action
    @objc func handleSelectImgCard() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
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
    
    func setUpCollectionView() {
        self.clCard.register(UINib(nibName: CardCell.nibName, bundle: nil), forCellWithReuseIdentifier: CardCell.cellID)
        self.clCard.dataSource = self
        self.clCard.delegate = self
    }
}

extension CardSelectionVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NUMBER_CARD
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.cardSelectionVM.cellInstance(collectionView: collectionView, indexPath: indexPath)
    }
}

extension CardSelectionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIimagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        // bi loi Nil dong nay
        if let selectedImage = selectedImageFromPicker {
        cardCell.imgCard.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

