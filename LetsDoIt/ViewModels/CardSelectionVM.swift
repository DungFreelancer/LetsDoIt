//
//  CardSelectionVM.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/11/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class CardSelectionVM {
    
    private var arrCard: Array<Card> = [Card(imageName: "MIFFY", title: "Default"),
                                        Card(imageName: "MIFFY", title: "Default"),
                                        Card(imageName: "MIFFY", title: "Default"),
                                        Card(imageName: "MIFFY", title: "Default"),
                                        Card(imageName: "MIFFY", title: "Default")]

    func cellRow() -> Int {
        return self.arrCard.count
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> CardCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.cellID, for: indexPath) as! CardCell
        cell.updateUI(imageName: self.arrCard[indexPath.row].imageName, title: self.arrCard[indexPath.row].title)
        
        return cell
    }

}

