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
    
    /// 특정 코너에만 cornerRadius를 적용하는 함수
    /// - Parameters:
    ///   - corners: 원하는 코너를 지정합니다. 예: [.topLeft, .bottomRight]
    ///   - radius: 적용할 반경을 지정합니다.
    func applyCornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
