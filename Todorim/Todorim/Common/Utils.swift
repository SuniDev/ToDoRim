//
//  Utils.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

class Utils {
    
    static func getProgressLayer(colors: [UIColor]) -> CAGradientLayer {
        return CAGradientLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5.0), colors: colors, startPoint: CGPoint(x: 0, y:0.5), endPoint: CGPoint(x: 1.0, y:0.5))
    }
    
    static func getBackgroundLayer(colors: [UIColor]) -> CAGradientLayer {
        return CAGradientLayer(frame: UIScreen.main.bounds, colors: colors, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
    }
}
