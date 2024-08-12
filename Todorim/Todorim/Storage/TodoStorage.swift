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
            return 0 // 또는 적절한 기본값을 반환
        }
    }
    
    func getNextOrder() -> Int {
        if let maxId = realmManager.fetch(Todo.self)?.max(ofProperty: "order") as Int? {
            return maxId + 1
        } else {
            return 0 // 또는 적절한 기본값을 반환
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
    
    func update(_ todo: Todo, completion: @escaping (Bool) -> ()) {
        if let updateTodo = getTodo(id: todo.todoId) {
            realmManager.update(block: {
                updateTodo.title = todo.title
                updateTodo.isDateNoti = todo.isDateNoti
                updateTodo.date = todo.date
                updateTodo.week = todo.week
                updateTodo.day = todo.day
                updateTodo.repeatNotiType = todo.repeatNotiType
                updateTodo.isLocationNoti = todo.isLocationNoti
                updateTodo.locationName = todo.locationName
                updateTodo.locationNotiType = todo.locationNotiType
                updateTodo.latitude = todo.latitude
                updateTodo.longitude = todo.longitude
                updateTodo.radius = todo.radius
            }, completion: { isSuccess, error in
                completion(isSuccess)
            })
        } else {
            completion(false)
        }
    }
    
    func updateIsComplete(_ isComplete: Bool, id: Int, completion: @escaping (Bool) -> ()) {
        if let updateTodo = getTodo(id: id) {
            realmManager.update(block: {
                updateTodo.isComplete = isComplete
            }, completion: { isSuccess, error in
                completion(isSuccess)
            })
        } else {
            completion(false)
        }
    }
    
    func deleteTodo(id: Int, completion: @escaping (Bool) -> ()) {
        if let todo = getTodo(id: id) {
            realmManager.delete(object: todo) { isSuccess, error in
                completion(isSuccess)
            }
        } else {
            completion(false)
        }
    }
    
    func deleteTodos(groupId: Int, completion: @escaping (Bool) -> ()) {
        if let todos = realmManager.fetch(Todo.self)?.filter("groupId == %@", groupId) {
            realmManager.delete(object: todos) { isSuccess, error in
                completion(isSuccess)
            }
        } else {
            completion(false)
        }
    }
}
