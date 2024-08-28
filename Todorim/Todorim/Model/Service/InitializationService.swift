//
//  InitializationService.swift
//  Todorim
//
//  Created by suni on 8/20/24.
//

import Foundation

class InitializationService {
    
    let groupStorage: GroupStorage
    let todoStorage: TodoStorage
    
    init(groupStorage: GroupStorage, todoStorage: TodoStorage) {
        self.groupStorage = groupStorage
        self.todoStorage = todoStorage
    }
    
    func initializeData() {
        // MARK: Old Version: isInitYn 삭제 예정
        let isInitYn = UserDefaultStorage.getObject(forKey: .isInitYn) as? String ?? "N"
        if isInitYn == "N" {
            let isInit = UserDefaultStorage.getObject(forKey: .isInit) as? Bool ?? true            
            if isInit {
                // 초기 그룹과 할일 데이터를 추가
                groupStorage.add(getInitGroup())
                todoStorage.add(getInitTodo())
                UserDefaultStorage.set(false, forKey: .isInit)
            }
        }
    }
    
    private func getInitGroup() -> Group {
        let group = Group()
        group.title = L10n.Group.Init.title
        group.appColorIndex = 1
        return group
    }
    
    private func getInitTodo() -> Todo {
        let todo = Todo()
        todo.title = L10n.Todo.Init.title
        return todo
    }
}
