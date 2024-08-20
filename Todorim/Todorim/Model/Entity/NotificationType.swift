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
    case entry
    case exit
    
    var title: String {
        switch self {
        case .none: return ""
        case .entry: return L10n.Location.entry
        case .exit: return L10n.Location.exit
        }
    }
}

// MARK: - 반복 알림 타입
enum RepeatNotificationType: String {
    case none
    case daily
    case weekly
    case monthly
    
    var title: String {
        switch self {
        case .none: return L10n.Repeat.none
        case .daily: return L10n.Repeat.daily
        case .weekly: return L10n.Repeat.weekly
        case .monthly: return L10n.Repeat.monthly
        }
    }
}

// MARK: - 요일 타입
enum WeekType: Int, CaseIterable {
    case none = 0
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    var title: String {
        switch self {
        case .none: return ""
        case .sunday: return L10n.Week.sunday
        case .monday: return L10n.Week.monday
        case .tuesday: return L10n.Week.tuesday
        case .wednesday: return L10n.Week.wednesday
        case .thursday: return L10n.Week.thursday
        case .friday: return L10n.Week.friday
        case .saturday: return L10n.Week.saturday
        }
    }
    
    var weekday: Int {
        return self.rawValue
    }
}
