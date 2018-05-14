//
//  Card.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

struct Card: Codable {
    
    var image: UIImage
    var title: String
    
    public enum CodingKeys: String, CodingKey {
        case image
        case title
    }
    
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: CodingKeys.title)
        let dataImage = try container.decode(Data.self, forKey: CodingKeys.image)
        self.image = UIImage(data: dataImage)!
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.title, forKey: CodingKeys.title)
        if let data = UIImagePNGRepresentation(self.image) {
            try container.encode(data, forKey: CodingKeys.image)
        }
    }
    
}
