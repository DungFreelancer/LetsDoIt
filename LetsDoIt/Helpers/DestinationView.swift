//
//  DestinationView.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/11/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class DestinationView {
    
    static func modeSelectionVC() -> ModeSelectionVC {
        let storyboard = UIStoryboard(name: "ModeSelection", bundle: nil)
        let modeSelectionVC = storyboard.instantiateViewController(withIdentifier: "ModeSelectionVC") as! ModeSelectionVC
        return modeSelectionVC
    }
    
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
}
