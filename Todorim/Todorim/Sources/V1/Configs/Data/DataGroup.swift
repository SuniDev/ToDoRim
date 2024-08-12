//
//  DataGroup.swift
//  HSTODO
//
//  Created by 박현선 on 05/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
import RealmSwift
//import CloudKit

// hspark. v1.0.0
//class DataGroup: Object {
//    @objc dynamic var groupNo: Int = 0        // 그룹 번호
//    var checkTask: Int = 0       // 할일 완료 개수
//    var allTask: Int = 0       // 모든 항일 개수
//    @objc dynamic var title: String = "기본그룹"      // 그룹 이름
//    dynamic let listTask = List<DataTask>()
////    var arrTask = Array<DataTask>()  // 항일 리스트
//    @objc dynamic var colorIndex: Int = 0   // 그라데이션 색상 인덱스
//
////    @objc dynamic var isDeleted: Bool = false
//    override static func primaryKey() -> String? {
//        return "groupNo"
//    }
//    //    var isWidget: Bool = true   // 위젯 표시 여부
//    //    var isBadge: Bool = true    // 배지 표시 여부
////    @objc dynamic var startColor = CommonGroup.shared.sColors[0]   // 그라데이션 시작 칼라
////    @objc dynamic var endColor = CommonGroup.shared.eColors[0]     // 그라데이션 끝 칼라
//}

// 200105 hspark. v1.0.1
class DataGroup: Object {
    
    @objc dynamic var groupNo: Int = 0          // 그룹 번호
    @objc dynamic var gOrder: Int = 0            // 그룹 순서
    var checkTask: Int = 0        // 할일 완료 개수
    var allTask: Int = 0          // 모든 항일 개수
    @objc dynamic var title: String = "기본그룹"  // 그룹 이름
    dynamic let listTask = List<DataTaskv2>()                 // 할일 리스트
    @objc dynamic var colorIndex: Int = 0       // 그라데이션 색상 인덱스
    override static func primaryKey() -> String? {
        return "groupNo"
    }
}
