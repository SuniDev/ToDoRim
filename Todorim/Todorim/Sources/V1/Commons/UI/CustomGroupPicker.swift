//
//  CustomPickerView.swift
//  HSProject
//
//  Created by hsPark on 2019. 5. 24..
//  Copyright © 2019년 hsPark. All rights reserved.
//

import UIKit

class CustomGroupPicker: UIPickerView {

    var textField: UITextField?
    var array: Array<String> = []
    var arrNo: Array<Int> = []
    var selectedGroup = 0
    
    // init
    convenience init(textField: UITextField, array: Array<String>, arrNo: Array<Int>, initIndex: Int) {
        self.init(frame: CGRect.zero)
        self.textField = textField
        self.array = array
        self.arrNo = arrNo
        
        textField.text = self.array[initIndex]
        selectedGroup = self.arrNo[initIndex]
    }

}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension CustomGroupPicker: UIPickerViewDataSource, UIPickerViewDelegate {
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
        selectedGroup = arrNo[row]
    }
    
    
}

// MARK: - extension
extension CustomGroupPicker {
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
@objc extension CustomGroupPicker {
    func donePressed(){
        textField!.resignFirstResponder()
    }

}
