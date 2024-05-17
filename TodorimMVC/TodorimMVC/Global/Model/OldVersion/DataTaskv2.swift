////
////  Task.swift
////  HSTODO
////
////  Created by 박현선 on 2019/11/25.
////  Copyright © 2019 hspark. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//// 191218 hspark. data 구조 변경 후.
//class DataTaskv2: Object {
//    @objc dynamic var taskNo: Int = 0           // 할일 번호
//    @objc dynamic var title: String = ""        // 할일 이름
//    @objc dynamic var isCheck: Bool = false     // 완료 여부
//    @objc dynamic var isDateNoti: Bool = false  // 날짜 알림 여부
//    @objc dynamic var date: Date = Date()       // 날짜
//    @objc dynamic var week: Int = 1             // 1: 일요일 ~ 7: 토요일
//    @objc dynamic var day: Int = 1              // 1~31일
//    @objc dynamic var tOrder: Int = 0        // 순서
//    
//    // 반복 타입 - .none / .daily(매일) / .weekly(매주) / .monthly(매월)
//    @objc private dynamic var pRepeatType: String = RepeatConfig.none.rawValue
//    var repeatType: RepeatConfig {
//        get { return RepeatConfig(rawValue: pRepeatType)! }
//        set { pRepeatType = newValue.rawValue }
//    }
//    
//    @objc dynamic var isLocNoti: Bool = false   // 위치 알림 여부
//    @objc dynamic var locTitle: String = ""     // 위치 이름
//    
//    // 위치 알림 타입 - .entry / .exit
//    @objc private dynamic var plocType: String = LocationConfig.entry.rawValue
//    var locType: LocationConfig {
//        get { return LocationConfig(rawValue: plocType)! }
//        set { plocType = newValue.rawValue }
//    }
//    
//    @objc dynamic var longitude = 0.0
//    @objc dynamic var latitude = 0.0
//    @objc dynamic var radius = 100.0
//    
//    override static func primaryKey() -> String? {
//        return "taskNo"
//    }
//}
