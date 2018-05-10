//
//  PlayVM.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class PlayVM {
    
    private let arrCard: Array<String> = ["Card_Beer", "Card_Cry", "Card_Laugh", "Card_Run", "Card_Sing"]
    
    func cellRow() -> Int {
        return self.arrCard.count
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> CardCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.cellID, for: indexPath) as! CardCell
        cell.updateUI(imageName: self.arrCard[indexPath.row])
        
        return cell
    }
    
}
