//
//  UIView+Extension.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit

extension UICollectionViewCell {
    func setCardBorder() {
        self.contentView.layer.cornerRadius = 15.0
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }
}
