//
//  WriteGroupService.swift
//  Todorim
//
//  Created by suni on 8/20/24.
//

import Foundation

class WriteGroupService {
    
    let groupStorage: GroupStorage
    
    init(groupStorage: GroupStorage) {
        self.groupStorage = groupStorage
    }
    
    func addGroup(_ group: Group, completion: (Bool) -> Void) {
        groupStorage.add(group)
        completion(true)  // 성공했음을 알림
    }
    
    func updateGroup(_ group: Group, with newGroupData: Group, completion: @escaping (Bool, Group) -> Void) {
        groupStorage.update(with: group, writeGroup: newGroupData, completion: { isSuccess, updatedGroup in
            completion(isSuccess, updatedGroup)
        })
    }
    
    func deleteGroup(_ group: Group, completion: @escaping (Bool) -> Void) {
        groupStorage.delete(with: group, completion: { isSuccess in
            completion(isSuccess)
        })
    }
}
