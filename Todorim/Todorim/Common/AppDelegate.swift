//
//  AppDelegate.swift
//  HSTODO
//
//  Created by 박현선 on 02/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // UNUserNotificationCenterDelegate 설정
        UNUserNotificationCenter.current().delegate = self
        
        AnalyticsManager.shared.logEvent(.OPEN_APP)
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 앱이 포그라운드에 있을 때 알림을 처리하는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 여기서 원하는 알림 옵션을 지정합니다.
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        AnalyticsManager.shared.logEvent(.OPEN_APP_PUSH)
        completionHandler()
    }
}
