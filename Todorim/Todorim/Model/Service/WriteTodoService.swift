//
//  WriteTodoService.swift
//  Todorim
//
//  Created by suni on 8/20/24.
//

import Foundation
import UserNotifications
import CoreLocation

class WriteTodoService {
    
    let groupStoreage: GroupStorage
    let todoStorage: TodoStorage
    private let notificationManager: NotificationManager
    
    init(groupStoreage: GroupStorage, todoStorage: TodoStorage, notificationManager: NotificationManager = .shared) {
        self.groupStoreage = groupStoreage
        self.todoStorage = todoStorage
        self.notificationManager = notificationManager
    }
    
    // Todo 데이터 초기 설정
    func initializeTodoData(todo: Todo?, group: Group?, groups: [Group]) -> Todo {
        let writeTodo = Todo()
        
        if let todo {
            writeTodo.groupId = todo.groupId
            writeTodo.todoId = todo.todoId
            writeTodo.order = todo.order
            writeTodo.title = todo.title
            writeTodo.isDateNoti = todo.isDateNoti
            writeTodo.date = todo.date
            writeTodo.weekType = todo.weekType
            writeTodo.day = todo.day
            writeTodo.repeatNotiType = todo.repeatNotiType
            writeTodo.isLocationNoti = todo.isLocationNoti
            writeTodo.locationName = todo.locationName
            writeTodo.locationNotiType = todo.locationNotiType
            writeTodo.longitude = todo.longitude
            writeTodo.latitude = todo.latitude
            writeTodo.radius = todo.radius
        } else if let group {
            writeTodo.groupId = group.groupId
            writeTodo.todoId = todoStorage.getNextId()
            writeTodo.order = todoStorage.getNextOrder()
        }
        
        return writeTodo
    }
    
    func getGroups() -> [Group] {
        return groupStoreage.getGroups()
    }
    
    // 저장된 Todo를 새롭게 업데이트
    func updateTodo(with todo: Todo, newTodo: Todo, completion: @escaping (Bool, Todo) -> Void) {
        todoStorage.update(with: todo, writeTodo: newTodo) { isSuccess, updatedTodo in
            if isSuccess {
                self.notificationManager.update(with: updatedTodo)
            }
            completion(isSuccess, updatedTodo)
        }
    }
    
    // 새로운 Todo를 저장
    func addTodo(_ todo: Todo) {
        todoStorage.add(todo)
        notificationManager.update(with: todo)
    }
    
    // 알림 권한 요청 및 처리
    func requestNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { didAllow, _ in
            completion(didAllow)
        }
    }
    
    // 날짜 알림 초기화
    func resetDateNotificationSettings(for todo: Todo) {
        todo.isDateNoti = false
        todo.date = nil
        todo.weekType = .none
        todo.day = 0
        todo.repeatNotiType = .none
    }
    
    // 위치 알림 초기화
    func resetLocationNotificationSettings(for todo: Todo) {
        todo.isLocationNoti = false
        todo.longitude = 0
        todo.latitude = 0
        todo.radius = 100.0
        todo.locationName = ""
        todo.locationNotiType = .none
    }
}
