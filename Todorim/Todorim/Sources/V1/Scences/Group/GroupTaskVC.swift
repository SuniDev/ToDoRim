//
//  GroupTaskVC.swift
//  HSTODO
//
//  Created by 박현선 on 22/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class GroupTaskVC: UIViewController {

    // Outlet
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var textPercent: UILabel!
    @IBOutlet weak var taskProgress: UIProgressView!
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // var
    var groupIndex = 0
    var numberOfTask = 0
    var timeFormatter: DateFormatter!
    var gradientLayer: CAGradientLayer!
    var currentColorSet = [CGColor]()
    var isInit = true
    
    // let
    let arrWeek = ["일요일","월요일","화요일","수요일","목요일","금요일","토요일"]
    
    // Action
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .none
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goModify(_ sender: UIButton) {
        
//        CommonNav.shared.moveModifyGroup(groupIndex, self)
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        
//        CommonNav.shared.moveAddTask(groupIndex, self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registHeroId()
        
        timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.timeStyle = .short
        timeFormatter.dateFormat =  "a hh:mm"
        
        
        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        tableView.register(UINib(nibName: "TaskTwoNotiCell", bundle: nil), forCellReuseIdentifier: "TaskTwoNotiCell")
        tableView.register(UINib(nibName: "TaskOneNotiCell", bundle: nil), forCellReuseIdentifier: "TaskOneNotiCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        taskProgress.transform = taskProgress.transform.scaledBy(x: 1, y: 2)
        
        viewAdd.layer.cornerRadius = viewAdd.bounds.height / 2
        viewAdd.layer.masksToBounds = true
        
        updateProgress(animated: false)
        
        let sColor = CommonGroup.shared.getStartColor(gIndex: groupIndex)
        let eColor = CommonGroup.shared.getEndColor(gIndex: groupIndex)
        let colors = [UIColor(rgb: sColor), UIColor(rgb: eColor)]
        gradientLayer = CAGradientLayer(frame: CGRect(x: 0, y: 0, width: 70, height: 70), colors: colors, startPoint: CGPoint(x: 0, y:0.5), endPoint: CGPoint(x:1.0, y:0.5))
        viewAdd.layer.addSublayer(gradientLayer)
        
        let progressLayer = CAGradientLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5.0), colors: colors, startPoint: CGPoint(x: 0, y:0.5), endPoint: CGPoint(x: 1.0, y:0.5))
        taskProgress.progressImage = progressLayer.createGradientImage()
        
        numberOfTask = CommonGroup.shared.getAllTask(gIndex: groupIndex)
        
        
        isInit = false
    }

    override func viewWillAppear(_ animated: Bool) {
        if groupIndex < CommonGroup.shared.count() && !isInit {
            print("groupIndex; \(groupIndex)")
            textTitle.text = CommonGroup.shared.arrGroup[groupIndex].title
            
            updateProgress(animated: false)
            
            var colors = [UIColor]()
            colors.append(UIColor(rgb: CommonGroup.shared.getStartColor(gIndex: groupIndex)))
            colors.append(UIColor(rgb: CommonGroup.shared.getEndColor(gIndex: groupIndex)))
            let progressLayer = CAGradientLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5.0), colors: colors, startPoint: CGPoint(x: 0, y:0.5), endPoint: CGPoint(x: 1.0, y:0.5))
            taskProgress.progressImage = progressLayer.createGradientImage()
            colorChange([colors[0].cgColor,colors[1].cgColor])
            
            numberOfTask = CommonGroup.shared.getAllTask(gIndex: groupIndex)
            print("numberOfTask; \(numberOfTask)")
        
            tableView.reloadData()
        }
    }
    
}

// MARK: - extension
extension GroupTaskVC {
    
    func registHeroId() {
        view.hero.id = "view_\(groupIndex)"
        textTitle.hero.id = "title_\(groupIndex)"
        taskProgress.hero.id = "progress_\(groupIndex)"
        textPercent.hero.id = "percent_\(groupIndex)"
        
        viewAdd.hero.id = "taskAdd_\(groupIndex)"
    }
    
    func colorChange(_ colors: [CGColor]) {
        currentColorSet = colors
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.duration = 0.1
        colorAnimation.toValue = currentColorSet
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.delegate = self
        gradientLayer.add(colorAnimation, forKey: "colorChange")
    }
    
    func updateProgress(animated: Bool) {
        
        var percent: Float = 0.0
        if CommonGroup.shared.getCheckTask(gIndex: groupIndex) == 0 {
            percent = 0.0
            textPercent.text = "0 %"
        } else {
            percent = Float(CommonGroup.shared.getCheckTask(gIndex: groupIndex)) / Float(CommonGroup.shared.getAllTask(gIndex: groupIndex))
            textPercent.text = "\(Int(percent * 100)) %"
        }

        taskProgress.setProgress(percent, animated: animated)
    }
    
    func modifyTask(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            let index = self.numberOfTask - indexPath.row - 1
//            let taskNo = CommonGroup.shared.getTask(gIndex: self.groupIndex, tIndex: index).taskNo
//            CommonNav.shared.moveModifyTask(gIndex: self.groupIndex, tIndex: index, self)
            completion(true)
        }
        action.image = UIImage(named: "edit_white")
        action.backgroundColor = .lightGray
        
        return action
    }
    
    func deleteTask(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            
            let index = self.numberOfTask - indexPath.row - 1
//            let taskNo = CommonGroup.shared.getTask(gIndex: self.groupIndex, tIndex: index).taskNo
            CommonRealmDB.shared.deleteTask(gIndex: self.groupIndex, tIndex: index) { (response) in
                self.numberOfTask = self.numberOfTask - 1
                //                tableView.reloadData()
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.updateProgress(animated: true)
            }
            completion(true)
        }
        action.image = UIImage(named: "delete_white")
        action.backgroundColor = UIColor(rgb: 0x8C170B)
        
        return action
    }
    
    func setNotiDate(_ data: DataTaskv2) -> String {
        var strDate = ""
        
        switch data.repeatType {
        case .none:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat =  "M월 d일(EEEE) a hh:mm"
            strDate = "\(dateFormatter.string(from: data.date))"
        case .daily:
            strDate = "매일 \(timeFormatter.string(from: data.date))"
        case .weekly:
            strDate = "매주 \(arrWeek[data.week-1]) \(timeFormatter.string(from: data.date))"
        case .monthly:
            strDate = "매월 \(data.day)일 \(timeFormatter.string(from: data.date))"
        }
        
        return strDate
    }
}

// MARK: - CAAnimationDelegate
extension GroupTaskVC: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        gradientLayer.colors = currentColorSet
    }
}


// MARK: - @objc
@objc extension GroupTaskVC {
    
}

// MARK: - UITableView
extension GroupTaskVC: UITableViewDelegate, UITableViewDataSource {
    

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let index = numberOfTask - indexPath.row - 1
//        let data = CommonGroup.shared.getTask(gIndex: groupIndex, tIndex: index)
//        if data.isDateNoti && data.isLocNoti {
//            return 110
//        } else if data.isDateNoti || data.isLocNoti{
//            return 85
//        } else {
//            return 60
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfTask
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = numberOfTask - indexPath.row - 1
        let data = CommonGroup.shared.getTask(gIndex: groupIndex, tIndex: index)
        if data.isDateNoti && data.isLocNoti {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTwoNotiCell", for: indexPath) as! TaskTwoNotiCell
            cell.dateNotiTitle.text = setNotiDate(data)
            cell.locNotiTitle.text = "\(data.locTitle) \(data.locType.rawValue)"
            cell.taskTitle.text = data.title
            if data.isCheck {
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
            cell.notiTitle.text = setNotiDate(data)
            cell.taskTitle.text = data.title
            if data.isCheck {
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
        } else if data.isLocNoti {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskOneNotiCell", for: indexPath) as! TaskOneNotiCell
            cell.notiTitle.text = "\(data.locTitle) \(data.locType.rawValue)"
            cell.taskTitle.text = data.title
            if data.isCheck {
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
            if data.isCheck {
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
        let index = numberOfTask - indexPath.row - 1
        CommonRealmDB.shared.updateTaskCheck(gIndex: groupIndex, tIndex: index) { (response) in
            if response {
                tableView.reloadRows(at: [indexPath], with: .none)
                self.updateProgress(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tModify = modifyTask(at: indexPath)
        let tDelete = deleteTask(at: indexPath)
        return UISwipeActionsConfiguration(actions: [tDelete,tModify])
    }
    
}
