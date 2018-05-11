//
//  CardSelectionVM.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/11/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class CardSelectionVM {
    
    private var cardList: Array<Card> = [Card(image: "MIFFY", title: "Default"),Card(image: "MIFFY", title: "Default"),Card(image: "MIFFY", title: "Default"),Card(image: "MIFFY", title: "Default"),Card(image: "MIFFY", title: "Default")]
    
    func cellRow() -> Int {
        return self.cardList.count
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> CardCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.cellID, for: indexPath) as! CardCell
        cell.updateCard(imageName: self.cardList[indexPath.row].image, title: self.cardList[indexPath.row].title)
        return cell
    }

}

