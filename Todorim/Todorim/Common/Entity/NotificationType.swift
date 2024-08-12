//
//  LocationType.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import Foundation

// MARK: - 위치 알림 타입
enum LocationNotificationType: String {
    case none
    case entry = "도착할 때"
    case exit = "출발할 때"
}

// MARK: - 반복 알림 타입
enum RepeatNotificationType: String {
    case none = "반복안함"
    case daily = "매일"
    case weekly = "매주"
    case monthly = "매월"
}
