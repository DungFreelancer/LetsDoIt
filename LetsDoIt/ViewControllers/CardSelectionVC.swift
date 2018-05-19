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
        
        HUDHelper.showLoading(view: self.view)
        self.cardSelectionVM.loadCards {
            HUDHelper.hideLoading()
            self.clCard.reloadData()
        }
    }
    
    // MARK: - Private methods
    private func setUpCollectionView() {
        self.clCard.register(UINib(nibName: CardCell.nibName, bundle: nil), forCellWithReuseIdentifier: CardCell.cellID)
        self.clCard.dataSource = self
        self.clCard.delegate = self
    }
    
    // MARK: - Action
    @objc private func onClickDelete(sender: UIButton) {
        self.cardSelectionVM.resetCardToDefault(at: sender.tag)
        
        HUDHelper.showLoading(view: self.view)
        self.cardSelectionVM.saveCards {
            HUDHelper.hideLoading()
            self.clCard.reloadItems(at: [IndexPath(row: sender.tag, section: 0)])
        }
    }
    
}

extension CardSelectionVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NUMBER_CARD
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.cardSelectionVM.cellInstance(collectionView: collectionView, indexPath: indexPath)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.onClickDelete(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCellRow = indexPath.row
        
        // pass data to CardVC
        let cardVC = DestinationView.cardVC()
        cardVC.delegate = self
        cardVC.cardDefault = self.cardSelectionVM.getCard(at: indexPath.row)
        
        self.navigationController?.pushViewController(cardVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 20, 0, 20)
    }
}

extension CardSelectionVC: CardVCDelegate {
    
    func passCard(_ card: Card) {
        self.cardSelectionVM.changeCard(at: self.selectedCellRow!, with: card)
        self.clCard.reloadItems(at: [IndexPath(row: self.selectedCellRow!, section: 0)])
        
        HUDHelper.showLoading(view: self.view)
        self.cardSelectionVM.saveCards {
            HUDHelper.hideLoading()
        }
        
    }

}
