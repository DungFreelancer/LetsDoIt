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
    
}
