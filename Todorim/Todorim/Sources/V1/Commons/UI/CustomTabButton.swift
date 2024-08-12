//
//  CustomSelectButton.swift
//  BPProject
//
//  Created by hysun on 28/11/2018.
//  Copyright © 2018 adcapsule. All rights reserved.
//

import UIKit

class CustomTabButton {
    
    // tabButton Array
    var repeatTabButtons: [UIButton] = []
    var locationTabButtons: [UIButton] =  []
    
    // Selected Button
    var selectedRepeat: Int = 0
    var repeatType: RepeatConfig = .none
    var selectedLocation: Int = 0
    
    var repeatColor = UIColor(rgb: 0x39393E)
    var locationColor = UIColor(rgb: 0x39393E)
    
    
    // Button Setting - Repeat
    func initRepeatButton(btn: UIButton, tag: Int, color: UIColor){
        btn.tag = tag
        btn.addTarget(self, action: #selector(repeatBtnSelected(sender:)), for: .touchUpInside)
        self.repeatColor = color
        repeatTabButtons.append(btn)
    }
    
    @objc func repeatBtnSelected(sender:UIButton){
        let tag = sender.tag
        
        unselectButton(sender: repeatTabButtons[selectedRepeat])
        selectButton(sender: repeatTabButtons[tag], color: repeatColor)
        selectedRepeat = tag
        switch selectedRepeat {
        case 0:
            repeatType = .none
        case 1:
            repeatType = .daily
        case 2:
            repeatType = .weekly
        case 3:
            repeatType = .monthly
        default:
            repeatType = .none
        }
        
    }
    
    
    // Button Setting - Location
    func initLocationButton(btn: UIButton, tag: Int, color: UIColor){
        btn.tag = tag
        btn.addTarget(self, action: #selector(locationBtnSelected(sender:)), for: .touchUpInside)
        self.locationColor = color
        locationTabButtons.append(btn)
    }
    
    @objc func locationBtnSelected( sender:UIButton ){
        let tag = sender.tag
        
        unselectButton(sender: locationTabButtons[selectedLocation])
        selectButton(sender: locationTabButtons[tag], color: locationColor)
        selectedLocation = tag
    }

    
    //Button Tab
    func selectButton(sender:UIButton, color: UIColor){
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = color
    }
    func unselectButton(sender:UIButton){
        sender.setTitleColor(.lightGray, for: .normal)
        sender.backgroundColor = .white
    }
    
}
