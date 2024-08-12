//
//  CustomDatePicker.swift
//  HSProject
//
//  Created by hsPark on 2019. 5. 28..
//  Copyright © 2019년 hsPark. All rights reserved.
//

import UIKit

class CustomTimePicker: UIDatePicker {
    // var
    var textField: UITextField?
    var selectedDate = Date()
    
    // init
    convenience init(textField: UITextField) {
        self.init(frame: CGRect.zero)
        self.textField = textField
        
        self.datePickerMode = .time
        self.minuteInterval = 5
        self.locale = Locale(identifier: "ko_KR")
        
        
//        let maxDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
//
//        self.minimumDate = Date()
//        self.maximumDate = maxDate
//
        
        self.addTarget(self, action: #selector(self.dateChanged(datePicker: )), for: .valueChanged)
        
        textField.inputView = self
        textField.inputAccessoryView = makeDone()
        
    }
    
    
}
// MARK: extension
extension CustomTimePicker {
    func makeDone() -> UIToolbar {
        let tbWidth = textField?.frame.width
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: tbWidth!, height: 40))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 84/255, green: 156/255, blue: 245/255, alpha: 1)
        toolbar.sizeToFit()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePressed))
        toolbar.setItems([flexButton,doneButton], animated: false)
        
        return toolbar
    }
}

// MARK: - @objc extension
@objc extension CustomTimePicker {
    func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat =  "a hh:mm"
        textField?.text = dateFormatter.string(from: datePicker.date)
        selectedDate = datePicker.date
    }
    
    func donePressed(){
        textField?.resignFirstResponder()
    }
}
