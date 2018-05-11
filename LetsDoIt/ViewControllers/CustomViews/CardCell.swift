//
//  CardCell.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    static let nibName: String = "Card"
    static let cellID: String = "card_cell"
    
    var cardTitle: String?
    
    @IBOutlet weak var imgCard: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self .setBorderWithRadius(5.0, color: UIColor.clear)
    }
    
    func updateUI(imageName: String) {
        imgCard.image = UIImage(named: imageName)
    }
    
    func updateCard(imageName:String, title:String) -> Card {
        let card = Card(image: imageName, title: title)
        return card
    }
}
