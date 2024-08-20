//
//  DayPicker.swift
//  Todorim
//
//  Created by suni on 8/14/24.
//

import UIKit

class DayPicker: UIPickerView {
    var textField: UITextField?
    var array: [String] = []
    var selectedDay = 0
    
    convenience init(textField: UITextField) {
        self.init(frame: CGRect.zero)
        self.textField = textField
        
        for day in 0..<31 {
            array.append("\(day + 1)일")
        }
        
        textField.placeholder = L10n.Picker.Day.placeholder
    }
    
    func makeDone() -> UIToolbar {
        let width = UIScreen.main.bounds.width
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = Asset.Color.blue.color
        toolbar.sizeToFit()

        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(donePressed))
        toolbar.setItems([flexButton, doneButton], animated: false)
        
        return toolbar
    }
    
    @objc
    func donePressed() {
        textField?.resignFirstResponder()
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension DayPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.text = array[row]
        selectedDay = row + 1
    }
}
