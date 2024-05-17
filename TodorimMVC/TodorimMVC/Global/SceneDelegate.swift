//
//  SceneDelegate.swift
//  TodorimMVC
//
//  Created by suni on 5/17/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static var shared = SceneDelegate()
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                        
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }
}

