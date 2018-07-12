//
//  UIImageEx.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/27/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizing() -> UIImage {
        let scale = max(CARD_SIZE.width / self.size.width,
                        CARD_SIZE.height / self.size.height)
        let newSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Reduce image quality
        let newData = UIImageJPEGRepresentation(newImage!, 0.5)
        newImage = UIImage(data: newData!)
        
        // Cropping image
        let cutImageRef = newImage?.cgImage?.cropping(to: CGRect(x: ((newImage?.size.width)! - CARD_SIZE.width) / 2, y: 0, width: CARD_SIZE.width, height: CARD_SIZE.height))
        newImage = UIImage(cgImage: cutImageRef!)
        
        return newImage!
    }
    
    func imageWithSize(size:CGSize) -> UIImage
    {
        var scaledImageRect = CGRect.zero;
        
        let aspectWidth:CGFloat = size.width / self.size.width;
        let aspectHeight:CGFloat = size.height / self.size.height;
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight);
        
        scaledImageRect.size.width = self.size.width * aspectRatio;
        scaledImageRect.size.height = self.size.height * aspectRatio;
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        
        self.draw(in: scaledImageRect);
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage!;
    }
    
}
