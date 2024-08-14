//
//  AddGroupCollectionViewCell.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit

import Hero

class AddGroupCollectionViewCell: UICollectionViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setCardBorder()
    }
    
    func configure() {
        contentView.hero.id = AppHeroId.viewGroup.getId()
    }
}
