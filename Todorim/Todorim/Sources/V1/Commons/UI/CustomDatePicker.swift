//
//  CustomDatePicker.swift
//  HSTODO
//
//  Created by 박현선 on 30/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class CustomDatePicker: UIDatePicker {
    // var
    var textField: UITextField?
    var selectedDate = Date()
    
    // init
    convenience init(textField: UITextField) {
        self.init(frame: CGRect.zero)
        self.textField = textField
        
        self.datePickerMode = .date
        self.locale = Locale(identifier: "ko_KR")
        
        let maxDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())

        self.minimumDate = Date()
        self.maximumDate = maxDate
        //
        
        self.addTarget(self, action: #selector(self.dateChanged(datePicker: )), for: .valueChanged)
        
        textField.inputView = self
        textField.inputAccessoryView = makeDone()
        
    }
    
    
}
// MARK: extension
extension CustomDatePicker {
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
@objc extension CustomDatePicker {
    func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat =  "yy년 M월 d일 (EEEE)"
        textField?.text = dateFormatter.string(from: datePicker.date)
        selectedDate = datePicker.date
    }
    
    func donePressed(){
        textField?.resignFirstResponder()
    }
}
