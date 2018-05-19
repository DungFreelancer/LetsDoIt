//
//  CardSelectionVC.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class CardSelectionVC: BaseVC {
    
    @IBOutlet weak var clCard: UICollectionView!
    
    let cardSelectionVM = CardSelectionVM()
    var selectedCellRow: Int?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
    }
    
    // MARK: - Action
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCellRow = indexPath.row
        
        // pass data to CardVC
        let cardVC = DestinationView.cardVC()
        cardVC.delegate = self
        cardVC.cardDefault = self.cardSelectionVM.getCard(at: indexPath.row)
        self.navigationController?.pushViewController(cardVC, animated: true)
    }
    
}

extension CardSelectionVC: CardVCDelegate {
    
    func passCard(_ card: Card) {
        self.cardSelectionVM.changeCard(at: self.selectedCellRow!, with: card)
        self.cardSelectionVM.saveCards()
        self.clCard.reloadItems(at: [IndexPath(row: self.selectedCellRow!, section: 0)])
    }

}
