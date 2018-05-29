//
//  CardSelectionVM.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/11/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class CardSelectionVM {
    
    private var arrCard: Array<Card> = [Card(title: "Default", image: nil),
                                        Card(title: "Default", image: nil),
                                        Card(title: "Default", image: nil),
                                        Card(title: "Default", image: nil),
                                        Card(title: "Default", image: nil)]
    
    func cellRow() -> Int {
        return self.arrCard.count
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> CardCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.cellID, for: indexPath) as! CardCell
        cell.updateUI(image: self.arrCard[indexPath.row].image ?? UIImage(named: "Card_Back")!,
                      title: self.arrCard[indexPath.row].title, canDelete: true)
        
        return cell
    }
    
    func getCard(at index: Int) -> Card? {
        guard 0 <= index && index < self.arrCard.count else {
            Log.error("Index out of range!!!")
            return nil
        }
        
        return self.arrCard[index]
    }
    
    func getCards() -> [Card] {
        return self.arrCard
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
    
    func resetCardToDefault(at index:Int) {
        guard 0 <= index && index < self.arrCard.count else {
            Log.error("Index out of range!!!")
            return
        }
        
        self.arrCard[index] = Card(title: "Default", image: nil)
    }
    
    func isValidCards() -> Bool {
        for card in self.arrCard {
            if card.image == nil {
                return false
            }
        }
        return true
    }
    
    func saveCards(_ completion:((_ isSuccess: Bool)->())? = nil) {
        DispatchQueue.global().async {
            guard let dataCards: Data = try? JSONEncoder().encode(self.arrCard) else {
                Log.error("Can't save cards to UserDefault!!!")
                if let completion = completion {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
                return
            }
            
            USER_DEFAULT.set(dataCards, forKey: ARRAY_CARD)
            USER_DEFAULT.synchronize()
            if let completion = completion {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    func loadCards(_ completion:((_ isSuccess: Bool)->())? = nil) {
        DispatchQueue.global().async {
            guard let dataCards: Data = USER_DEFAULT.object(forKey: ARRAY_CARD) as? Data else {
                    Log.error("Can't load cards from UserDefault!!!")
                if let completion = completion {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
                return
            }
            
            self.arrCard = try! JSONDecoder().decode([Card].self, from: dataCards)
            if let completion = completion {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
}

