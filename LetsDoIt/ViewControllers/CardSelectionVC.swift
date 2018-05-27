//
//  CardSelectionVC.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

protocol CardSelectionDelegate: class {
    func passCustomCards(_ arrCard: [Card])
}

class CardSelectionVC: BaseVC {
    
    @IBOutlet weak var clCard: UICollectionView!
    
    let cardSelectionVM = CardSelectionVM()
    var selectedCellRow: Int?
    weak var delegate: CardSelectionDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done".localized(),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handlerDone))
        
        HUDHelper.showLoading()
        self.cardSelectionVM.loadCards { [weak self] (isSuccess) in
            HUDHelper.hideLoading()
            if isSuccess {
                self?.clCard.reloadData()
            }
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
        
        HUDHelper.showLoading()
        self.cardSelectionVM.saveCards { [weak self] (isSuccess) in
            HUDHelper.hideLoading()
            if isSuccess {
                self?.clCard.reloadItems(at: [IndexPath(row: sender.tag, section: 0)])
            }
        }
    }
    
    @objc private func handlerDone() {
        if self.cardSelectionVM.isValidCards() {
            self.delegate?.passCustomCards(cardSelectionVM.getCards())
            self.navigationController?.popViewController(animated: true)
        } else {
            AlertHelper.showPopup(on: self, title: "", message: "The Custom mode must have 5 cards".localized(), mainButton: "OK".localized(), mainComplete: {_ in })
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
        
        HUDHelper.showLoading()
        self.cardSelectionVM.saveCards { (isSuccess) in
            HUDHelper.hideLoading()
        }
    }
    
}
