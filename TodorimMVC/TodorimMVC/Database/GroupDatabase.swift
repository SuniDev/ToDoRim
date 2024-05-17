//
//  GroupDatabase.swift
//  TodorimMVC
//
//  Created by suni on 5/17/24.
//

import Foundation
import RealmSwift

final class GroupDatabase {
    private let database = DatabaseManager.shared
    
    func getGroupNo() -> Int {
        return (database.read(Group.self).max(ofProperty: "groupNo") as Int? ?? 0) + 1
    }
}
