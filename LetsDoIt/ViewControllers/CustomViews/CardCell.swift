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
    
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnDelete.isHidden = true
        self.btnDelete.titleLabel?.text = "Delete".localized()
        self.btnDelete.backgroundColor = UIColor.red
        self.imgCard.setBorderWithRadius(5.0, color: UIColor.clear)
    }
    
    func updateUI(image: UIImage, title: String) {
        self.imgCard.image = image
        self.lbTitle.text = title
    }
    
}
