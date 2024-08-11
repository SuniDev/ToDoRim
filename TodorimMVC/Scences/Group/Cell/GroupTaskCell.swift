//
//  GroupTaskCell.swift
//  HSTODO
//
//  Created by 박현선 on 01/10/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class GroupTaskCell: UITableViewCell {

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
