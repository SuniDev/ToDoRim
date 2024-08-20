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
        case 1: week = "일요일"
        case 2: week = "월요일"
        case 3: week = "화요일"
        case 4: week = "수요일"
        case 5: week = "목요일"
        case 6: week = "금요일"
        case 7: week = "토요일"
        default: week = ""
        }
        return week
    }
}
