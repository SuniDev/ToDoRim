//
//  TimePicker.swift
//  Todorim
//
//  Created by suni on 8/14/24.
//

import UIKit

class TimePicker: UIDatePicker {
    var textField: UITextField?
    var selectedDate: Date = Date()
    
    convenience init(textField: UITextField) {
        self.init(frame: CGRect.zero)
        self.textField = textField
        
        self.datePickerMode = .time
        self.minuteInterval = 5
        self.locale = Locale(identifier: "ko_KR")
        
        self.addTarget(self, action: #selector(dateChanged(datePicker: )), for: .valueChanged)
        
        textField.inputView = self
        textField.inputAccessoryView = makeDone()
        
    }
    
    func makeDone() -> UIToolbar {
        let width = textField?.frame.width ?? UIScreen.main.bounds.width
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
//        toolbar.tintColor = UIColor(red: 84/255, green: 156/255, blue: 245/255, alpha: 1)
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
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat =  "a hh:mm"
        textField?.text = dateFormatter.string(from: datePicker.date)
        selectedDate = datePicker.date
    }
    
    @objc
    func donePressed() {
        textField?.resignFirstResponder()
    }
}
