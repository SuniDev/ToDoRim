//
//  AddGroupCell.swift
//  HSTODO
//
//  Created by 박현선 on 16/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class AddGroupCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }

}
