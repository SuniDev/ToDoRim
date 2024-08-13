//
//  GroupDetailViewController.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit

import Hero

class GroupDetailViewController: UIViewController {
    
    // MARK: - Data
    var groupStorage: GroupStorage?
    var todoStorage: TodoStorage?
    
    var group: Group?
    var todos: [Todo] = []
    
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Action
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedEditGroupButton(_ sender: UIButton) {
//        CommonNav.shared.moveModifyGroup(groupIndex, self)
    }
    
    @IBAction func tappedAddTodoButton(_ sender: UIButton) {
//        CommonNav.shared.moveAddTask(groupIndex, self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHeroID()
    }
    
    func configureUI() {
        configureTableView()
        
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        
        addButtonView.layer.cornerRadius = addButtonView.bounds.height / 2
        addButtonView.layer.masksToBounds = true

        updateProgress()
        
        if let group {
            titleLabel.text = group.title
            
            let colors = [group.startColor, group.endColor]
            let buttonLayer = Utils.getVerticalLayer(frame: CGRect(x: 0, y: 0, width: 70, height: 70), colors: colors)
            addButtonView.layer.addSublayer(buttonLayer)
            
            let progressLayer = Utils.getHorizontalLayer(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5.0), colors: colors)
            progress.progressImage = progressLayer.createGradientImage()
        }
        
      tableView.reloadData()
    }
    
    func configureHeroID() {
        let id = group?.groupId ?? 0
        view.hero.id = AppHeroId.viewGroupDetail.getId(id: id)
        titleLabel.hero.id = AppHeroId.title.getId(id: id)
        progress.hero.id = AppHeroId.progress.getId(id: id)
        percentLabel.hero.id = AppHeroId.percent.getId(id: id)
        addButtonView.hero.id = AppHeroId.button.getId(id: id)
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
    }
    
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = todos[indexPath.row]
        
        if data.isDateNoti && data.isLocationNoti {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTwoNotiCell", for: indexPath) as! TaskTwoNotiCell
//            cell.dateNotiTitle.text = setNotiDate(data)
            cell.locNotiTitle.text = "\(data.isLocationNoti) \(data.locationNotiType.rawValue)"
            cell.taskTitle.text = data.title
            if data.isComplete {
                cell.imgDateNoti.image = UIImage(named: "alarm_gray")
                cell.imgLocNoti.image = UIImage(named: "map_gray")
                cell.imgCheck.image = UIImage(named: "check_gray")
                cell.dateNotiTitle.textColor = .lightGray
                cell.locNotiTitle.textColor = .lightGray
                cell.taskTitle.textColor = .lightGray
                let attribute = NSMutableAttributedString(string: cell.taskTitle.text ?? "")
                attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attribute.length))
                cell.taskTitle.attributedText = attribute
            } else {
                cell.imgDateNoti.image = UIImage(named: "alarm_default")
                cell.imgLocNoti.image = UIImage(named: "map_default")
                cell.imgCheck.image = UIImage(named: "uncheck_default")
                cell.dateNotiTitle.textColor = UIColor(rgb: 0x39393E)
                cell.locNotiTitle.textColor = UIColor(rgb: 0x39393E)
                cell.taskTitle.textColor = UIColor(rgb: 0x39393E)
                // cc
            }
            return cell
        } else if data.isDateNoti {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskOneNotiCell", for: indexPath) as! TaskOneNotiCell
//            cell.notiTitle.text = setNotiDate(data)
            cell.taskTitle.text = data.title
            if data.isComplete {
                cell.imgNoti.image = UIImage(named: "alarm_gray")
                cell.imgCheck.image = UIImage(named: "check_gray")
                cell.notiTitle.textColor = .lightGray
                cell.taskTitle.textColor = .lightGray
                // cc
                let attribute = NSMutableAttributedString(string: cell.taskTitle.text ?? "")
                attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attribute.length))
                cell.taskTitle.attributedText = attribute
            } else {
                cell.imgNoti.image = UIImage(named: "alarm_default")
                cell.imgCheck.image = UIImage(named: "uncheck_default")
                cell.notiTitle.textColor = UIColor(rgb: 0x39393E)
                cell.taskTitle.textColor = UIColor(rgb: 0x39393E)
                // cc
            }
            return cell
        } else if data.isLocationNoti {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskOneNotiCell", for: indexPath) as! TaskOneNotiCell
            cell.notiTitle.text = "\(data.locationName) \(data.locationNotiType.rawValue)"
            cell.taskTitle.text = data.title
            if data.isComplete {
                cell.imgNoti.image = UIImage(named: "map_gray")
                cell.imgCheck.image = UIImage(named: "check_gray")
                cell.notiTitle.textColor = .lightGray
                cell.taskTitle.textColor = .lightGray
                //  cc
                let attribute = NSMutableAttributedString(string: cell.taskTitle.text ?? "")
                attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attribute.length))
                cell.taskTitle.attributedText = attribute
            } else {
                cell.imgNoti.image = UIImage(named: "map_default")
                cell.imgCheck.image = UIImage(named: "uncheck_default")
                cell.notiTitle.textColor = UIColor(rgb: 0x39393E)
                cell.taskTitle.textColor = UIColor(rgb: 0x39393E)
                // cc
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            cell.taskTitle.text = data.title
            if data.isComplete {
                cell.imgCheck.image = UIImage(named: "check_gray")
                cell.taskTitle.textColor = .lightGray
                // cc
                let attribute = NSMutableAttributedString(string: cell.taskTitle.text ?? "")
                attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attribute.length))
                cell.taskTitle.attributedText = attribute
            } else {
                cell.imgCheck.image = UIImage(named: "uncheck_default")
                cell.taskTitle.textColor = UIColor(rgb: 0x39393E)
                // cc
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        CommonRealmDB.shared.updateTaskCheck(gIndex: groupIndex, tIndex: index) { (response) in
//            if response {
//                tableView.reloadRows(at: [indexPath], with: .none)
//                self.updateProgress(animated: true)
//            }
//        }
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let tModify = modifyTask(at: indexPath)
//        let tDelete = deleteTask(at: indexPath)
//        return UISwipeActionsConfiguration(actions: [tDelete,tModify])
//    }
}
