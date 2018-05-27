//
//  UIImageEx.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/27/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func ==(_ left: UIImage,_ right: UIImage) -> Bool {
        let leftData: Data = UIImagePNGRepresentation(left.resizing())!
        let rightData: Data = UIImagePNGRepresentation(right.resizing())!
        return leftData == rightData
    }
    
    func resizing() -> UIImage {
        let newHeight = CGFloat(345)
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newData = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext()!, 0.5)
        let newImage = UIImage(data: newData!)
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
