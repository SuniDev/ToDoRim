//
//  CollectionViewCell.swift
//  HSTODO
//
//  Created by 박현선 on 16/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {

    // Outlet
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var taskPercent: UILabel!
    @IBOutlet weak var taskProgress: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    var groupIndex = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    var arrTask = [DataTaskv2]()
    var taskCount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        taskProgress.transform = taskProgress.transform.scaledBy(x: 1, y: 2)
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        
        tableView.register(UINib(nibName: "GroupTaskCell", bundle: nil), forCellReuseIdentifier: "GroupTaskCell")
//        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let tabMove = UITapGestureRecognizer.init(target: self, action: #selector(moveGroupTask))
        tableView.addGestureRecognizer(tabMove)
        
        
    }
    

}
extension GroupCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTask.count
//        return CommonGroup.shared.getAllTask(index:groupIndex)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = arrTask.count - indexPath.row - 1
        let data = arrTask[index]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTaskCell", for: indexPath) as! GroupTaskCell
        cell.taskTitle.text = data.title
        if data.isCheck {
            cell.imgCheck.image = UIImage(named: "check_gray")
            cell.taskTitle.textColor = .lightGray
            let attribute = NSMutableAttributedString(string: cell.taskTitle.text ?? "")
            attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attribute.length))
            cell.taskTitle.attributedText = attribute
        }
        else {
            cell.imgCheck.image = UIImage(named: "uncheck_default")
            cell.taskTitle.textColor = UIColor(rgb: 0x39393E)
            // cc
        }
        
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(checkTask(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            CommonNav.shared.moveGroupTask(self.groupIndex)
        
    }
    
}

extension GroupCell {

    func updateProgress() {

        var percent: Float = 0.0
        if CommonGroup.shared.getCheckTask(gIndex: groupIndex) == 0 {
            percent = 0.0
            taskPercent.text = "0 %"
        } else {
            percent = Float(CommonGroup.shared.getCheckTask(gIndex: groupIndex)) / Float(CommonGroup.shared.getAllTask(gIndex: groupIndex))
            taskPercent.text = "\(Int(percent * 100)) %"
        }

        taskProgress.setProgress(percent, animated: true)
    }

}

@objc extension GroupCell {
    func checkTask(sender:UIButton) {
        let index = arrTask.count - sender.tag - 1
        let indexPath = IndexPath(row: sender.tag, section: 0)
        print(sender.tag, index)
        let tIndex = CommonGroup.shared.getTaskIndex(gIndex: groupIndex, taskNo: arrTask[index].taskNo)
        
        CommonRealmDB.shared.updateTaskCheck(gIndex: groupIndex, tIndex: tIndex, completion: { (response) in
            if response {
                self.tableView.performBatchUpdates({
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }, completion: { (finished) in
                    self.tableView.performBatchUpdates({
                        self.updateProgress()
                        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                        self.arrTask.remove(at: index)
                    }, completion: { (finished) in
                        self.tableView.reloadData()
                    })
                })
            }
        })
    }
    
    func moveGroupTask() {
            CommonNav.shared.moveGroupTask(self.groupIndex)
    }
}
