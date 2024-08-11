//
//  TaskCell.swift
//  HSTODO
//
//  Created by 박현선 on 25/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskTitle.attributedText = NSMutableAttributedString(string: "")
    }

}
