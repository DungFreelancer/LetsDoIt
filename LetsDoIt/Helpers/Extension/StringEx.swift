//
//  StringEx.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/17/18.
//  Copyright © 2018 HD. All rights reserved.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
}
