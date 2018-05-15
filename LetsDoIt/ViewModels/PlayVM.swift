//
//  PlayVM.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class PlayVM {
    
    private var arrCard: Array<Card> = [Card(image: UIImage(named: "Card_Beer")!, title: "Default"),
                                        Card(image: UIImage(named: "Card_Cry")!, title: "Default"),
                                        Card(image: UIImage(named: "Card_Laugh")!, title: "Default"),
                                        Card(image: UIImage(named: "Card_Run")!, title: "Default"),
                                        Card(image: UIImage(named: "Card_Sing")!, title: "Default")]
    
    func cellRow() -> Int {
        return Int(Int16.max)
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> CardCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.cellID, for: indexPath) as! CardCell
        cell.updateUI(image: UIImage(named: "Card_Back")!,
                      title: self.arrCard[indexPath.row % NUMBER_CARD].title)
        
        return cell
    }
    
    func getCard(at index: Int) -> Card? {
        guard 0 <= index && index < self.arrCard.count else {
            return nil
        }
        
        return self.arrCard[index]
    }
    
    func randomIndexCard() -> Int {
        return Int(arc4random_uniform(UInt32(NUMBER_CARD)))
    }
    
}
