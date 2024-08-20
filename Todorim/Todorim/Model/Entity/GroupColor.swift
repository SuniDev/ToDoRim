//
//  GroupColor.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

struct GroupColor {
    static var count: Int {
        return 10
    }
    
    static func getColors(index: Int) -> [UIColor] {
        return [getStart(index: index), getEnd(index: index)]
    }
    
    enum StartColor: Int {
        case defaultColor = 0, start1, start2, start3, start4, start5, start6, start7, start8, start9
        
        func color() -> UIColor {
            switch self {
            case .defaultColor: return Asset.Color.default.color
            case .start1: return Asset.Color.start1.color
            case .start2: return Asset.Color.start2.color
            case .start3: return Asset.Color.start3.color
            case .start4: return Asset.Color.start4.color
            case .start5: return Asset.Color.start5.color
            case .start6: return Asset.Color.start6.color
            case .start7: return Asset.Color.start7.color
            case .start8: return Asset.Color.start8.color
            case .start9: return Asset.Color.start9.color
            }
        }
    }
    
    static func getStart(index: Int) -> UIColor {
        return StartColor(rawValue: index)?.color() ?? Asset.Color.default.color
    }
    
    enum EndColor: Int {
        case defaultColor = 0, end1, end2, end3, end4, end5, end6, end7, end8, end9
        
        func color() -> UIColor {
            switch self {
            case .defaultColor: return Asset.Color.default.color
            case .end1: return Asset.Color.end1.color
            case .end2: return Asset.Color.end2.color
            case .end3: return Asset.Color.end3.color
            case .end4: return Asset.Color.end4.color
            case .end5: return Asset.Color.end5.color
            case .end6: return Asset.Color.end6.color
            case .end7: return Asset.Color.end7.color
            case .end8: return Asset.Color.end8.color
            case .end9: return Asset.Color.end9.color
            }
        }
    }

    static func getEnd(index: Int) -> UIColor {
        return EndColor(rawValue: index)?.color() ?? Asset.Color.default.color
    }

}
