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
    
    // Todo 데이터 초기 설정
    func initializeGroupData(group: Group?) -> Group {
        let writeGroup = Group()
        
        if let group {
            writeGroup.groupId = group.groupId
            writeGroup.order = group.order
            writeGroup.title = group.title
            writeGroup.appColorIndex = group.appColorIndex
        } else {
            writeGroup.groupId = groupStorage.getNextId()
            writeGroup.order = groupStorage.getNextOrder()
            writeGroup.appColorIndex = 0
        }
        
        return writeGroup
    }
    
    func addGroup(_ group: Group, completion: (Bool) -> Void) {
        groupStorage.add(group)
        completion(true)  // 성공했음을 알림
    }
    
    func updateGroup(_ group: Group, with newGroupData: Group, completion: @escaping (Bool) -> Void) {
        groupStorage.update(with: group, writeGroup: newGroupData, completion: { isSuccess in
            completion(isSuccess)
        })
    }
    
    func deleteGroup(_ group: Group, completion: @escaping (Bool) -> Void) {
        groupStorage.delete(with: group, completion: { isSuccess in
            completion(isSuccess)
        })
    }
}
