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
    
    private func addDate(with todo: Todo, group: Group) {
        guard let date = todo.date else { return }
        
        let content = UNMutableNotificationContent()
        content.title = todo.title
        content.body = group.title
        content.sound = .default
        
        var triggerDate = DateComponents()
        var isRepeat = false
        switch todo.repeatNotiType {
        case .none:
            triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
            isRepeat = false
        case .daily:
            triggerDate = Calendar.current.dateComponents([.hour,.minute], from: date)
            isRepeat = true
        case .weekly:
            let dc = Calendar.current.dateComponents([.hour,.minute], from: date)
            triggerDate = DateComponents(hour: dc.hour, minute: dc.minute, weekday: todo.weekType.weekday)
            isRepeat = true
        case .monthly:
            let dc = Calendar.current.dateComponents([.hour,.minute], from: date)
            triggerDate = DateComponents(day: todo.day, hour: dc.hour, minute: dc.minute)
            isRepeat = true
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: isRepeat)
        let identifier = "dateNotification\(todo.groupId)_\(todo.todoId)"
        
        self.center.removePendingNotificationRequests(withIdentifiers: [identifier])
        self.center.removeDeliveredNotifications(withIdentifiers: [identifier])
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        
        print(request)
        self.center.add(request, withCompletionHandler: { (error) in
            if let error {
                print("Notification Add ERROR : \(error)")
            }
        })
    }
    
    private func addLocation(with todo: Todo, group: Group) {
        
        let content = UNMutableNotificationContent()
        content.title = todo.title
        content.body = group.title
        content.sound = .default
        
        let coordinate = CLLocationCoordinate2D(latitude: todo.latitude, longitude: todo.longitude)
        let identifier = "locationNotification\(todo.groupId)_\(todo.todoId)"
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
        self.center.add(request, withCompletionHandler: { (error) in
            if let error {
                print("Notification Add ERROR : \(error)")
            }
        })
    }
    
    func update(with todo: Todo, group: Group) {
        if todo.isDateNoti {
            addDate(with: todo, group: group)
        } else {
            removeDate(with: todo, group: group)
        }
        
        if todo.isLocationNoti {
            addLocation(with: todo, group: group)
        } else {
            removeLocation(with: todo, group: group)
        }
    }
    
    private func removeDate(with todo: Todo, group: Group) {
        
    }
    
    private func removeLocation(with todo: Todo, group: Group) {
        
    }
}
