//
//  WriteTodoViewController.swift
//  Todorim
//
//  Created by suni on 8/14/24.
//

import UIKit
import CoreLocation
import Hero

protocol WriteTodoViewControllerDelegate: AnyObject {
    func completeWriteTodo(todo: Todo)
}
class WriteTodoViewController: UIViewController {
    
    // MARK: - Data
    var todoStorage: TodoStorage?
    var todo: Todo?
    var group: Group?
    var writeTodo: Todo = Todo()
    var groups: [Group] = []
    
    var groupPicker: GroupPicker?
    var timePicker: TimePicker?
    var dayPicker: DayPicker?
    var weekPicker: WeekPicker?
    var datePicker: DatePicker?
    
    var dateTabButton = TabButton()
    
    let groupPickerView = UIPickerView()
    let weekPickerView = UIPickerView()
    let dayPickerView = UIPickerView()
    
    weak var delegate: WriteTodoViewControllerDelegate?
        
    // MARK: - Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: MadokaTextField!
    @IBOutlet weak var groupTitleTextField: PickerTextField!
    @IBOutlet weak var timeTextField: PickerTextField!
    @IBOutlet weak var dateTextField: PickerTextField!
    @IBOutlet weak var weekTextField: PickerTextField!
    @IBOutlet weak var dayTextField: PickerTextField!
    @IBOutlet weak var dailyTextField: PickerTextField!
    
    @IBOutlet weak var dateNotiSwitch: UISwitch!
    @IBOutlet weak var dateSelectView: UIView!
    @IBOutlet weak var dateNotiViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dateNotiNoneButton: UIButton!
    @IBOutlet weak var dateNotiDailyButton: UIButton!
    @IBOutlet weak var dateNotiWeeklyButton: UIButton!
    @IBOutlet weak var dateNotiMonthlyButton: UIButton!
        
    @IBOutlet weak var locationNotiSwitch: UISwitch!
    @IBOutlet weak var locationSelectView: UIView!
    @IBOutlet weak var locationSearchView: UIView!
    @IBOutlet weak var locationSelectViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var completeButtonLabel: UILabel!
    @IBOutlet weak var completeButtonView: UIView!
    
    // MARK: - Action
    @IBAction func changedTitleTextField(_ sender: MadokaTextField) {
        sender.setMaxLength(max: 30)
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changedDateNotiSwitch(_ sender: UISwitch) {
        if sender.isOn{
            writeTodo.isDateNoti = true
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
        } else {
            // Init
            writeTodo.isDateNoti = false
            writeTodo.date = nil
            writeTodo.weekType = .none
            writeTodo.day = 0
            writeTodo.repeatNotiType = .none
        }
        configureDateNotiUI()
    }
    
    @IBAction func changedLocationNotiSwitch(_ sender: UISwitch) {
        if sender.isOn {
            writeTodo.isLocationNoti = true
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound], completionHandler: { didAllow, Error in
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
        } else {
            // Init
            writeTodo.isLocationNoti = false
            writeTodo.longitude = 0
            writeTodo.latitude = 0
            writeTodo.radius = 100.0
            writeTodo.locationName = ""
            writeTodo.locationNotiType = .none
        }
        configureLocationNotiUI()
    }
    
    @IBAction func tappedDateNotiNoneButton(_ sender: UIButton) {
        selectRepeat(type: .none)
    }
    
    @IBAction func tappedDateNotiDailyButton(_ sender: UIButton) {
        selectRepeat(type: .daily)
    }
    
    @IBAction func tappepDateNotiWeeklyButton(_ sender: UIButton) {
        selectRepeat(type: .weekly)
    }
    
    @IBAction func tappepDateNotiMonthlyButton(_ sender: UIButton) {
        selectRepeat(type: .monthly)
    }
    
    @IBAction func tappedCompleteButton(_ sender: UIButton) {
        if checkValidData() {
            if let todo {
                // Update todo
                todoStorage?.update(with: todo, writeTodo: writeTodo, completion: { [weak self] isSuccess, todo in
                    guard let self else { return }
                    if isSuccess {
                        self.delegate?.completeWriteTodo(todo: todo)
                        self.navigationController?.hero.isEnabled = true
                        self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        // TODO: 오류 메시지
                    }
                })
            } else {
                // New Todo
                todoStorage?.add(writeTodo)
                delegate?.completeWriteTodo(todo: writeTodo)
                self.navigationController?.hero.isEnabled = true
                self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeroID()
        
        createKeyboardEvent()
        
        configureData()
        configurePicker()
        configureTextField()
                
        configureUIWithColor()
        configureUIWithData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    
    func configureData() {
        guard let todoStorage, let group else { return }
                
        writeTodo.groupId = group.groupId
        if let todo {
            writeTodo.todoId = todo.todoId
            writeTodo.order = todo.order
            writeTodo.title = todo.title
            writeTodo.isDateNoti = todo.isDateNoti
            writeTodo.date = todo.date
            writeTodo.weekType = todo.weekType
            writeTodo.day = todo.day
            writeTodo.repeatNotiType = todo.repeatNotiType
            writeTodo.isLocationNoti = todo.isLocationNoti
            writeTodo.locationName = todo.locationName
            writeTodo.locationNotiType = todo.locationNotiType
            writeTodo.longitude = todo.longitude
            writeTodo.latitude = todo.latitude
            writeTodo.radius = todo.radius
        } else {
            writeTodo.todoId = todoStorage.getNextId()
            writeTodo.order = todoStorage.getNextOrder()
        }
    }
    
    func configurePicker() {
        
        // group picker 세팅
        groupPicker = GroupPicker(textField: groupTitleTextField, groups: groups, selectedGroup: group)
        groupPickerView.delegate = groupPicker
        groupPickerView.dataSource = groupPicker
        
        // time picker 세팅
        timePicker = TimePicker(textField: timeTextField)
        datePicker = DatePicker(textField: dateTextField)
        
        // date picker 세팅
        weekPicker = WeekPicker(textField: weekTextField)
        weekPickerView.delegate = weekPicker
        weekPickerView.dataSource = weekPicker
        
        dayPicker = DayPicker(textField: dayTextField)
        dayPickerView.delegate = dayPicker
        dayPickerView.dataSource = dayPicker
    }
    
    func configureTextField() {
        titleTextField.delegate = self
        groupTitleTextField.inputView = groupPickerView
        groupTitleTextField.inputAccessoryView = groupPicker?.makeDone()
        weekTextField.inputView = weekPickerView
        weekTextField.inputAccessoryView = weekPicker?.makeDone()
        dayTextField.inputView = dayPickerView
        dayTextField.inputAccessoryView = dayPicker?.makeDone()
    }
    
    func configureUIWithColor() {
        completeButtonView.layer.cornerRadius = 15
        completeButtonView.layer.masksToBounds = true
        
        let colors = GroupColor.getColors(index: group?.appColorIndex ?? 0)
        let gradientLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 70), colors: colors)
        completeButtonView.layer.addSublayer(gradientLayer)
        
        dateNotiSwitch.onTintColor = colors[1]
        locationNotiSwitch.onTintColor = colors[1]
        
        // repeat button 세팅
        dateTabButton.initButton(type: .dateRepeat, color: colors[1], buttons: [dateNotiNoneButton, dateNotiDailyButton, dateNotiWeeklyButton, dateNotiMonthlyButton])
    }
    
    func configureDateNotiUI() {
        // 시각 알림 세팅
        let repeatNotiType = writeTodo.repeatNotiType
        selectRepeat(type: repeatNotiType)
        
        
        if let date = writeTodo.date {
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale(identifier: "ko_KR")
            timeFormatter.timeStyle = .short
            timeFormatter.dateFormat =  "a hh:mm"
            timeTextField.text = timeFormatter.string(from: date)
            timePicker?.selectedDate = date
        } else {
            timeTextField.text = ""
            timePicker?.selectedDate = nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat =  "yy년 M월 d일 (EEEE)"
        
        if writeTodo.isDateNoti {
            dateNotiSwitch.isOn = true

            switch repeatNotiType {
            case .none:
                dateTabButton.tappedButton(sender: dateNotiNoneButton)
                if let date = writeTodo.date {
                    dateTextField.text = dateFormatter.string(from: date)
                    datePicker?.selectedDate = date
                } else {
                    dateTextField.text = ""
                    timePicker?.selectedDate = nil
                }
            case .daily:
                dateTabButton.tappedButton(sender: dateNotiDailyButton)
            case .weekly:
                dateTabButton.tappedButton(sender: dateNotiWeeklyButton)
                
                let row = writeTodo.weekType.rawValue - 1
                weekTextField.text = weekPicker?.array[row].title
                weekPicker?.selectedWeek = writeTodo.weekType
            case .monthly:
                dateTabButton.tappedButton(sender: dateNotiMonthlyButton)
                
                let row = writeTodo.day - 1
                dayTextField.text = dayPicker?.array[row]
                dayPicker?.selectedDay = writeTodo.day
            }
        } else {
            dateNotiSwitch.isOn = false
            
            dateTabButton.tappedButton(sender: dateNotiNoneButton)
            dateTextField.text = ""
        }
        
        self.view.layoutIfNeeded()
        
        dateSelectView.isHidden = !writeTodo.isDateNoti
        
        if writeTodo.isDateNoti {
            dateNotiViewHeight.constant = 210
        } else {
            dateNotiViewHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func configureLocationNotiUI() {
        if writeTodo.locationName.isEmpty || writeTodo.locationNotiType == .none {
            locationNameLabel.text = "위치 선택"
            locationNameLabel.textColor = .lightGray
        } else {
            locationNameLabel.text = "\(writeTodo.locationName) \(writeTodo.locationNotiType.title)"
            locationNameLabel.textColor = Asset.Color.default.color
        }
        
        if writeTodo.isLocationNoti {
            locationNotiSwitch.isOn = true
        } else {
            locationNotiSwitch.isOn = false
        }
        self.view.layoutIfNeeded()
        
        locationSearchView.isHidden = !writeTodo.isLocationNoti
        
        if writeTodo.isLocationNoti {
            locationSelectViewHeight.constant = 170
        } else {
            locationSelectViewHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func configureUIWithData() {
        // location Select 세팅
        let tapSearchLocation = UITapGestureRecognizer(target: self, action: #selector(tappedLocationSearch))
        locationSearchView.addGestureRecognizer(tapSearchLocation)
        
        // 수정/삭제 세팅
        let isNew = todo == nil
        titleLabel.text = isNew ? "할일 추가" : "할일 수정"
        completeButtonLabel.text = isNew ? "추가" : "수정"
        
        // Todo 타이틀 세팅
        DispatchQueue.main.async {
            self.titleTextField.text = self.writeTodo.title
        }
        
        // 그룹 세팅
        if let groupIndex = groups.firstIndex(where: { $0.groupId == writeTodo.groupId }) {
            groupPickerView.selectRow(groupIndex, inComponent: 0, animated: false)
        }
        
        configureDateNotiUI()
        configureLocationNotiUI()
    }
    
    func configureHeroID() {
        completeButtonView.hero.id = AppHeroId.button.getId(id: group?.groupId ?? 0)
    }
    
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
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 키보드 팝업 처리
    @objc
    func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            scrollViewBottomMargin.constant = keyboardHeight
            view.layoutIfNeeded()
        }
    }
    
    // 키보드 숨김 처리
    @objc
    func keyboardWillHide(_ sender: Notification) {
        scrollViewBottomMargin.constant = 50
        view.layoutIfNeeded()
    }

}
extension WriteTodoViewController {
    func selectRepeat(type: RepeatNotificationType) {
        writeTodo.repeatNotiType = type
        dateTextField.isHidden = type != .none
        dailyTextField.isHidden = type != .daily
        weekTextField.isHidden = type != .weekly
        dayTextField.isHidden = type != .monthly
    }
    
    func checkValidData() -> Bool {
        if let title = titleTextField.text, title.isNotEmpty {
            writeTodo.title = title
        } else {
            dismissKeyboard()
            let alert = UIAlertController(title: "할일 이름을 입력하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(defaultAction)
            self.present(alert, animated: false, completion: nil)
            return false
        }
        
        if writeTodo.isDateNoti {
            switch writeTodo.repeatNotiType {
            case .none:
                if dateTextField.text?.isEmpty ?? true {
                    dismissKeyboard()
                    let alert = UIAlertController(title: "알림 날짜를 선택하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: false, completion: nil)
                    return false
                }
            case .daily:
                break
            case .weekly:
                if weekTextField.text?.isEmpty ?? true {
                    dismissKeyboard()
                    let alert = UIAlertController(title: "알림 요일을 선택하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: false, completion: nil)
                    return false
                }
            case .monthly:
                if dayTextField.text?.isEmpty ?? true {
                    dismissKeyboard()
                    let alert = UIAlertController(title: "알림 월을 선택하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: false, completion: nil)
                    return false
                }
            }
            
            if let date = timeTextField.text, date.isNotEmpty {
                saveDate()
            } else {
                dismissKeyboard()
                let alert = UIAlertController(title: "알림 시간을 선택하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(defaultAction)
                self.present(alert, animated: false, completion: nil)
                return false
            }
        }
        
        if writeTodo.isLocationNoti {
            if locationNameLabel.text == "위치 선택" {
                dismissKeyboard()
                let alert = UIAlertController(title: "알림 위치를 선택하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(defaultAction)
                self.present(alert, animated: false, completion: nil)
                return false
            } else {
                writeTodo.locationName = locationNameLabel.text ?? ""
            }
        }
        
        return true
    }
    
    func saveDate() {
        guard let date = timePicker?.selectedDate else {
            writeTodo.date = nil
            return
        }
        let type = writeTodo.repeatNotiType
        var dateComponents = DateComponents()
        let time = date
        
        switch type {
        case .none:
            let dc = Calendar.current.dateComponents([.year,.month,.day], from: date)
            dateComponents.year = dc.year
            dateComponents.month = dc.month
            dateComponents.day = dc.day
        case .daily: break
        case .weekly:
            writeTodo.weekType = weekPicker?.selectedWeek ?? .none
        case .monthly:
            writeTodo.day = dayPicker?.selectedDay ?? 0
        }
        
        let tc = Calendar.current.dateComponents([.hour,.minute], from: time)
        
        dateComponents.hour = tc.hour
        dateComponents.minute = tc.minute
        
        writeTodo.date = Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    @objc
    func tappedLocationSearch() {
        guard let viewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "SearchLocationViewController") as? SearchLocationViewController else { return }
        
        viewController.delegate = self
        navigationController?.hero.isEnabled = false
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - UITextField
extension WriteTodoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension WriteTodoViewController: SelectLocationMapViewDelegate {
    func searchLocationMapView(didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, locationType: LocationNotificationType, name: String) {
        navigationController?.popToViewController(self, animated: true)
        
        writeTodo.longitude = coordinate.longitude
        writeTodo.latitude = coordinate.latitude
        writeTodo.radius = radius
        writeTodo.locationNotiType = locationType
        writeTodo.locationName = name
        
        configureLocationNotiUI()
    }
}
