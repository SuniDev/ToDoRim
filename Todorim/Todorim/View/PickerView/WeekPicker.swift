//
//  WeekPicker.swift
//  Todorim
//
//  Created by suni on 8/14/24.
//

import UIKit

class WeekPicker: UIPickerView {
    var textField: UITextField?
    var array: [WeekType] = []
    var dateArray: [Date] = []
    var selectedWeek: WeekType?
    
    convenience init(textField: UITextField) {
        self.init(frame: CGRect.zero)
        self.textField = textField
        self.array = WeekType.allCases.filter { $0 != .none }
        textField.placeholder = "반복할 요일을 선택하세요."
    }
    
    func makeDone() -> UIToolbar {
        let width =  UIScreen.main.bounds.width
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = Asset.Color.blue.color
        toolbar.sizeToFit()

        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(donePressed))
        toolbar.setItems([flexButton,doneButton], animated: false)
        
        return toolbar
    }
    
    @objc
    func donePressed() {
        textField?.resignFirstResponder()
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension WeekPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.text = array[row].title
        selectedWeek = array[row]
    }
}

