//
//  AppHero.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import Foundation

enum AppHeroId: String {
    case viewGroup = "view_group"
    case button = "button"
    case title = "title"
    case percent = "percent"
    case progress = "progress"
    
    func getId() -> String {
        return self.rawValue
    }
    
    func getId(id: Int) -> String {
        return self.rawValue + "_\(id)"
    }
}
