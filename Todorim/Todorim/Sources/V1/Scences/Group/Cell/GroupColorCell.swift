//
//  GroupColorCell.swift
//  HSTODO
//
//  Created by 박현선 on 22/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class GroupColorCell: UICollectionViewCell {

    // outlet
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var backView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.view.layer.cornerRadius = view.bounds.height / 2
        self.view.layer.masksToBounds = true
        self.backView.layer.cornerRadius = backView.bounds.height / 2
        self.backView.layer.masksToBounds = true
    }

}
