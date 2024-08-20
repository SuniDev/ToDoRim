//
//  HomeService.swift
//  Todorim
//
//  Created by suni on 8/20/24.
//

import Foundation

class HomeService {
    
    let groupStorage: GroupStorage
    let todoStorage: TodoStorage
    
    private let notificationManager: NotificationManager

    init(groupStorage: GroupStorage, todoStorage: TodoStorage, notificationManager: NotificationManager = .shared) {
        self.groupStorage = groupStorage
        self.todoStorage = todoStorage
        self.notificationManager = notificationManager
    }
    
    func fetchGroups() -> [Group] {
        return groupStorage.getGroups()
    }
    
    func fetchTodos() -> [Todo] {
        return todoStorage.getTodos()
    }
    
    func completeTodo(todo: Todo, isComplete: Bool, completion: @escaping (Bool) -> Void) {
        todoStorage.updateComplete(with: todo, isComplete: isComplete, completion: { isSuccess in
            if isSuccess {
                self.updateNotification(todo: todo, isComplete: isComplete)
            }
            completion(isSuccess)
        })
    }
    
    private func updateNotification(todo: Todo, isComplete: Bool) {
        if isComplete {
            notificationManager.remove(id: todo.todoId)
        } else {
            if todo.isDateNoti || todo.isLocationNoti {
                notificationManager.update(with: todo)
            }
        }
    }
    
    func deleteGroup(groupId: Int, completion: @escaping (Bool) -> Void) {
        let todoIds = todoStorage.getTodos().filter { $0.groupId == groupId }.map { $0.todoId }
        
        todoStorage.deleteTodos(groupId: groupId, completion: { isSuccess in
            if isSuccess {
                todoIds.forEach { self.notificationManager.remove(id: $0) }
            }
            completion(isSuccess)
        })
    }
}
