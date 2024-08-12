//
//  CAGradientLayerExtension.swift
//  HSTODO
//
//  Created by 박현선 on 16/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 1)
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    func createGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }

    
//    CAGradientLayer 사용법
//    var colors = [UIColor]()
//    colors.append( UIColor(rgb: 0x81DADE))
//    colors.append( UIColor(rgb: 0x7494DD))
//    let gradientLayer = CAGradientLayer(frame: self.view.frame, colors: colors, startPoint: CGPoint(x: 0.5, y:0), endPoint: CGPoint(x:0.5, y:1))
//    bgImage.image = gradientLayer.createGradientImage()
//
}
