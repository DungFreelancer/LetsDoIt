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
            return nil
        }
        
        return self.arrCard[index]
    }
    
    func changeCard(at index: Int, with card: Card) {
        guard 0 <= index && index < self.arrCard.count else {
            return
        }
        
        self.arrCard[index] = card
    }
    
    func saveArray(_ info: [Card]) {
        let dataInfo: Data = try! JSONEncoder().encode(info)
        USER_DEFAULT.set(dataInfo, forKey: "array")
        USER_DEFAULT.synchronize()
    }
    
    func loadArray(_ KeyInfo: String) -> [Card]? {
        guard let dataInfo: Data = USER_DEFAULT.object(forKey: KeyInfo) as? Data else {
            Log.error("Can't load the data from UserDefault!!!")
            return nil
        }
        
        let info: [Card]? = try? JSONDecoder().decode([Card].self, from: dataInfo)
        return info
    }
}

