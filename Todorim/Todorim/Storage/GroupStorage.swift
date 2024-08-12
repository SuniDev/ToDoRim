//
//  GroupStorage.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import Foundation

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
    
    func update(_ group: Group, completion: @escaping (Bool) -> ()) {
        if let updateGroup = getGroup(id: group.groupId) {
            realmManager.update(block: {
                updateGroup.title = group.title
                updateGroup.startColor = group.startColor
                updateGroup.endColor = group.endColor
            }, completion: { isSuccess, error in
                completion(isSuccess)
            })
        } else {
            completion(false)
        }
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
