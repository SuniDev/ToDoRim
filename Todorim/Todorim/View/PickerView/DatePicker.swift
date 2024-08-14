//
//  DatePicker.swift
//  Todorim
//
//  Created by suni on 8/14/24.
//

import UIKit

class DatePicker: UIDatePicker {
    var textField: UITextField?
    var selectedDate: Date = Date()
    
    convenience init(textField: UITextField) {
        self.init(frame: CGRect.zero)
        self.textField = textField
        
        self.datePickerMode = .date
        self.locale = Locale(identifier: "ko_KR")
        self.preferredDatePickerStyle = .wheels
        
        let maxDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())

        self.minimumDate = Date()
        self.maximumDate = maxDate
        //
        
        self.addTarget(self, action: #selector(dateChanged(datePicker: )), for: .valueChanged)
        
        textField.inputView = self
        textField.inputAccessoryView = makeDone()
    }
    
    func makeDone() -> UIToolbar {
        let width = textField?.frame.width ?? UIScreen.main.bounds.width
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
    func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat =  "yy년 M월 d일 (EEEE)"
        textField?.text = dateFormatter.string(from: datePicker.date)
        selectedDate = datePicker.date
    }
    
    @objc
    func donePressed() {
        textField?.resignFirstResponder()
    }
}

