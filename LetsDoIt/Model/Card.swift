//
//  Card.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

struct Card: Codable {
    
    var imageName: String
    var title: String
    
    init(imageName: String, title: String) {
        self.imageName = imageName
        self.title = title
    }
    
}
