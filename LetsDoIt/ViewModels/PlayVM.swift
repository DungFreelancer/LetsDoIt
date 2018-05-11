//
//  PlayVM.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class PlayVM {
    
    private var arrCard: Array<Card> = [Card(imageName: "Card_Beer", title: "Default"),
                                        Card(imageName: "Card_Cry", title: "Default"),
                                        Card(imageName: "Card_Laugh", title: "Default"),
                                        Card(imageName: "Card_Run", title: "Default"),
                                        Card(imageName: "Card_Sing", title: "Default")]
    
    func cellRow() -> Int {
        return self.arrCard.count
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> CardCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.cellID, for: indexPath) as! CardCell
        cell.updateUI(imageName: self.arrCard[indexPath.row].imageName, title: self.arrCard[indexPath.row].title)
        
        return cell
    }
    
}
