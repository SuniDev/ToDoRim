//
//  AddGroupCollectionViewCell.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit

class AddGroupCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setCardBorder()
    }
    
    func configure() {
        self.contentView.hero.id = "view_addGroup"
    }
}
