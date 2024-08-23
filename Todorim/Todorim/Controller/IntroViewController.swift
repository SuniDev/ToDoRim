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
            showDoneAlert(
                title: L10n.Alert.Jalibroken.title,
                doneHandler: {
                    exit(0)
                })
        } else {
            Utils.initConfig()
            Utils.checkForUpdate { [weak self] appUpdate, _ in
                guard let self else { return }
                switch appUpdate {
                case .forceUpdate:
                    showDoneAlert(
                        title: L10n.Alert.ForceUpdate.title,
                        message: L10n.Alert.ForceUpdate.message,
                        doneTitle: L10n.Alert.Button.update,
                        doneHandler: {
                            Utils.moveAppStore()
                        })
                case .latestUpdate:
                    showDoneAndCancelAlert(
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
    
    private func showDoneAlert(title: String? = "",
                               message: String? = "",
                               doneTitle: String? = L10n.Alert.Button.done,
                               doneHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: doneTitle, style: .default) { _ in
            doneHandler?()
        }
        alert.addAction(doneAction)
        
        performUIUpdatesOnMain {
            self.present(alert, animated: true)
        }
    }
    
    private func showDoneAndCancelAlert(title: String? = "",
                                        message: String? = "",
                                        cancelTitle: String = L10n.Alert.Button.cancel,
                                        doneTitle: String = L10n.Alert.Button.done,
                                        cancelHandler: (() -> Void)? = nil,
                                        doneHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            alert.dismiss(animated: true)
            cancelHandler?()
        }
        let doneAction = UIAlertAction(title: doneTitle, style: .default) { _ in
            doneHandler?()
        }
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        
        performUIUpdatesOnMain {
            self.present(alert, animated: true)
        }
    }
}
