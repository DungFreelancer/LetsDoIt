//
//  CardSelectionVM.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/11/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class CardSelectionVM {
    
    private var arrCard: Array<Card> = [Card(image: UIImage(named: "Card_Back")!, title: "Default"),
                                Card(image: UIImage(named: "Card_Back")!, title: "Default"),
                                Card(image: UIImage(named: "Card_Back")!, title: "Default"),
                                Card(image: UIImage(named: "Card_Back")!, title: "Default"),
                                Card(image: UIImage(named: "Card_Back")!, title: "Default")]
    
    init() {
        self.loadCards()
    }
    
    func cellRow() -> Int {
        return self.arrCard.count
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> CardCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.cellID, for: indexPath) as! CardCell
        cell.updateUI(image: self.arrCard[indexPath.row].image, title: self.arrCard[indexPath.row].title)
        
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
    
    func saveCards() {
        guard let dataCards: Data = try? JSONEncoder().encode(self.arrCard) else {
                Log.error("Can't save cards to UserDefault!!!")
                return
            }
            
            USER_DEFAULT.set(dataCards, forKey: ARRAY_CARD)
            USER_DEFAULT.synchronize()
        }
    
    func loadCards() {
            guard let dataCards: Data = USER_DEFAULT.object(forKey: ARRAY_CARD) as? Data else {
                Log.error("Can't load cards from UserDefault!!!")
                return
            }
            
            self.arrCard = try! JSONDecoder().decode([Card].self, from: dataCards)
        }
    }

