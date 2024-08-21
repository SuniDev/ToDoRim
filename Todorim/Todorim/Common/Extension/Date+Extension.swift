//
//  Date+Extension.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import Foundation

extension Date {
    func week() -> String {
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: self)
        var week = ""
        switch comps.weekday {
        case 1: week = WeekType.sunday.title
        case 2: week = WeekType.monday.title
        case 3: week = WeekType.tuesday.title
        case 4: week = WeekType.wednesday.title
        case 5: week = WeekType.thursday.title
        case 6: week = WeekType.friday.title
        case 7: week = WeekType.saturday.title
        default: week = ""
        }
        return week
    }
}
