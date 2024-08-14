//
//  TabButton.swift
//  Todorim
//
//  Created by suni on 8/14/24.
//

import UIKit

class TabButton {
    
    enum TabType {
        case dateRepeat
        case locationType
    }
    
    var tabType: TabType = .dateRepeat
    var buttons: [UIButton] = []
    var selectedButton: Int = 0
    var color: UIColor = Asset.Color.default.color
    
    func initButton(type: TabType, color: UIColor, buttons: [UIButton]) {
        self.tabType = type
        self.color = color
        self.buttons = buttons
    }
    
    func addTargetButton(button: UIButton, tag: Int) {
        button.tag = tag
        button.addTarget(self, action:#selector(tappedButton(sender:)), for: .touchUpInside)
    }
    
    @objc func tappedButton(sender: UIButton) {
        let tag = sender.tag
        unselectButton(sender: buttons[selectedButton])
        selectButton(sender: buttons[tag])
        selectedButton = tag
    }
    
    func selectButton(sender: UIButton) {
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = color
    }
    
    func unselectButton(sender: UIButton) {
        sender.setTitleColor(.lightGray, for: .normal)
        sender.backgroundColor = .white
    }
}
