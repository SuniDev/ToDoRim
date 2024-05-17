//
//  Task.swift
//  TodorimMVC
//
//  Created by suni on 5/17/24.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var taskNo: Int = 0           // 할일 번호
    @objc dynamic var title: String = ""        // 할일 이름
    @objc dynamic var isCheck: Bool = false     // 완료 여부
    
    @objc dynamic var isDateNoti: Bool = false  // 날짜 알림 여부
    @objc dynamic var date: Date?               // 날짜
    @objc dynamic var week: Int = 0             // 1: 일요일 ~ 7: 토요일
    @objc dynamic var day: Int = 0              // 1~31일
    // 반복 알림 타입
    @objc private dynamic var dateNotiRepeat: String = Configs.notiDateRepeat.none.rawValue
    var notiDateRepeat: Configs.notiDateRepeat {
        get { return Configs.notiDateRepeat(rawValue: dateNotiRepeat) ?? .none }
        set { dateNotiRepeat = newValue.rawValue }
    }
    
    @objc dynamic var isLocNoti: Bool = false   // 위치 알림 여부
    @objc dynamic var locTitle: String?     // 위치 이름
    // 위치 알림 타입
    @objc private dynamic var locNoti: String = Configs.notiLocation.entry.rawValue
    var notiLocation: Configs.notiLocation {
        get { return Configs.notiLocation(rawValue: locNoti) ?? .entry }
        set { locNoti = newValue.rawValue }
    }
    @objc dynamic var longitude = 0.0
    @objc dynamic var latitude = 0.0
    @objc dynamic var radius = 100.0
    
    override static func primaryKey() -> String? {
        return "taskNo"
    }
}
