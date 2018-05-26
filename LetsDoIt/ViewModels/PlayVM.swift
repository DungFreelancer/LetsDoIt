//
//  PlayVM.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

enum Mode: String {
    case Chicken = "Chicken"
    case Alien = "Alien"
}

class PlayVM {
    
    private var arrCard: Array<Card> = [Card(image: UIImage(named: "Card_Beer")!, title: "Default"),
                                        Card(image: UIImage(named: "Card_Cry")!, title: "Default"),
                                        Card(image: UIImage(named: "Card_Laugh")!, title: "Default"),
                                        Card(image: UIImage(named: "Card_Run")!, title: "Default"),
                                        Card(image: UIImage(named: "Card_Sing")!, title: "Default")]
    
    private var arrChickenCard: Array<Card> = [Card(image: UIImage(named: "beer")!, title: "A glass of beer"),
                                              Card(image: UIImage(named: "beers")!, title: "1 shot"),
                                              Card(image: UIImage(named: "wine")!, title: "A glass of wine"),
                                              Card(image: UIImage(named: "wines")!, title: "Default"),
                                              Card(image: UIImage(named: "Card_Sing")!, title: "Default")]
    
    private var arrAlienCard: Array<Card> = [Card(image: UIImage(named: "beers")!, title: "2 beers"),
                                             Card(image: UIImage(named: "shot")!, title: "2 shot"),
                                             Card(image: UIImage(named: "wines")!, title: "2 glasses of wine"),
                                             Card(image: UIImage(named: "Card_Run")!, title: "Default"),
                                             Card(image: UIImage(named: "Card_Sing")!, title: "Default")]
    
    func cellRow() -> Int {
        return 30
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> CardCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.cellID, for: indexPath) as! CardCell
        cell.updateUI(image: UIImage(named: "Card_Back")!,
                      title: self.arrCard[indexPath.row % NUMBER_CARD].title)
        cell.lbTitle.isHidden = true 
        return cell
    }
    
    func getCard(at index: Int) -> Card? {
        guard 0 <= index && index < self.arrCard.count else {
            Log.error("Index out of range!!!")
            return nil
        }
        return self.arrCard[index]
    }
    
    func changeCard(at index: Int, with card: Card) {
        guard 0 <= index && index < self.arrCard.count else {
            Log.error("Index out of range!!!")
            return
        }
        
        self.arrCard[index] = card
    }
    
    func changeToCards(_ cards: [Card]) {
        for i in 0 ..< self.arrCard.count {
            self.changeCard(at: i, with: cards[i])
        }
    }
    
    func changeMode(mode: Mode){
        switch mode {
        case .Chicken:
            Log.debug("Chicken Mode")
            self.arrCard = arrChickenCard
        case .Alien:
            Log.debug("Alien Mode")
            self.arrCard = arrAlienCard
        }
    }
    
    func randomIndexCard() -> Int {
        return Int(arc4random_uniform(UInt32(NUMBER_CARD)))
    }
    
}
