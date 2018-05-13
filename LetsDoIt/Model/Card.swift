//
//  Card.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

struct Card: Codable {
    
    var imageWrapper: ImageWrapper
    var title: String
    
    init(imageWrapper: ImageWrapper, title: String) {
        self.imageWrapper = imageWrapper
        self.title = title
    }
    
}
