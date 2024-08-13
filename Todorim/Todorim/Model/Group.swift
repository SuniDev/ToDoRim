//
//  Group.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

import RealmSwift

class Group: Object {
    @objc dynamic var groupId: Int = 0          // 그룹 번호
    @objc dynamic var order: Int = 0            // 그룹 순서
    @objc dynamic var title: String = ""  // 그룹 이름
    var countTodo: Int = 0          // 할일 개수
    var countCompleteTodo: Int = 0  // 할일 완료 개수
    
    @objc private dynamic var startColorHax: String = ""
    var startColor: UIColor {
        get {
            return UIColor(hexString: startColorHax)
        }
        set {
            startColorHax = newValue.toHexString()
        }
    }
    
    @objc private dynamic var endColorHax: String = ""
    var endColor: UIColor {
        get {
            return UIColor(hexString: endColorHax)
        }
        set {
            endColorHax = newValue.toHexString()
        }
    }
    
    @objc dynamic var appColorIndex: Int = 0
    
    override static func primaryKey() -> String? {
        return "groupId"
    }
}
