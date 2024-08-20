//
//  NotificationManager.swift
//  Todorim
//
//  Created by suni on 8/19/24.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationManager {
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()
    
    private func addDate(with todo: Todo) {
        guard let date = todo.date else { return }
        
        let content = UNMutableNotificationContent()
        content.title = todo.title
        content.sound = .default
        
        var triggerDate = DateComponents()
        var isRepeat = false
        switch todo.repeatNotiType {
        case .none:
            triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            isRepeat = false
        case .daily:
            triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
            isRepeat = true
        case .weekly:
            let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: date)
            triggerDate = DateComponents(hour: dateComponent.hour, minute: dateComponent.minute, weekday: todo.weekType.weekday)
            isRepeat = true
        case .monthly:
            let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: date)
            triggerDate = DateComponents(day: todo.day, hour: dateComponent.hour, minute: dateComponent.minute)
            isRepeat = true
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: isRepeat)
        let identifier = "dateNotification\(todo.todoId)"
        
        self.center.removePendingNotificationRequests(withIdentifiers: [identifier])
        self.center.removeDeliveredNotifications(withIdentifiers: [identifier])
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        
        print(request)
        self.center.add(request, withCompletionHandler: { error in
            if let error {
                print("Notification Add ERROR : \(error)")
            }
        })
    }
    
    private func addLocation(with todo: Todo) {
        
        let content = UNMutableNotificationContent()
        content.title = todo.title
        content.sound = .default
        
        let coordinate = CLLocationCoordinate2D(latitude: todo.latitude, longitude: todo.longitude)
        let identifier = "locationNotification\(todo.todoId)"
        let region = CLCircularRegion(center: coordinate, radius: todo.radius, identifier: identifier)
        
        switch todo.locationNotiType {
        case .entry:
            region.notifyOnEntry = true
            region.notifyOnExit = false
        case .exit:
            region.notifyOnExit = true
            region.notifyOnEntry = false
        case .none:
            break
        }
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        self.center.removePendingNotificationRequests(withIdentifiers: [identifier])
        self.center.removeDeliveredNotifications(withIdentifiers: [identifier])
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        
        print(request)
        self.center.add(request, withCompletionHandler: { error in
            if let error {
                print("Notification Add ERROR : \(error)")
            }
        })
    }
    
    func update(with todo: Todo) {
        if todo.isDateNoti {
            addDate(with: todo)
        } else {
            removeDate(id: todo.todoId)
        }
        
        if todo.isLocationNoti {
            addLocation(with: todo)
        } else {
            removeLocation(id: todo.todoId)
        }
    }
    
    func remove(id: Int) {
        removeDate(id: id)
        removeLocation(id: id)
    }
    
    private func removeDate(id: Int) {
        let identifier = "dateNotification\(id)"
        
        self.center.removePendingNotificationRequests(withIdentifiers: [identifier])
        
    }
    
    private func removeLocation(id: Int) {
        let identifier = "locationNotification\(id)"
        
        self.center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
