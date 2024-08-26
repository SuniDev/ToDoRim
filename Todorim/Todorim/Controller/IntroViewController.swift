//
//  IntroViewController.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

class IntroViewController: BaseViewController {
    
    // MARK: - Dependencies
    private var initService: InitializationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAppStatus()
    }
    
    // MARK: - 의존성 주입 메서드
    func inject(initService: InitializationService) {
        self.initService = initService
    }
    
    func checkAppStatus() {
        if Utils.isJailbroken() {
            Alert.showDone(
                self,
                title: L10n.Alert.Jailbroken.title,
                doneHandler: {
                    exit(0)
                }, withDismiss: false)
        } else {
            Utils.initConfig()
            Utils.checkForUpdate { [weak self] appUpdate, _ in
                guard let self else { return }
                switch appUpdate {
                case .forceUpdate:
                    Alert.showDone(
                        self,
                        title: L10n.Alert.ForceUpdate.title,
                        message: L10n.Alert.ForceUpdate.message,
                        doneTitle: L10n.Alert.Button.update,
                        doneHandler: {
                            Utils.moveAppStore()
                        }, withDismiss: false)
                case .latestUpdate:
                    Alert.showCancelAndDone(
                        self,
                        title: L10n.Alert.LatestUpdate.title,
                        message: L10n.Alert.LatestUpdate.message,
                        cancelTitle: L10n.Alert.Button.update,
                        doneTitle: L10n.Alert.Button.later,
                        cancelHandler: { [weak self] in
                            self?.moveToHome()
                            Utils.moveAppStore()
                        }, doneHandler: { [weak self] in
                            self?.moveToHome()
                        })
                case .none:
                    moveToHome()
                }
            }
        }
    }
    
    // MARK: - Data 설정
    override func fetchData() {
        initService?.initializeData()
    }
    
    // MARK: - Navigation
    func moveToHome() {
        guard let groupStorage = initService?.groupStorage, let todoStorage = initService?.todoStorage else { return }
        let service = HomeService(groupStorage: groupStorage, todoStorage: todoStorage)
        
        performUIUpdatesOnMain {
            guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
            
            viewController.inject(service: service)
        
            self.navigationController?.setViewControllers([viewController], animated: false)
        }
    }
}
