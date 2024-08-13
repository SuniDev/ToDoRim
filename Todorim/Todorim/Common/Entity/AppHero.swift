//
//  AppHero.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import Foundation

enum AppHeroId: String {
     case viewAddGroup = "view_add_group"
    
    func getId() -> String {
        return self.rawValue
    }
}
