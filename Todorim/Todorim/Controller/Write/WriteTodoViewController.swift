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

class WriteTodoViewController: BaseViewController {
    
    // MARK: - Dependencies
    private var writeTodoService: WriteTodoService?
    
    // MARK: - Data
    var todo: Todo?
    var group: Group?
    var writeTodo: Todo = Todo()
    var groups: [Group] = []
    
    // MARK: - UI Elements
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
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - 의존성 주입 메서드
    func inject(service: WriteTodoService) {
        self.writeTodoService = service
    }
    
    // MARK: - Action
    @IBAction private func changedTitleTextField(_ sender: MadokaTextField) {
        sender.setMaxLength(max: 30)
    }
    
    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        pop()
    }
    
    @IBAction private func changedDateNotiSwitch(_ sender: UISwitch) {
        handleDateNotificationChange(sender.isOn)
    }
    
    @IBAction private func changedLocationNotiSwitch(_ sender: UISwitch) {
        handleLocationNotificationChange(sender.isOn)
    }
    
    @IBAction private func tappedDateNotiNoneButton(_ sender: UIButton) {
        selectRepeat(type: .none)
    }
    
    @IBAction private func tappedDateNotiDailyButton(_ sender: UIButton) {
        selectRepeat(type: .daily)
    }
    
    @IBAction private func tappepDateNotiWeeklyButton(_ sender: UIButton) {
        selectRepeat(type: .weekly)
    }
    
    @IBAction private func tappepDateNotiMonthlyButton(_ sender: UIButton) {
        selectRepeat(type: .monthly)
    }
    
    @IBAction private func tappedCompleteButton(_ sender: UIButton) {
        handleCompleteAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createKeyboardEvent()
    }
    // MARK: - Data 설정
    override func configureHeroID() {
        completeButtonView.hero.id = AppHeroId.button.getId(id: group?.groupId ?? 0)
    }
    
    override func fetchData() {
        guard let writeTodoService = writeTodoService else { return }
        writeTodo = writeTodoService.initializeTodoData(todo: todo, group: group, groups: groups)
        groups = writeTodoService.getGroups()
    }
    
    // MARK: - UI 설정
    override func configureUI() {
        configurePickers()
        configureTextFields()
        
        configureUIWithColor()
        configureUIWithData()
    }
    
    private func configurePickers() {
        
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
    
    private func configureTextFields() {
        titleTextField.delegate = self
        groupTitleTextField.inputView = groupPickerView
        groupTitleTextField.inputAccessoryView = groupPicker?.makeDone()
        weekTextField.inputView = weekPickerView
        weekTextField.inputAccessoryView = weekPicker?.makeDone()
        dayTextField.inputView = dayPickerView
        dayTextField.inputAccessoryView = dayPicker?.makeDone()
    }
    
    private func configureUIWithData() {
        let tapSearchLocation = UITapGestureRecognizer(target: self, action: #selector(tappedLocationSearch))
        locationSearchView.addGestureRecognizer(tapSearchLocation)
        
        performUIUpdatesOnMain {
            let todo = self.todo
            self.titleLabel.text = todo == nil ? L10n.Todo.Write.title : L10n.Todo.Edit.title
            self.completeButtonLabel.text = todo == nil ? L10n.Button.add : L10n.Button.edit
        
            self.titleTextField.text = self.writeTodo.title

            if let groupIndex = self.groups.firstIndex(where: { $0.groupId == self.writeTodo.groupId }) {
                self.groupPickerView.selectRow(groupIndex, inComponent: 0, animated: false)
            }
        }

        configureNotiUI()
    }
    
    private func configureNotiUI() {
        performUIUpdatesOnMain {
            self.dateNotiSwitch.isOn = self.writeTodo.isDateNoti
            self.locationNotiSwitch.isOn = self.writeTodo.isLocationNoti
        }
        
        configureDateNotiUI()
        configureLocationNotiUI()
    }
    
    private func configureDateNotiUI() {
        selectRepeat(type: writeTodo.repeatNotiType)
        
        performUIUpdatesOnMain {
            // Configure Time
            let writeTodo = self.writeTodo
            if let date = writeTodo.date {
                let timeFormatter = DateFormatter()
                timeFormatter.locale = Locale(identifier: "ko_KR")
                timeFormatter.timeStyle = .short
                timeFormatter.dateFormat = "a hh:mm"
                self.timeTextField.text = timeFormatter.string(from: date)
                self.timePicker?.selectedDate = date
            } else {
                self.timeTextField.text = ""
                self.timePicker?.selectedDate = nil
            }
            
            // Configure RepeatType
            switch writeTodo.repeatNotiType {
            case .none:
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ko_KR")
                dateFormatter.dateFormat = "yy년 M월 d일 (EEEE)"
                self.dateTabButton.tappedButton(sender: self.dateNotiNoneButton)
                if let date = writeTodo.date {
                    self.dateTextField.text = dateFormatter.string(from: date)
                    self.datePicker?.selectedDate = date
                } else {
                    self.dateTextField.text = dateFormatter.string(from: Date())
                    self.datePicker?.selectedDate = Date()
                }
            case .daily:
                self.dateTabButton.tappedButton(sender: self.dateNotiDailyButton)
            case .weekly:
                self.dateTabButton.tappedButton(sender: self.dateNotiWeeklyButton)
                self.weekTextField.text = self.weekPicker?.array[writeTodo.weekType.weekday - 1].title
                self.weekPicker?.selectedWeek = writeTodo.weekType
            case .monthly:
                self.dateTabButton.tappedButton(sender: self.dateNotiMonthlyButton)
                self.dayTextField.text = self.dayPicker?.array[writeTodo.day - 1]
                self.dayPicker?.selectedDay = writeTodo.day
            }
            
            // Configure Date Select View
            self.view.layoutIfNeeded()
            self.dateNotiSwitch.isOn = writeTodo.isDateNoti
            self.dateSelectView.isHidden = !writeTodo.isDateNoti
            self.dateNotiViewHeight.constant = writeTodo.isDateNoti ? 210 : 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func configureLocationNotiUI() {
        performUIUpdatesOnMain {
            let writeTodo = self.writeTodo
            self.locationNameLabel.text = writeTodo.locationName.isEmpty || writeTodo.locationNotiType == .none
            ? L10n.Todo.SelectLocation.title
            : "\(writeTodo.locationName) \(writeTodo.locationNotiType.title)"
            
            self.locationNameLabel.textColor = writeTodo.locationName.isEmpty ? .lightGray : Asset.Color.default.color
            self.locationNotiSwitch.isOn = writeTodo.isLocationNoti
            
            self.locationSearchView.isHidden = !writeTodo.isLocationNoti
            self.locationSelectViewHeight.constant = writeTodo.isLocationNoti ? 170 : 0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func configureUIWithColor() {
        performUIUpdatesOnMain {
            self.completeButtonView.layer.cornerRadius = 15
            self.completeButtonView.layer.masksToBounds = true
            
            let colors = GroupColor.getColors(index: self.group?.appColorIndex ?? 0)
            let gradientLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 70), colors: colors)
            self.completeButtonView.layer.addSublayer(gradientLayer)
            
            self.dateNotiSwitch.onTintColor = colors[1]
            self.locationNotiSwitch.onTintColor = colors[1]
            
            self.dateTabButton.initButton(type: .dateRepeat, color: colors[1], buttons: [self.dateNotiNoneButton, self.dateNotiDailyButton, self.dateNotiWeeklyButton, self.dateNotiMonthlyButton])
        }
        
    }
    
    private func createKeyboardEvent() {
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
    
    @objc
    func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            performUIUpdatesOnMain {
                self.scrollViewBottomMargin.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    func keyboardWillHide(_ sender: Notification) {
        performUIUpdatesOnMain {
            self.scrollViewBottomMargin.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func tappedLocationSearch() {
        guard let viewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "SearchLocationViewController") as? SearchLocationViewController else { return }
        
        viewController.delegate = self
        navigationController?.hero.isEnabled = false
        performUIUpdatesOnMain {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - Notification 관련 로직
extension WriteTodoViewController {
    private func handleDateNotificationChange(_ isOn: Bool) {
        if isOn {
            writeTodoService?.requestNotificationAuthorization { [weak self] didAllow in
                guard let self = self else { return }
                if didAllow {
                    self.writeTodo.isDateNoti = true
                } else {
                    Alert.showCancelAndDone(
                        self,
                        title: L10n.Alert.AuthNoti.title,
                        message: L10n.Alert.AuthNoti.message,
                        cancelTitle: L10n.Alert.Button.moveSetting,
                        cancelHandler: {
                            Utils.moveAppSetting()
                        })
                    self.writeTodoService?.resetDateNotificationSettings(for: self.writeTodo)
                }
                self.configureDateNotiUI()
            }
        } else {
            writeTodoService?.resetDateNotificationSettings(for: writeTodo)
            configureDateNotiUI()
        }
    }
    
    private func handleLocationNotificationChange(_ isOn: Bool) {
        if isOn {
            writeTodoService?.requestNotificationAuthorization { [weak self] didAllow in
                guard let self = self else { return }
                if didAllow {
                    self.writeTodo.isLocationNoti = true
                } else {
                    Alert.showCancelAndDone(
                        self,
                        title: L10n.Alert.AuthNoti.title,
                        message: L10n.Alert.AuthNoti.message,
                        cancelTitle: L10n.Alert.Button.moveSetting,
                        cancelHandler: {
                            Utils.moveAppSetting()
                        })
                    self.writeTodoService?.resetLocationNotificationSettings(for: self.writeTodo)
                }
                self.configureLocationNotiUI()
            }
        } else {
            writeTodoService?.resetLocationNotificationSettings(for: writeTodo)
            configureLocationNotiUI()
        }
    }
}

// MARK: - Navigation
extension WriteTodoViewController {
    private func pop() {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
        
        performUIUpdatesOnMain {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Helper 메서드
extension WriteTodoViewController {
    private func handleCompleteAction() {
        if checkValidData() {
            if let todo = self.todo {
                writeTodoService?.updateTodo(with: todo, newTodo: writeTodo) { [weak self] isSuccess, updatedTodo in
                    guard let self = self else { return }
                    if isSuccess {
                        self.delegate?.completeWriteTodo(todo: updatedTodo)
                        self.pop()
                    } else {
                        Alert.showError(self, title: "할 일 수정")
                    }
                }
            } else {
                writeTodoService?.addTodo(writeTodo)
                delegate?.completeWriteTodo(todo: writeTodo)
                pop()
            }
        }
    }
    
    private func selectRepeat(type: RepeatNotificationType) {
        writeTodo.repeatNotiType = type
        
        performUIUpdatesOnMain {
            self.dateTextField.isHidden = type != .none
            self.dailyTextField.isHidden = type != .daily
            self.weekTextField.isHidden = type != .weekly
            self.dayTextField.isHidden = type != .monthly
        }
    }
    
    private func checkValidData() -> Bool {
        guard checkTitle(), checkDateNotification(), checkLocationNotification() else { return false }
        writeTodo.groupId = groupPicker?.selectedGroup?.groupId ?? writeTodo.groupId
        return true
    }

    private func checkTitle() -> Bool {
        if let title = titleTextField.text, title.isNotEmpty {
            writeTodo.title = title
            return true
        } else {
            Alert.showDone(
                self,
                title: L10n.Alert.WriteTodo.EmptyName.title
            )
            return false
        }
    }
    
    private func checkDateNotification() -> Bool {
        if writeTodo.isDateNoti {
            switch writeTodo.repeatNotiType {
            case .none where dateTextField.text?.isEmpty ?? true:
                Alert.showDone(
                    self,
                    title: L10n.Alert.WriteTodo.EmptyDate.title
                )
                return false
            case .weekly where weekTextField.text?.isEmpty ?? true:
                Alert.showDone(
                    self,
                    title: L10n.Alert.WriteTodo.EmptyWeek.title
                )
                return false
            case .monthly where dayTextField.text?.isEmpty ?? true:
                Alert.showDone(
                    self,
                    title: L10n.Alert.WriteTodo.EmptyMonth.title
                )
                return false
            default:
                break
            }
            if timeTextField.text?.isEmpty ?? true {
                Alert.showDone(
                    self,
                    title: L10n.Alert.WriteTodo.EmptyTime.title
                )
                return false
            }
            saveDate()
        }
        return true
    }
    
    private func checkLocationNotification() -> Bool {
        if writeTodo.isLocationNoti && locationNameLabel.text == L10n.Todo.SelectLocation.title {
            Alert.showDone(
                self,
                title: L10n.Alert.WriteTodo.EmptyLocation.title
            )
            return false
        }
        return true
    }
    
    private func saveDate() {
        guard let date = timePicker?.selectedDate else { return }
        writeTodo.date = createDate(from: date)
    }
    
    private func createDate(from date: Date) -> Date {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        switch writeTodo.repeatNotiType {
        case .none:
            if let noneDate = datePicker?.selectedDate {
                let noneDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: noneDate)
                dateComponents.year = noneDateComponents.year
                dateComponents.month = noneDateComponents.month
                dateComponents.day = noneDateComponents.day
            }
        case .weekly:
            writeTodo.weekType = weekPicker?.selectedWeek ?? .none
        case .monthly:
            writeTodo.day = dayPicker?.selectedDay ?? 0
        case .daily:
            break
        }
        return Calendar.current.date(from: dateComponents) ?? date
    }
}

// MARK: - UITextFieldDelegate
extension WriteTodoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

// MARK: - SelectLocationMapViewDelegate
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
