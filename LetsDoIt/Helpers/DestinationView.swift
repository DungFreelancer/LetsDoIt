//
//  DestinationView.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/11/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class DestinationView {
    
    static func cardSelectionVC() -> CardSelectionVC {
        let storyboard = UIStoryboard(name: "CardSelection", bundle: nil)
        let cardSelectionVC = storyboard.instantiateViewController(withIdentifier: "CardSelectionVC") as! CardSelectionVC
        return cardSelectionVC
    }
    
    static func cardVC() -> CardVC {
        let storyboard = UIStoryboard(name: "Card", bundle: nil)
        let cardVC = storyboard.instantiateViewController(withIdentifier: "CardVC") as! CardVC
        return cardVC
    }
    
    static func recordVC() -> RecordVC {
        let storyboard = UIStoryboard(name: "Record", bundle: nil)
        let recordVC = storyboard.instantiateViewController(withIdentifier: "RecordVC") as! RecordVC
        return recordVC
    }
    
    static func InfoVC() -> InfoVC {
        let storyboard = UIStoryboard(name: "Info", bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
        return infoVC
    }
}
