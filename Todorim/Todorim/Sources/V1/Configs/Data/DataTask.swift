//
//  DataTask.swift
//  HSTODO
//
//  Created by 박현선 on 05/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
import RealmSwift
//import CloudKit

class DataTask: Object {
    @objc dynamic var taskNo: Int = 0     // 할일 번호
    @objc dynamic var groupNo: Int = 0      // 그룹 번호
    @objc dynamic var title: String = ""      // 할일 이름
    @objc dynamic var isCheck: Bool = false   // 완료 여부
    @objc dynamic var isDateNoti: Bool = false        // 날짜 알림 여부
    @objc dynamic var date: Date = Date()     // 날짜
    @objc dynamic var week: Int = 1     // 1: 일요일 ~ 7: 토요일
    @objc dynamic var day: Int = 1  // 1~31일
    
    // 반복 타입 - .none / .daily(매일) / .weekly(매주) / .monthly(매월)
    @objc private dynamic var pRepeatType: String = RepeatConfig.none.rawValue
    var repeatType: RepeatConfig {
        get { return RepeatConfig(rawValue: pRepeatType)! }
        set { pRepeatType = newValue.rawValue }
    }
    
    @objc dynamic var isLocNoti: Bool = false             // 위치 알림 여부
    @objc dynamic var locTitle: String = ""
    
    // 위치 알림 타입 - .entry / .exit
    @objc private dynamic var plocType: String = LocationConfig.entry.rawValue
    var locType: LocationConfig {
        get { return LocationConfig(rawValue: plocType)! }
        set { plocType = newValue.rawValue }
    }
    @objc dynamic var longitude = 0.0
    @objc dynamic var latitude = 0.0
    
    @objc dynamic var radius = 100.0
    
    //        @objc dynamic var isDeleted: Bool = false
    override static func primaryKey() -> String? {
        return "taskNo"
    }
}
//
//extension DataTask: CKRecordConvertible {
//    
//}
//
//extension DataTask: CKRecordRecoverable {
//    
//}
