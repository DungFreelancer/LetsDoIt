//
//  ImageWrapper.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/13/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

public struct ImageWrapper: Codable {
    
    public let image: UIImage
    
    public enum CodingKeys: String, CodingKey {
        case image
    }
    
    public init(image: UIImage) {
        self.image = image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        self.image = UIImage(data: data)!
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let data = UIImagePNGRepresentation(self.image) {
            try container.encode(data, forKey: CodingKeys.image)
        }
    }
    
}
