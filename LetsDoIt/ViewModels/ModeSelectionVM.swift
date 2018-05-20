//
//  ModeSelectionVM.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/20/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class ModeSelectionVM {
    
    let items: [(icon: String, color: UIColor)] = [
        ("chicken", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1)),
        ("alien", UIColor(red: 0.22, green: 0.74, blue: 0, alpha: 1)),
        ("gears", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1))]
    
    private var arrNormalMode: Array<Card> = [Card(image: UIImage(named: "Card_Beer")!, title: "A glass of beer"),
                                        Card(image: UIImage(named: "Card_Beer")!, title: "1 shot"),
                                        Card(image: UIImage(named: "Card_Laugh")!, title: "A glass of wine"),
                                        Card(image: UIImage(named: "Card_Run")!, title: "Default"),
                                        Card(image: UIImage(named: "Card_Sing")!, title: "Default")]
    
    private var arrCrazyMode: Array<Card> = [Card(image: UIImage(named: "Card_Beer")!, title: "2 beers"),
                                              Card(image: UIImage(named: "Card_Beer")!, title: "2 shot"),
                                              Card(image: UIImage(named: "Card_Laugh")!, title: "2 glasses of wine"),
                                              Card(image: UIImage(named: "Card_Run")!, title: "Default"),
                                              Card(image: UIImage(named: "Card_Sing")!, title: "Default")]
    
    
}
