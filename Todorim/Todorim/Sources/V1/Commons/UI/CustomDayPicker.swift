//
//  CustomDayPicker.swift
//  HSTODO
//
//  Created by 박현선 on 30/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class CustomDayPicker: UIPickerView {
    
    var textField: UITextField?
    var array: Array<String> = []
    var selectedDay = 0
    
    // init
    convenience init(textField: UITextField) {
        self.init(frame: CGRect.zero)
        self.textField = textField
        
        
        for i in 0..<31 {
            array.append("\(i+1)일")
        }
        
        textField.placeholder = "반복할 일을 선택하세요."
//        textField.text = array[0]
    }
    
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension CustomDayPicker: UIPickerViewDataSource, UIPickerViewDelegate {
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
        textField!.text = array[row]
        selectedDay = row+1
    }
    
    
}

// MARK: - extension
extension CustomDayPicker {
    func makeDone(VC: UIViewController) -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: VC.view.frame.width, height: 40))
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
@objc extension CustomDayPicker {
    func donePressed(){
        textField!.resignFirstResponder()
    }
    
}
