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
    
    static func getStart(index: Int) -> UIColor {
        switch index {
        case 0: return Asset.Color.default.color
        case 1: return Asset.Color.start1.color
        case 2: return Asset.Color.start2.color
        case 3: return Asset.Color.start3.color
        case 4: return Asset.Color.start4.color
        case 5: return Asset.Color.start5.color
        case 6: return Asset.Color.start6.color
        case 7: return Asset.Color.start7.color
        case 8: return Asset.Color.start8.color
        case 9: return Asset.Color.start9.color
        default: return Asset.Color.default.color
        }
    }
    
    static func getEnd(index: Int) -> UIColor {
        switch index {
        case 0: return Asset.Color.default.color
        case 1: return Asset.Color.end1.color
        case 2: return Asset.Color.end2.color
        case 3: return Asset.Color.end3.color
        case 4: return Asset.Color.end4.color
        case 5: return Asset.Color.end5.color
        case 6: return Asset.Color.end6.color
        case 7: return Asset.Color.end7.color
        case 8: return Asset.Color.end8.color
        case 9: return Asset.Color.end9.color
        default: return Asset.Color.default.color
        }
    }
}
