//
//  CustomWeekPicker.swift
//  HSTODO
//
//  Created by 박현선 on 30/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class CustomWeekPicker: UIPickerView {
    var textField: UITextField?
    var array: Array<String> = []
    var dateArray: Array<Date> = []
    var selectedWeek = 1
    
    // init
    convenience init(textField: UITextField) {
        self.init(frame: CGRect.zero)
        self.textField = textField
        
        array = ["일요일","월요일","화요일","수요일","목요일","금요일","토요일"]
        textField.placeholder = "반복할 요일을 선택하세요."

        
        //        textField.text = array[0]
    }
    
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension CustomWeekPicker: UIPickerViewDataSource, UIPickerViewDelegate {
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
        selectedWeek = row + 1
        print("selectedWeek:\(selectedWeek)")
//        selectedDay = days[row]
    }
    
    
}

// MARK: - extension
extension CustomWeekPicker {
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
    
    func selectWeek(row: Int) {
        self.selectRow(row, inComponent: 0, animated: false)
    }
}

// MARK: - @objc extension
@objc extension CustomWeekPicker {
    func donePressed(){
        textField!.resignFirstResponder()
    }
    
}
