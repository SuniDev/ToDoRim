//
//  Utils.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

class Utils {
    static func getHorizontalLayer(frame: CGRect, colors: [UIColor]) -> CAGradientLayer {
        return CAGradientLayer(frame: frame, colors: colors, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
    }
    
    static func getVerticalLayer(frame: CGRect, colors: [UIColor]) -> CAGradientLayer {
        return CAGradientLayer(frame: frame, colors: colors, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
    }
    
    static func getCompleteAttributedText(with text: String) -> NSMutableAttributedString {
        let attribute = NSMutableAttributedString(string: text)
        attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attribute.length))
        return attribute
    }
}
