//
//  GroupColorCollectionViewCell.swift
//  Todorim
//
//  Created by suni on 8/14/24.
//

import UIKit

class GroupColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = colorView.bounds.height / 2
        colorView.layer.masksToBounds = true
        borderView.layer.cornerRadius = borderView.bounds.height / 2
        borderView.layer.masksToBounds = true
    }
    
    func configure(with colors: [UIColor], isSelected: Bool) {
        // 배경 색상
        let gradientLayer = Utils.getVerticalLayer(frame: CGRect(x: 0, y: 0, width: 50, height: 50), colors: colors)
        colorView.layer.addSublayer(gradientLayer)
        borderView.isHidden = isSelected
    }
    
    func setSelect() {
        borderView.isHidden = !borderView.isHidden
    }
}
