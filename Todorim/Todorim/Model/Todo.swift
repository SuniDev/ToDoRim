//
//  Todo.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import Foundation

import RealmSwift

class Todo: Object {
    @objc dynamic var groupId: Int = 0          // 그룹 ID
    @objc dynamic var todoId: Int = 0           // 할일 ID
    @objc dynamic var title: String = ""        // 할일 이름
    @objc dynamic var isComplete: Bool = false  // 완료 여부
    @objc dynamic var order: Int = 0            // 순서
    
    // MARK: 날짜 알림
    @objc dynamic var isDateNoti: Bool = false  // 날짜 알림 여부
    @objc dynamic var date: Date = Date()       // 날짜
    @objc dynamic var week: Int = 1             // 1: 일요일 ~ 7: 토요일
    @objc dynamic var day: Int = 1              // 1 ~ 31일
    
    @objc private dynamic var repeatType: String = RepeatNotificationType.none.rawValue  // 반복 알림 타입
    var repeatNotiType: RepeatNotificationType {
        get {
            return RepeatNotificationType(rawValue: repeatType) ?? .none
        }
        set {
            repeatType = newValue.rawValue
        }
    }
    
    // MARK: 위치 알림
    @objc dynamic var isLocationNoti: Bool = false  // 위치 알림 여부
    @objc dynamic var locationName: String = ""     // 위치 이름
    
    // 위치 알림 타입
    @objc private dynamic var locationType: String = LocationConfig.entry.rawValue
    var locationNotiType: LocationNotificationType {
        get {
            return LocationNotificationType(rawValue: locationType) ?? .none
        }
        set {
            locationType = newValue.rawValue
        }
    }
    
    @objc dynamic var longitude = 0.0
    @objc dynamic var latitude = 0.0
    @objc dynamic var radius = 100.0
        
    override static func primaryKey() -> String? {
        return "todoId"
    }
}
