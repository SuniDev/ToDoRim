//
//  AddTaskVC.swift
//  HSTODO
//
//  Created by 박현선 on 23/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class AddTaskVC: UIViewController {

    // outlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomGuideView: UIView!
    
    @IBOutlet weak var textViewTitle: UILabel!
    @IBOutlet weak var textTitle: MadokaTextField!
    @IBOutlet weak var textGroup: UITextField!
    @IBOutlet weak var textTime: UITextField!
    @IBOutlet weak var textDate: UITextField!
    @IBOutlet weak var textWeek: UITextField!
    @IBOutlet weak var textDay: UITextField!
    @IBOutlet weak var textDaily: UITextField!
    
    @IBOutlet weak var switchDate: UISwitch!
    @IBOutlet weak var viewDateNoti: UIView!
    @IBOutlet weak var viewDateArea: UIView!
    
    @IBOutlet weak var switchLocation: UISwitch!
    @IBOutlet weak var viewLocationNoti: UILabel!
    @IBOutlet weak var viewLocationArea: UIView!
    
    @IBOutlet weak var constBtnAddBottom: NSLayoutConstraint!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnNone: UIButton!
    @IBOutlet weak var btnDaily: UIButton!
    @IBOutlet weak var btnWeekly: UIButton!
    @IBOutlet weak var btnMonthly: UIButton!
    
    
    @IBOutlet weak var viewSearchLoc: UIView!
    @IBOutlet weak var textLocation: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    
    // var
    var groupIndex = 0
    var superVC: UIViewController!
    
    var groupPicker: CustomGroupPicker?
    var timePicker: CustomTimePicker?
    var dayPicker: CustomDayPicker?
    var weekPicker: CustomWeekPicker?
    var datePicker: CustomDatePicker?
    
    var tabButton = CustomTabButton()
    var coordinate: CLLocationCoordinate2D!
    var isSelectLoc = false
    var locationType: LocationConfig!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var radius: Double = 100.0
    var locationTitle = ""
    var taskTitle = ""
    var taskDate = Date()
    var taskWeek = 1
    var taskDay = 1
    var timeFormatter = DateFormatter()
    var dateFormatter = DateFormatter()
    var selectedRepeat: RepeatConfig = .none
    var currentColor = UIColor()
    
    // modify
    var modify = false
//    var taskNo = 0
    var taskIndex = 0
    var isCheck = false
    
    
    // let
    let gPickerView = UIPickerView()
    let wPickerView = UIPickerView()
    let dPickerView = UIPickerView()
    
    // Action
    
    @IBAction func textTitleChanged(_ sender: MadokaTextField) {
        sender.setMaxLength(max: 30)
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchDateNoti(_ sender: UISwitch) {
        if sender.isOn{
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound], completionHandler: {didAllow,Error in
                if !didAllow {
                    DispatchQueue.main.async {
                    self.dismissKeyboard()
                    let alert = UIAlertController(title: "알림 서비스를 이용할 수 없습니다.", message: "기기의 '설정 > ToDoRim' 에서 알림을 허용해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction = UIAlertAction(title: "확인", style: .default) 
                    alert.addAction(defaultAction)
                    self.present(alert, animated: false, completion: nil)
                    }
                }
            })
        }
        setDateNotiArea()
    }
    
    @IBAction func switchLocationNoti(_ sender: UISwitch) {
        if sender.isOn{
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound], completionHandler: {didAllow,Error in
                if !didAllow {
                    DispatchQueue.main.async {
                    self.dismissKeyboard()
                    let alert = UIAlertController(title: "알림 서비스를 이용할 수 없습니다.", message: "기기의 '설정 > ToDoRim' 에서 알림을 허용해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: false, completion: nil)
                    }
                }
            })
        }
        setLocationNotiArea()
    }
    
    @IBAction func actionNoneRepeat(_ sender: UIButton) {
        selectedRepeat = .none
        changeRepeat(true,false,false,false)
    }
    
    @IBAction func actionDailyRepeat(_ sender: UIButton) {
        selectedRepeat = .daily
        changeRepeat(false,true,false,false)
    }
    
    @IBAction func actionWeeklyRepeat(_ sender: UIButton) {
        selectedRepeat = .weekly
        changeRepeat(false,false,true,false)
        
    }
    
    @IBAction func actionMonthlyRepeat(_ sender: UIButton) {
        selectedRepeat = .monthly
        changeRepeat(false,false,false,true)
        
    }
    
    
    @IBAction func addTask(_ sender: UIButton) {
        
        if checkText() {
            let data = DataTaskv2()
            data.title = taskTitle
            data.isCheck = isCheck
            data.tOrder = CommonRealmDB.shared.getTaskOrder()
//            data.tOrder = CommonGroup.shared.getMaxTOrder(gIndex: groupIndex)
            if switchDate.isOn {
                data.isDateNoti = true
                data.repeatType = selectedRepeat
                data.date = taskDate
                data.week = taskWeek
                data.day = taskDay
            }
            
            if switchLocation.isOn {
                data.isLocNoti = true
                data.radius = radius
                data.longitude = longitude
                data.latitude = latitude
                data.locType = locationType
                data.locTitle = locationTitle
            }
            
            
            // modify
            if modify {
                data.taskNo = CommonGroup.shared.arrGroup[groupIndex].listTask[taskIndex].taskNo
                CommonRealmDB.shared.updateTask(gIndex: groupIndex, tIndex: taskIndex, data: data) { (response) in
                    if response {
                        self.navigationController?.hero.isEnabled = true
                        self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            } else {
                let groupNo = groupPicker?.selectedGroup ?? groupIndex
                data.taskNo = CommonRealmDB.shared.getTaskNo()
//                data.taskNo = CommonGroup.shared.getMaxTaskNo(gIndex: groupIndex)
                CommonRealmDB.shared.writeTask(gIndex: groupNo, data: data) { (response) in
                    if response {
                        self.navigationController?.hero.isEnabled = true
                        self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
            
            let window = UIApplication.shared.keyWindow
            
            if let bottomPadding = window?.safeAreaInsets.bottom {
                let layoutHeight = bottomGuideView.constraints.filter{ $0.identifier == "guideHeight" }.first
                layoutHeight?.constant = bottomPadding
            }
        }

        timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.timeStyle = .short
        timeFormatter.dateFormat =  "a hh:mm"
        
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat =  "yy년 M월 d일 (EEEE)"
        
        createKeyboardEvent()
        
        // group picker 세팅
        let groupArr = CommonGroup.shared.getTitleArr()
        let noArr = CommonGroup.shared.getNoArr()
        
        groupPicker = CustomGroupPicker(textField: textGroup, array: groupArr, arrNo: noArr, initIndex: groupIndex)
        gPickerView.delegate = groupPicker
        gPickerView.dataSource = groupPicker
        
        // time picker 세팅
        timePicker = CustomTimePicker(textField: textTime)
        datePicker = CustomDatePicker(textField: textDate)
        
        // date picker 세팅
        weekPicker = CustomWeekPicker(textField: textWeek)
        wPickerView.delegate = weekPicker
        wPickerView.dataSource = weekPicker
        
        dayPicker = CustomDayPicker(textField: textDay)
        dPickerView.delegate = dayPicker
        dPickerView.dataSource = dayPicker
        
        
        textTitle.delegate = self
        textGroup.inputView = gPickerView
        textGroup.inputAccessoryView = groupPicker?.makeDone(VC: self)
        textWeek.inputView = wPickerView
        textWeek.inputAccessoryView = weekPicker?.makeDone(VC: self)
        textDay.inputView = dPickerView
        textDay.inputAccessoryView = dayPicker?.makeDone(VC: self)
        
        changeRepeat(true, false, false, false)
        
        selectedRepeat = .none
        
        
        // date switch 세팅
        let tapDate = UITapGestureRecognizer(target: self, action: #selector(tapDateNoti(_:)))
        viewDateNoti.addGestureRecognizer(tapDate)
        
        // location switch 세팅
        let tapLoc = UITapGestureRecognizer(target: self, action: #selector(tapLocationNoti(_:)))
        viewLocationNoti.addGestureRecognizer(tapLoc)
        
        // color 세팅
        let sColor = CommonGroup.shared.getStartColor(gIndex: groupIndex)
        let eColor = CommonGroup.shared.getEndColor(gIndex: groupIndex)
        currentColor = UIColor(rgb: eColor)
        
        let colors = [UIColor(rgb: sColor), UIColor(rgb: eColor)]
        let gradientLayer = CAGradientLayer(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 90), colors: colors, startPoint: CGPoint(x: 0, y:0.5), endPoint: CGPoint(x: 1.0, y:0.5))
        btnAdd.layer.addSublayer(gradientLayer)
        
        switchDate.onTintColor = currentColor
        switchLocation.onTintColor = currentColor
        
        // repeat type tab 세팅
        tabButton.initRepeatButton(btn: btnNone, tag: 0, color: currentColor)
        tabButton.initRepeatButton(btn: btnDaily, tag: 1, color: currentColor)
        tabButton.initRepeatButton(btn: btnWeekly, tag: 2, color: currentColor)
        tabButton.initRepeatButton(btn: btnMonthly, tag: 3, color: currentColor)
        
        tabButton.repeatBtnSelected(sender: btnNone)
        
        // location select 세팅
        let tapSearchLoc = UITapGestureRecognizer(target: self, action: #selector(tapSearchLocation(_:)))
        viewSearchLoc.addGestureRecognizer(tapSearchLoc)
        
        // modify
        if modify {
            let task = CommonGroup.shared.getTask(gIndex: groupIndex, tIndex: taskIndex)
//            let task = CommonTask.shared.get(taskNo)
            taskTitle = task.title
            textTitle.text = taskTitle
            isCheck = task.isCheck
            gPickerView.selectRow(groupIndex, inComponent: 0, animated: false)
            textGroup.isEnabled = false
            textGroup.textColor = .lightGray
            
            if  task.isDateNoti {
                taskDate = task.date
                switchDate.isOn = true
//                dPickerView.date = taskDate
//                print(dateFormatter.string(from: taskDate))
                textTime.text = timeFormatter.string(from: taskDate)
                selectedRepeat = task.repeatType
                timePicker?.selectedDate = task.date
                switch task.repeatType {
                case .none:
                    tabButton.repeatBtnSelected(sender: btnNone)
                    changeRepeat(true,false,false,false)
                    textDate.text = dateFormatter.string(from: task.date)
                    datePicker?.selectedDate = task.date
                case .daily:
                    tabButton.repeatBtnSelected(sender: btnDaily)
                    changeRepeat(false,true,false,false)
                case .weekly:
                    taskWeek = task.week
                    print(taskWeek)
                    tabButton.repeatBtnSelected(sender: btnWeekly)
                    changeRepeat(false,false,true,false)
//                    let week = task.date
//                    let wc = Calendar.current.dateComponents([.weekday], from: week)
                    let row = task.week - 1
                    textWeek.text = weekPicker?.array[row]
                    weekPicker?.selectedWeek = task.week
                case .monthly:
                    taskDay = task.day
                    print(taskDay)
                    tabButton.repeatBtnSelected(sender: btnMonthly)
                    changeRepeat(false,false,false,true)
//                    let month = task.date
//                    let mc = Calendar.current.dateComponents([.month], from: month)
                    let row = task.day - 1
                    textDay.text = dayPicker?.array[row]
                    dayPicker?.selectedDay = task.day
                }
                
            } else {
                switchDate.isOn = false
            }
            
            if task.isLocNoti {
                switchLocation.isOn = true
                locationType = task.locType
                locationTitle = task.locTitle
                longitude = task.longitude
                latitude = task.latitude
                radius = task.radius
                textLocation.text = "\(locationTitle) \(locationType.rawValue)"
                textLocation.textColor = UIColor(rgb: 0x39393E)
            } else {
                switchLocation.isOn = false
            }
            
            textViewTitle.text = "할일 수정"
            lblAdd.text = "수정"
            
            radius = task.radius
            
        } else {
        }
        
        btnAdd.hero.id = "taskAdd_\(groupIndex)"
        //            bottomGuideView.hero.id = "taskAdd_\(groupIndex)"
        
        
        setDateNotiArea()
        setLocationNotiArea()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }

}

// MARK: - extension
extension AddTaskVC {

    
    // 키보드 기본 처리
    func createKeyboardEvent() {
        // 키보드가 팝업되거나 숨김 처리될 때 화면 처리 noti
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 화면 터치 시 키보드 숨김
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    
    }
//
//    // 텍스트필드 포커스
//    func textResignFirstResponder() {
//        dismissKeyboard()
////        textDay.resignFirstResponder()
////        textDate.resignFirstResponder()
////        textTime.resignFirstResponder()
////        textWeek.resignFirstResponder()
////        textDaily.resignFirstResponder()
////        textGroup.resignFirstResponder()
////        textTitle.resignFirstResponder()
//    }
    
    
    // 텍스트필드 체크
    func checkText() -> Bool {
        
        if let title = textTitle.text {
            if title.isEmpty() {
                dismissKeyboard()
                let alert = UIAlertController(title: "할일 이름을 입력하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(defaultAction)
                self.present(alert, animated: false, completion: nil)
                return false
            } else {
                self.taskTitle = title
            }
        } else {
            return false
        }
        
        
        if switchDate.isOn {
            
            switch selectedRepeat {
            case .none:
                if let date = textDate.text {
                    if date.isEmpty() {
                        dismissKeyboard()
                        let alert = UIAlertController(title: "알림 날짜를 선택하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                        let defaultAction = UIAlertAction(title: "확인", style: .default)
                        alert.addAction(defaultAction)
                        self.present(alert, animated: false, completion: nil)
                        return false
                    }
                }
            case .daily: break
            case .weekly:
                if let date = textWeek.text {
                    if date.isEmpty() {
                        dismissKeyboard()
                        let alert = UIAlertController(title: "알림 요일을 선택하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                        let defaultAction = UIAlertAction(title: "확인", style: .default)
                        alert.addAction(defaultAction)
                        self.present(alert, animated: false, completion: nil)
                        return false
                    }
                }
            case .monthly:
                if let date = textDay.text {
                    if date.isEmpty() {
                        dismissKeyboard()
                        let alert = UIAlertController(title: "알림 월을 선택하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                        let defaultAction = UIAlertAction(title: "확인", style: .default)
                        alert.addAction(defaultAction)
                        self.present(alert, animated: false, completion: nil)
                        return false
                    }
                }
            }
            
            if let date = textTime.text {
                if date.isEmpty() {
                    dismissKeyboard()
                    let alert = UIAlertController(title: "알림 시간을 선택하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: false, completion: nil)
                    return false
                } else {
                    taskDate = setDate()!
                }
            } else {
                return false
            }
        }
        
        if switchLocation.isOn {
            if textLocation.text == "위치 선택" {
                dismissKeyboard()
                    let alert = UIAlertController(title: "알림 위치를 선택하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: false, completion: nil)
                    return false
            }
        }
        
        return true
    }
    
    func changeRepeat(_ none: Bool, _ daily: Bool, _ week: Bool, _ day: Bool) {
        textDate.isHidden = !none
        textDaily.isHidden = !daily
        textWeek.isHidden = !week
        textDay.isHidden = !day
    }
    
    func setDate() -> Date? {
        
        var dateComponents = DateComponents()
        let time = timePicker?.selectedDate ?? Date()
        
        switch selectedRepeat {
        case .none:
            let date = datePicker?.selectedDate ?? Date()
            let dc = Calendar.current.dateComponents([.year,.month,.day], from: date)
            dateComponents.year = dc.year
            dateComponents.month = dc.month
            dateComponents.day = dc.day
        case .daily: break
        case .weekly:
            taskWeek = weekPicker?.selectedWeek ?? 1
//            dateComponents.weekday = weekPicker?.selectedWeek
        case .monthly:
            taskDay = dayPicker?.selectedDay ?? 1
//            dateComponents.day = dayPicker?.selectedDay
        }
        
        let tc = Calendar.current.dateComponents([.hour,.minute], from: time)
        
        
        dateComponents.hour = tc.hour
        dateComponents.minute = tc.minute
        
        return Calendar.current.date(from: dateComponents)
    }
}

// MARK: - @objc
@objc extension AddTaskVC {
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 키보드 팝업 처리
    func keyboardWillShow(_ sender: Notification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        constBtnAddBottom.constant = keyboardHeight - 40
        view.layoutIfNeeded()
    }
    
    // 키보드 숨김 처리
    func keyboardWillHide(_ sender: Notification) {
        
        constBtnAddBottom.constant = -40
        view.layoutIfNeeded()
    }
    
    func tapDateNoti(_ notification: NSNotification) {
        switchDate.setOn(!switchDate.isOn, animated: true)
        setDateNotiArea()
    }
    
    func tapLocationNoti(_ notification: NSNotification) {
        switchLocation.setOn(!switchLocation.isOn, animated: true)
        setLocationNotiArea()
    }
    
    func tapSearchLocation(_ notification: NSNotification) {
        CommonNav.shared.moveSearchLoc(superVC: self)
    }
    
    func setDateNotiArea() {
        self.view.layoutIfNeeded()
            for const in viewDateArea.constraints {
                if const.identifier == "constHeight" {
                    viewDateArea.removeConstraint(const)
                }
            }
        self.viewDateArea.isHidden = !self.switchDate.isOn
        
            if switchDate.isOn {
                let const = NSLayoutConstraint(item: viewDateArea ?? UIView(), attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200.0)
                viewDateArea.addConstraint(const)
                const.identifier = "constHeight"
                NSLayoutConstraint.activate([const])
                
            } else {
                let const = NSLayoutConstraint(item: viewDateArea ?? UIView(), attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
                const.identifier = "constHeight"
                viewDateArea.addConstraint(const)
                NSLayoutConstraint.activate([const])
            }
        
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
    }
    
    func setLocationNotiArea() {
        self.view.layoutIfNeeded()
        for const in viewLocationArea.constraints {
            if const.identifier == "constHeight" {
                viewLocationArea.removeConstraint(const)
            }
        }
        
        self.viewLocationArea.isHidden = !self.switchLocation.isOn
        
        if switchLocation.isOn {
            let const = NSLayoutConstraint(item: viewLocationArea ?? UIView(), attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120.0)
            viewLocationArea.addConstraint(const)
            const.identifier = "constHeight"
            NSLayoutConstraint.activate([const])
        } else {
            let const = NSLayoutConstraint(item: viewLocationArea ?? UIView(), attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
            const.identifier = "constHeight"
            viewLocationArea.addConstraint(const)
            NSLayoutConstraint.activate([const])
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            
        }) { (complete) in
        }
    }
    
}

// MARK: - SelectLocationDelegate
extension AddTaskVC: SelectLocationDelegate {
    func SearchLocationMapVC(_ controllers: [UIViewController], didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, eventType: LocationConfig, name: String) {
        for vc in controllers {
            vc.navigationController?.popViewController(animated: true)
        }
        self.coordinate = coordinate
        self.longitude = coordinate.longitude
        self.latitude = coordinate.latitude
        self.radius = radius
        self.locationType = eventType
        self.locationTitle = name
        
        textLocation.text = "\(name) \(eventType.rawValue)"
        textLocation.textColor = UIColor(rgb: 0x39393E)
    }
}

// MARK: - UITextField
extension AddTaskVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        print("???")
        return true
    }
}
