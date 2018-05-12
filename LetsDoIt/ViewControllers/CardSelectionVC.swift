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
    
    @IBOutlet weak var clCard: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
        self.clCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImgCard)))
     
    }
    
    // Mark: -Action
    @objc func handleSelectImgCard() {
        self.navigationController?.pushViewController(DestinationView.cardVC(), animated: true)
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

extension CardSelectionVC: PassImgCardtoCardSelectionVC {
    func passImgCard(type: UIImage) -> UIImage{
        return type
    }
    
    
}
