//
//  GroupStorage.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import Foundation
import UIKit

class GroupStorage {
    
    private let realmManager: RealmManager
    
    init(realmManager: RealmManager = RealmManager.shared) {
        self.realmManager = realmManager
    }
    
    func getNextId() -> Int {
        if let maxId = realmManager.fetch(Group.self)?.max(ofProperty: "groupId") as Int? {
            return maxId + 1
        } else {
            return 0 // 또는 적절한 기본값을 반환
        }
    }
    
    func getNextOrder() -> Int {
        if let maxId = realmManager.fetch(Group.self)?.max(ofProperty: "order") as Int? {
            return maxId + 1
        } else {
            return 0 // 또는 적절한 기본값을 반환
        }
    }
    
    func getGroup(id: Int) -> Group? {
        return realmManager.fetch(Group.self)?.filter("groupId == %@", id).first
    }
    
    func getGroups() -> [Group] {
        if let groupList = realmManager.fetch(Group.self)?.sorted(byKeyPath: "order") {
            var groups: [Group] = []
            for group in groupList {
                groups.append(group)
            }
            return groups
        } else {
            return []
        }
    }
    
    func add(_ group: Group) {
        realmManager.add(group)
    }
    
    func update(with group: Group, title: String, startColor: UIColor, endColor: UIColor, appColorIndex: Int, completion: @escaping (Bool) -> ()) {
        realmManager.update(block: {
            group.title = title
            group.startColor = startColor
            group.endColor = endColor
            group.appColorIndex = appColorIndex
        }, completion: { isSuccess, error in
            completion(isSuccess)
        })
    }
    
    func delete(id: Int, completion: @escaping (Bool) -> ()) {
        if let group = getGroup(id: id) {
            realmManager.delete(object: group) { isSuccess, error in
                completion(isSuccess)
            }
        } else {
            completion(false)
        }
    }
}
