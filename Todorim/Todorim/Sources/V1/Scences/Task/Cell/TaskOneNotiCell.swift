//
//  TaskNotiCell.swift
//  HSTODO
//
//  Created by 박현선 on 26/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class TaskOneNotiCell: UITableViewCell {
    
    
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var imgNoti: UIImageView!
    @IBOutlet weak var notiTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskTitle.attributedText = NSMutableAttributedString(string: "")
    }
    
}
