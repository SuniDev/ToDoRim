//
//  GroupCollectionViewCell.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

protocol GroupCollectionViewCellDelegate: AnyObject {
    func completeTodo(with group: Group, todo: Todo, isComplete: Bool)
    func moveGroupDetail(with group: Group)
}

class GroupCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Data
    weak var delegate: GroupCollectionViewCellDelegate?
    var group: Group = Group()
    var todos: [Todo] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        
        tableView.register(UINib(nibName: "GroupTaskCell", bundle: nil), forCellReuseIdentifier: "GroupTaskCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configure(group: Group, todos: [Todo], delegate: GroupCollectionViewCellDelegate) {
        self.group = group
        self.todos = todos
        self.delegate = delegate
        
        let colors = [group.startColor, group.endColor]
        let progressLayer = Utils.getProgressLayer(colors: colors)
        progress.progressImage = progressLayer.createGradientImage()
        
        title.text = group.title
        
        updateProgress()
        tableView.reloadData()
        
        contentView.hero.id = "view_\(group.groupId)"
        title.hero.id = "title_\(group.groupId)"
        progress.hero.id = "progress_\(group.groupId)"
        percentLabel.hero.id = "percent_\(group.groupId)"
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTaskCell", for: indexPath) as? GroupTaskCell,
              indexPath.row < todos.count else { return UITableViewCell() }
        
        let todo = todos[indexPath.row]
        cell.taskTitle.text = todo.title
        if todo.isComplete {
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
        delegate?.moveGroupDetail(with: group)
    }
    
}

extension GroupCollectionViewCell {
    
    func updateProgress() {
        var percent: Float = 0.0
        
        let completeTodos = todos.filter { $0.isComplete }
        
        if completeTodos.count > 0 {
            percent = Float(completeTodos.count) / Float(todos.count)
            percentLabel.text = "\(Int(percent * 100)) %"
        } else {
            percent = 0.0
            percentLabel.text = "0 %"
        }
        
        progress.setProgress(percent, animated: true)
    }
}

@objc
extension GroupCollectionViewCell {
    func checkTask(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let todo = todos[indexPath.row]
        
        
//        CommonRealmDB.shared.updateTaskCheck(gIndex: groupIndex, tIndex: tIndex, completion: { (response) in
//            if response {
//                self.tableView.performBatchUpdates({
//                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                }, completion: { (finished) in
//                    self.tableView.performBatchUpdates({
//                        self.updateProgress()
//                        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//                        self.arrTask.remove(at: index)
//                    }, completion: { (finished) in
//                        self.tableView.reloadData()
//                    })
//                })
//            }
//        })
    }
}
