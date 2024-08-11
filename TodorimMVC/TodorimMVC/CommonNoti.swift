//
//  CommonNoti.swift
//  HSTODO
//
//  Created by 박현선 on 27/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

// 200105 hspark. 데이터 구조 변경 : 노티 키값 규칙 변경
class CommonNoti: NSObject {

    static let shared = CommonNoti()
    let center = UNUserNotificationCenter.current()
    
    
    // 시간 알림
    func addDateNoti(data: DataTaskv2, gIndex: Int) {
        if data.isDateNoti {
            
            let content = UNMutableNotificationContent()
            content.title = "\(data.title)"
            content.sound = .default
            let gTitle = CommonGroup.shared.arrGroup[gIndex].title
            content.body = gTitle
            
            let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
            
            let date = data.date
            
            var triggerDate = DateComponents()
            var isRepeat = false
            
            switch data.repeatType {
            case .none:
                triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
                isRepeat = false
            case .daily:
                triggerDate = Calendar.current.dateComponents([.hour,.minute], from: date)
                isRepeat = true
            case .weekly:
                let dc = Calendar.current.dateComponents([.hour,.minute], from: date)
                triggerDate = DateComponents(hour: dc.hour, minute: dc.minute, weekday: data.week)
                isRepeat = true
            case .monthly:
                let dc = Calendar.current.dateComponents([.hour,.minute], from: date)
                triggerDate = DateComponents(day: data.day, hour: dc.hour, minute: dc.minute)
                isRepeat = true
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                        repeats: isRepeat)
            
            let identifier = "dateNoti\(groupNo)_\(data.taskNo)"
            
            self.center.removePendingNotificationRequests(withIdentifiers: [identifier])
            self.center.removeDeliveredNotifications(withIdentifiers: [identifier])
            
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            
            print(request)
            self.center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print("Notification Add ERROR : \(error)")
                }
            })
        }
        
    }
    
    // 위치 알림
    func addLocNoti(data: DataTaskv2, gIndex: Int) {
        
        if data.isLocNoti {
            
            let content = UNMutableNotificationContent()
            content.title = "\(data.title)"
            let gTitle = CommonGroup.shared.arrGroup[gIndex].title
            content.body = gTitle
            
            let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
            
            let coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            let region = CLCircularRegion(center: coordinate, radius: data.radius, identifier: "loc\(data.taskNo)")
            
            switch data.locType {
            case .entry:
                region.notifyOnEntry = true
                region.notifyOnExit = false
            case .exit:
                region.notifyOnExit = true
                region.notifyOnEntry = false
            }
            
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            
            let identifier = "locNoti\(groupNo)_\(data.taskNo)"
            self.center.removePendingNotificationRequests(withIdentifiers: [identifier])
            self.center.removeDeliveredNotifications(withIdentifiers: [identifier])
            
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            self.center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print(error)
                }
            })
        }    }
    
    func updateNoti(data: DataTaskv2, gIndex: Int) {
        if data.isDateNoti {
            addDateNoti(data: data, gIndex: gIndex)
        } else {
            removeDateNoti(taskNo: data.taskNo, gIndex: gIndex)
        }
        
        if data.isLocNoti {
            addLocNoti(data: data, gIndex: gIndex)
        } else {
            removeLocNoti(taskNo: data.taskNo, gIndex: gIndex)
        }
    }
     
    func removeNoti(taskNo: Int, gIndex: Int) {

        let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
        let dateID = "dateNoti\(taskNo)"
        let locID = "locNoti\(taskNo)"
        let dateID2 = "dateNoti\(groupNo)_\(taskNo)"
        let locID2 = "locNoti\(groupNo)_\(taskNo)"
        center.removePendingNotificationRequests(withIdentifiers: [dateID,locID])
        center.removeDeliveredNotifications(withIdentifiers: [dateID,locID])
        print("Notification remove : \(dateID) \(locID)")
        center.removePendingNotificationRequests(withIdentifiers: [dateID2,locID2])
        center.removeDeliveredNotifications(withIdentifiers: [dateID2,locID2])
        print("Notification remove : \(dateID2) \(locID2)")
       
    }
    
    func removeDateNoti(taskNo: Int, gIndex: Int) {

        let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
        let dateID = "dateNoti\(taskNo)"
        let dateID2 = "dateNoti\(groupNo)_\(taskNo)"
        center.removePendingNotificationRequests(withIdentifiers: [dateID])
        center.removeDeliveredNotifications(withIdentifiers: [dateID])
        center.removePendingNotificationRequests(withIdentifiers: [dateID2])
        center.removeDeliveredNotifications(withIdentifiers: [dateID2])
        
    }
    
    func removeLocNoti(taskNo: Int, gIndex: Int) {

        let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
        let locID = "locNoti\(taskNo)"
        let locID2 = "locNoti\(groupNo)_\(taskNo)"
        center.removePendingNotificationRequests(withIdentifiers: [locID])
        center.removeDeliveredNotifications(withIdentifiers: [locID])
        center.removePendingNotificationRequests(withIdentifiers: [locID2])
        center.removeDeliveredNotifications(withIdentifiers: [locID2])
        
    }
    func removeNotis(taskNos: [Int], gIndex: Int) {

        let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
        for n in taskNos {
            let dateID = "dateNoti\(n)"
            let locID = "locNoti\(n)"
            let dateID2 = "dateNoti\(groupNo)_\(n)"
            let locID2 = "locNoti\(groupNo)_\(n)"
            center.removePendingNotificationRequests(withIdentifiers: [dateID,locID])
            center.removeDeliveredNotifications(withIdentifiers: [dateID,locID])
            center.removePendingNotificationRequests(withIdentifiers: [dateID2,locID2])
            center.removeDeliveredNotifications(withIdentifiers: [dateID2,locID2])
        }
    }
}
