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
    
    var title: String {
        return self.rawValue
    }
}

// MARK: - 반복 알림 타입
enum RepeatNotificationType: String {
    case none = "반복안함"
    case daily = "매일"
    case weekly = "매주"
    case monthly = "매월"
    
    var title: String {
        return self.rawValue
    }
}

// MARK: - 요일 타입
enum WeekType: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    var title: String {
        switch self {
        case .sunday: return "일요일"
        case .monday: return "월요일"
        case .tuesday: return "화요일"
        case .wednesday: return "수요일"
        case .thursday: return "목요일"
        case .friday: return "금요일"
        case .saturday: return "토요일"
        }
    }
}
