//
//  Group.swift
//  TodorimMVC
//
//  Created by suni on 5/17/24.
//

import Foundation
import RealmSwift

class Group: Object {
    
    @objc dynamic var groupNo: Int = 0  // 그룹 번호
    @objc dynamic var gOrder: Int = 0   // 그룹 순서
    var checkTask: Int = 0              // 할일 완료 개수
    var allTask: Int = 0                // 모든 항일 개수
    @objc dynamic var title: String = ""  // 그룹 이름
    dynamic let listTask = List<Task>()         // 할일 리스트
    @objc dynamic var colorIndex: Int = 0       // 그라데이션 색상 인덱스
    override static func primaryKey() -> String? {
        return "groupNo"
    }
}
