//
//  GroupDetailService.swift
//  Todorim
//
//  Created by suni on 8/20/24.
//

import Foundation

class GroupDetailService {
    
    let groupStorage: GroupStorage
    let todoStorage: TodoStorage
    
    private let notificationManager: NotificationManager

    init(groupStorage: GroupStorage, todoStorage: TodoStorage, notificationManager: NotificationManager = .shared) {
        self.groupStorage = groupStorage
        self.todoStorage = todoStorage
        self.notificationManager = notificationManager
    }
    
    func fetchTodos(for group: Group) -> [Todo] {
        return todoStorage.getTodos(groupId: group.groupId)
    }
    
    func completeTodo(todo: Todo, isComplete: Bool, completion: @escaping (Bool) -> Void) {
        todoStorage.updateComplete(with: todo, isComplete: isComplete) { isSuccess in
            if isSuccess {
                if isComplete {
                    self.notificationManager.remove(id: todo.todoId)
                } else {
                    self.notificationManager.update(with: todo)
                }
            }
            completion(isSuccess)
        }
    }
    
    func deleteTodo(todo: Todo, completion: @escaping (Bool) -> Void) {
        let id: Int = todo.todoId
        todoStorage.deleteTodo(with: todo) { isSuccess in
            if isSuccess {
                self.notificationManager.remove(id: id)
            }
            completion(isSuccess)
        }
    }
}
