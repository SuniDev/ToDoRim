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
            return 1 // 또는 적절한 기본값을 반환
        }
    }
    
    func getNextOrder() -> Int {
        if let maxId = realmManager.fetch(Group.self)?.max(ofProperty: "order") as Int? {
            return maxId + 1
        } else {
            return 1 // 또는 적절한 기본값을 반환
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
    
    func update(with group: Group, writeGroup: Group, completion: @escaping (_ isSuccess: Bool, _ updateGroup: Group) -> Void) {
        realmManager.update(block: {
            group.title = writeGroup.title
            group.appColorIndex = writeGroup.appColorIndex
            group.startColor = writeGroup.startColor
            group.endColor = writeGroup.endColor
        }, completion: { isSuccess, _ in
            completion(isSuccess, group)
        })
    }
    
    func delete(with group: Group, completion: @escaping (Bool) -> Void) {
        realmManager.delete(object: group) { isSuccess, _ in
            completion(isSuccess)
        }
    }
}
