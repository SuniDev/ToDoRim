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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        configureUIComponents()
    }
    
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
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
        self.navigationController?.popViewController(animated: true)
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
    
}

// MARK: - UI 설정 및 데이터 초기화
extension WriteTodoViewController {
    
    private func configureData() {
        guard let writeTodoService = writeTodoService else { return }
        writeTodo = writeTodoService.initializeTodoData(todo: todo, group: group, groups: groups)
        groups = writeTodoService.getGroups()
    }
    
    private func configureUIComponents() {
        configureHeroID()
        configurePickers()
        configureTextFields()
        configureUIWithColor()
        configureUIWithData()
        createKeyboardEvent()
    }
    
    private func configureHeroID() {
        completeButtonView.hero.id = AppHeroId.button.getId(id: group?.groupId ?? 0)
    }
    
    private func configureUIWithColor() {
        completeButtonView.layer.cornerRadius = 15
        completeButtonView.layer.masksToBounds = true
        
        let colors = GroupColor.getColors(index: group?.appColorIndex ?? 0)
        let gradientLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 70), colors: colors)
        completeButtonView.layer.addSublayer(gradientLayer)
        
        dateNotiSwitch.onTintColor = colors[1]
        locationNotiSwitch.onTintColor = colors[1]
        
        dateTabButton.initButton(type: .dateRepeat, color: colors[1], buttons: [dateNotiNoneButton, dateNotiDailyButton, dateNotiWeeklyButton, dateNotiMonthlyButton])
    }
    
    private func configureUIWithData() {
        titleLabel.text = todo == nil ? L10n.Todo.Write.title : L10n.Todo.Edit.title
        completeButtonLabel.text = todo == nil ? L10n.Button.add : L10n.Button.edit
        
        DispatchQueue.main.async {
            self.titleTextField.text = self.writeTodo.title
        }

        if let groupIndex = groups.firstIndex(where: { $0.groupId == writeTodo.groupId }) {
            groupPickerView.selectRow(groupIndex, inComponent: 0, animated: false)
        }

        configureDateNotiUI()
        configureLocationNotiUI()
    }
    
    private func configureDateNotiUI() {
        // 시각 알림 세팅
        selectRepeat(type: writeTodo.repeatNotiType)
        configureTimeTextField()
        configureRepeatTypeUI()
        updateDateSelectView()
    }
    
    private func configureTimeTextField() {
        DispatchQueue.main.async {
            if let date = self.writeTodo.date {
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
        }
    }
    
    private func configureRepeatTypeUI() {
        switch writeTodo.repeatNotiType {
        case .none:
            dateTabButton.tappedButton(sender: dateNotiNoneButton)
        case .daily:
            dateTabButton.tappedButton(sender: dateNotiDailyButton)
        case .weekly:
            dateTabButton.tappedButton(sender: dateNotiWeeklyButton)
            weekTextField.text = weekPicker?.array[writeTodo.weekType.weekday - 1].title
        case .monthly:
            dateTabButton.tappedButton(sender: dateNotiMonthlyButton)
            dayTextField.text = dayPicker?.array[writeTodo.day - 1]
        }
    }
    
    private func updateDateSelectView() {
        self.view.layoutIfNeeded()
        dateSelectView.isHidden = !writeTodo.isDateNoti
        dateNotiViewHeight.constant = writeTodo.isDateNoti ? 210 : 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func configureLocationNotiUI() {
        locationNameLabel.text = writeTodo.locationName.isEmpty || writeTodo.locationNotiType == .none
            ? L10n.Todo.SelectLocation.title
            : "\(writeTodo.locationName) \(writeTodo.locationNotiType.title)"
        
        locationNameLabel.textColor = writeTodo.locationName.isEmpty ? .lightGray : Asset.Color.default.color
        locationNotiSwitch.isOn = writeTodo.isLocationNoti
        
        locationSearchView.isHidden = !writeTodo.isLocationNoti
        locationSelectViewHeight.constant = writeTodo.isLocationNoti ? 170 : 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
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
    
    private func configureRepeatTypeUI(repeatNotiType: RepeatNotificationType) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yy년 M월 d일 (EEEE)"
        
        switch repeatNotiType {
        case .none:
            dateTabButton.tappedButton(sender: dateNotiNoneButton)
            if let date = writeTodo.date {
                dateTextField.text = dateFormatter.string(from: date)
                datePicker?.selectedDate = date
            } else {
                dateTextField.text = dateFormatter.string(from: Date())
                timePicker?.selectedDate = Date()
            }
        case .daily:
            dateTabButton.tappedButton(sender: dateNotiDailyButton)
        case .weekly:
            dateTabButton.tappedButton(sender: dateNotiWeeklyButton)
            let row = writeTodo.weekType.weekday - 1
            weekTextField.text = weekPicker?.array[row].title
            weekPicker?.selectedWeek = writeTodo.weekType
        case .monthly:
            dateTabButton.tappedButton(sender: dateNotiMonthlyButton)
            let row = writeTodo.day - 1
            dayTextField.text = dayPicker?.array[row]
            dayPicker?.selectedDay = writeTodo.day
        }
    }
    
    private func resetDateFields() {
        dateTabButton.tappedButton(sender: dateNotiNoneButton)
        dateTextField.text = ""
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

// MARK: - Notification 관련 로직 (Extensions 활용)
extension WriteTodoViewController {
    private func handleDateNotificationChange(_ isOn: Bool) {
        if isOn {
            writeTodoService?.requestNotificationAuthorization { [weak self] didAllow in
                guard let self = self else { return }
                if didAllow {
                    self.writeTodo.isDateNoti = true
                } else {
                    self.showAlert(title: L10n.Alert.AuthNoti.title, message: L10n.Alert.AuthNoti.message)
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
                    self.showAlert(title: L10n.Alert.AuthNoti.title, message: L10n.Alert.AuthNoti.message)
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

// MARK: - Helper 메서드
extension WriteTodoViewController {
    
    // MARK: - 완료 처리
    private func handleCompleteAction() {
        if checkValidData() {
            if let todo = self.todo {
                writeTodoService?.updateTodo(with: todo, newTodo: writeTodo) { [weak self] isSuccess, updatedTodo in
                    guard let self = self else { return }
                    if isSuccess {
                        self.delegate?.completeWriteTodo(todo: updatedTodo)
                        self.popViewControllerWithAnimation()
                    }
                }
            } else {
                writeTodoService?.addTodo(writeTodo)
                delegate?.completeWriteTodo(todo: writeTodo)
                popViewControllerWithAnimation()
            }
        }
    }
    
    private func popViewControllerWithAnimation() {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
        navigationController?.popViewController(animated: true)
    }
    
    private func selectRepeat(type: RepeatNotificationType) {
        writeTodo.repeatNotiType = type
        dateTextField.isHidden = type != .none
        dailyTextField.isHidden = type != .daily
        weekTextField.isHidden = type != .weekly
        dayTextField.isHidden = type != .monthly
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
            showAlert(title: L10n.Alert.WriteTodo.EmptyName.title)
            return false
        }
    }
    
    private func checkDateNotification() -> Bool {
        if writeTodo.isDateNoti {
            switch writeTodo.repeatNotiType {
            case .none where dateTextField.text?.isEmpty ?? true:
                showAlert(title: L10n.Alert.WriteTodo.EmptyDate.title)
                return false
            case .weekly where weekTextField.text?.isEmpty ?? true:
                showAlert(title: L10n.Alert.WriteTodo.EmptyWeek.title)
                return false
            case .monthly where dayTextField.text?.isEmpty ?? true:
                showAlert(title: L10n.Alert.WriteTodo.EmptyMonth.title)
                return false
            default:
                break
            }
            if timeTextField.text?.isEmpty ?? true {
                showAlert(title: L10n.Alert.WriteTodo.EmptyTime.title)
                return false
            }
            saveDate()
        }
        return true
    }
    
    private func checkLocationNotification() -> Bool {
        if writeTodo.isLocationNoti && locationNameLabel.text == L10n.Todo.SelectLocation.title {
            showAlert(title: L10n.Alert.WriteTodo.EmptyLocation.title)
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
            let noneDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            dateComponents.year = noneDateComponents.year
            dateComponents.month = noneDateComponents.month
            dateComponents.day = noneDateComponents.day
        case .weekly:
            writeTodo.weekType = weekPicker?.selectedWeek ?? .none
        case .monthly:
            writeTodo.day = dayPicker?.selectedDay ?? 0
        case .daily:
            break
        }
        return Calendar.current.date(from: dateComponents) ?? date
    }
    
    private func showAlert(title: String = "", message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Alert.Button.done, style: .default))
        present(alert, animated: true)
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
