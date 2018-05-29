//
//  Card.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

struct Card: Codable {
    
    var title: String
    var image: UIImage?
    
    public enum CodingKeys: String, CodingKey {
        case title
        case image
    }
    
    init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: CodingKeys.title)
        if let dataImage = try container.decodeIfPresent(Data.self, forKey: CodingKeys.image) {
            self.image = UIImage(data: dataImage)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.title, forKey: CodingKeys.title)
        if let image = self.image {
           let data = UIImageJPEGRepresentation(image, 1)
            try container.encode(data, forKey: CodingKeys.image)
        }
    }
    
}
