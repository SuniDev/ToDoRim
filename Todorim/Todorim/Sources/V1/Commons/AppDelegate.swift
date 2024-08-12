//
//  AppDelegate.swift
//  HSTODO
//
//  Created by 박현선 on 02/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
//import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var navigationVC: UINavigationController?
    var syncEngine: SyncEngine?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initNavigationVC()
        
        // 백그라운드 새로고침
//        syncEngine = SyncEngine(objects: [
//            SyncObject<DataTask>(),
//            SyncObject<DataGroup>()
//            ])
        
        
//        application.registerForRemoteNotifications()
        return true
    }

//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        if let dict = userInfo as? [String: NSObject], let notification = CKNotification(fromRemoteNotificationDictionary: dict), let subscriptionID = notification.subscriptionID, IceCreamSubscription.allIDs.contains(subscriptionID) {
//            NotificationCenter.default.post(name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil, userInfo: userInfo)
//            completionHandler(.newData)
//        }
//
//    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// MARK: - extension
extension AppDelegate {
    func initNavigationVC() {
        self.navigationVC = UINavigationController()
        self.navigationVC?.isNavigationBarHidden = true
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Intro", bundle: nil)
        let introVC = storyBoard.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
        self.navigationVC?.setViewControllers([introVC], animated: false)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = navigationVC
        self.window!.makeKeyAndVisible()
    }
}

