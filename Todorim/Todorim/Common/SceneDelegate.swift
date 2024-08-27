//
//  SceneDelegate.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // GroupStorage와 TodoStorage 생성
        let groupStorage = GroupStorage()
        let todoStorage = TodoStorage()
        
        // InitializationService 생성
        let initService = InitializationService(groupStorage: groupStorage, todoStorage: todoStorage)
        
        // IntroViewController를 스토리보드에서 인스턴스화
        let storyboard = UIStoryboard(name: "Intro", bundle: nil)
        guard let introViewController = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController else {
            return
        }

        // IntroViewController에 InitializationService 주입
        introViewController.inject(initService: initService)
        
        let navigation = UINavigationController(rootViewController: introViewController)
        navigation.isNavigationBarHidden = true
        
        // UIWindow 초기화 및 설정
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigation
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if let root = self.window?.rootViewController, Utils.remoteConfig != nil {
            Utils.checkForUpdate { appUpdate, _ in
                if appUpdate == .forceUpdate {
                    Alert.showDone(
                        root,
                        title: L10n.Alert.ForceUpdate.title,
                        message: L10n.Alert.ForceUpdate.message,
                        doneTitle: L10n.Alert.Button.update,
                        doneHandler: {
                            AnalyticsManager.shared.logEvent(.TAP_UPDATE_GO)
                            Utils.moveAppStore()
                        }, withDismiss: false)
                }
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
