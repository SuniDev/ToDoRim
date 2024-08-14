//
//  GroupPicker.swift
//  Todorim
//
//  Created by suni on 8/14/24.
//

import UIKit

class GroupPicker: UIPickerView {
    var textField: UITextField?
    var groups: [Group] = []
    var selectedGroup: Group?
    
    convenience init(textField: UITextField, groups: [Group], selectedGroup: Group?) {
        self.init(frame: CGRect.zero)
        self.textField = textField
        self.groups = groups
        self.selectedGroup = selectedGroup
        
        textField.text = selectedGroup?.title ?? "그룹을 선택하세요."
    }
    
    func makeDone() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
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
    func donePressed() {
        textField?.resignFirstResponder()
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension GroupPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.text = groups[row].title
        selectedGroup = groups[row]
    }
}
