//
//  PlayVM.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

enum Mode: String {
    case Chicken
    case Alien
    case Custom
}

class PlayVM {
    
    private var arrCard: Array<Card> = [Card(title: "Default", image: nil),
                                        Card(title: "Default", image: nil),
                                        Card(title: "Default", image: nil),
                                        Card(title: "Default", image: nil),
                                        Card(title: "Default", image: nil)]

    private var arrChickenCard: Array<Card> = [Card(title: "A glass of beer", image: UIImage(named: "beer")!),
                                               Card(title: "A glass of beer", image: UIImage(named: "beer")!),
                                               Card(title: "A glass of beer", image: UIImage(named: "beer")!),
                                               Card(title: "A glass of beer", image: UIImage(named: "beer")!),
                                               Card(title: "A glass of beer", image: UIImage(named: "beer")!)]
    
    private var arrAlienCard: Array<Card> = [Card(title: "2 glasses of wine", image: UIImage(named: "wines")!),
                                             Card(title: "2 glasses of wine", image: UIImage(named: "wines")!),
                                             Card(title: "2 glasses of wine", image: UIImage(named: "wines")!),
                                             Card(title: "2 glasses of wine", image: UIImage(named: "wines")!),
                                             Card(title: "2 glasses of wine", image: UIImage(named: "wines")!)]
    
    var currentMode: Mode {
        get {
            let strMode = USER_DEFAULT.object(forKey: CURRENT_MODE) as? String
            let mode = Mode.init(rawValue: strMode ?? Mode.Chicken.rawValue)
            return mode!
        }
        set {
            USER_DEFAULT.set(newValue.rawValue, forKey: CURRENT_MODE)
            USER_DEFAULT.synchronize()
        }
    }
    
    func cellRow() -> Int {
        return 30
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> CardCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.cellID, for: indexPath) as! CardCell
        cell.updateUI(image: UIImage(named: "cardback")!,
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
    
    func changeMode(mode: Mode, completion:((_ isSuccess: Bool)->())? = nil) {
        switch mode {
        case .Chicken:
            Log.debug("Chicken Mode")
            self.currentMode = .Chicken
            self.arrCard = self.arrChickenCard
            if let completion = completion {
                completion(true)
            }
        case .Alien:
            Log.debug("Alien Mode")
            self.currentMode = .Alien
            self.arrCard = self.arrAlienCard
            if let completion = completion {
                completion(true)
            }
        case .Custom:
            Log.debug("Custom Mode")
            self.currentMode = .Custom
            self.loadCards { (isSuccess) in
                if let completion = completion {
                    if isSuccess {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func randomIndexCard() -> Int {
        return Int(arc4random_uniform(UInt32(NUMBER_CARD)))
    }
    
}
