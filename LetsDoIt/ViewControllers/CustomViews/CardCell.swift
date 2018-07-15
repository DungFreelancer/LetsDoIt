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
        
        self.btnDelete.setBackgroundImage(#imageLiteral(resourceName: "removeButton"), for: .normal)
        self.btnDelete.layer.cornerRadius = 5
        self.btnDelete.layer.masksToBounds = true 
        self.imgCard.setBorderWithRadius(5, color: UIColor.clear)
        self.imgCard.backgroundColor = UIColor.clear
        self.lbTitle.textColor = .white
        self.lbTitle.textAlignment = NSTextAlignment.center
        self.backgroundColor = .clear
        
        
    }
    
    func updateUI(image: UIImage, title: String, canDelete: Bool = false) {
        self.imgCard.image = image
        self.lbTitle.text = title
        self.btnDelete.isHidden = canDelete ? false : true
    }
    
}
