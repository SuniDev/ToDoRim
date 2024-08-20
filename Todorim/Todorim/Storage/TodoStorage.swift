//
//  TodoStorage.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import Foundation

class TodoStorage {
    
    private let realmManager: RealmManager
    
    init(realmManager: RealmManager = RealmManager.shared) {
        self.realmManager = realmManager
    }
    
    func getNextId() -> Int {
        if let maxId = realmManager.fetch(Todo.self)?.max(ofProperty: "todoId") as Int? {
            return maxId + 1
        } else {
            return 1 // 또는 적절한 기본값을 반환
        }
    }
    
    func getNextOrder() -> Int {
        if let maxId = realmManager.fetch(Todo.self)?.max(ofProperty: "order") as Int? {
            return maxId + 1
        } else {
            return 1 // 또는 적절한 기본값을 반환
        }
    }
    
    func getTodos() -> [Todo] {
        if let todoList = realmManager.fetch(Todo.self)?.sorted(byKeyPath: "order") {
            var todos: [Todo] = []
            for todo in todoList {
                todos.append(todo)
            }
            return todos
        } else {
            return []
        }
    }
    
    func getTodos(groupId: Int) -> [Todo] {
        if let todoList = realmManager.fetch(Todo.self)?.filter("groupId == %@", groupId).sorted(byKeyPath: "order") {
            var todos: [Todo] = []
            for todo in todoList {
                todos.append(todo)
            }
            return todos
        } else {
            return []
        }
    }
    
    func getTodo(id: Int) -> Todo? {
        return realmManager.fetch(Todo.self)?.filter("todoId == %@", id).first
    }
    
    func add(_ todo: Todo) {
        realmManager.add(todo)
    }
    
    func update(with todo: Todo, writeTodo: Todo, completion: @escaping (_ isSuccess: Bool, _ updateTodo: Todo) -> Void) {
        realmManager.update(block: {
            todo.groupId = writeTodo.groupId
            todo.title = writeTodo.title
            todo.isDateNoti = writeTodo.isDateNoti
            todo.date = writeTodo.date
            todo.weekType = writeTodo.weekType
            todo.day = writeTodo.day
            todo.repeatNotiType = writeTodo.repeatNotiType
            todo.isLocationNoti = writeTodo.isLocationNoti
            todo.locationName = writeTodo.locationName
            todo.locationNotiType = writeTodo.locationNotiType
            todo.latitude = writeTodo.latitude
            todo.longitude = writeTodo.longitude
            todo.radius = writeTodo.radius
        }, completion: { isSuccess, _ in
            completion(isSuccess, todo)
        })
    }
    
    func updateComplete(with todo: Todo, isComplete: Bool, completion: @escaping (Bool) -> Void) {
        if let updateTodo = getTodo(id: todo.todoId) {
            realmManager.update(block: {
                updateTodo.isComplete = isComplete
            }, completion: { isSuccess, _ in
                completion(isSuccess)
            })
        } else {
            completion(false)
        }
    }
    
    func deleteTodo(with todo: Todo, completion: @escaping (Bool) -> Void) {
        realmManager.delete(object: todo) { isSuccess, _ in
            completion(isSuccess)
        }
    }
    
    func deleteTodos(groupId: Int, completion: @escaping (Bool) -> Void) {
        if let todos = realmManager.fetch(Todo.self)?.filter("groupId == %@", groupId) {
            realmManager.delete(object: todos) { isSuccess, _ in
                completion(isSuccess)
            }
        } else {
            completion(false)
        }
    }
}
