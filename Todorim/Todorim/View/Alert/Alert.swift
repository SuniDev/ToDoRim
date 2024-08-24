//
//  Alert.swift
//  Todorim
//
//  Created by suni on 8/24/24.
//

import UIKit

class Alert {
        
    func showDestructive(_ viewController: UIViewController,
                         title: String? = "",
                         message: String? = "",
                         cancelTitle: String = L10n.Alert.Button.cancel,
                         destructiveTitle: String = L10n.Alert.Button.delete,
                         cancelHandler: (() -> Void)? = nil,
                         destructiveHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { _ in
                alert.dismiss(animated: true)
                cancelHandler?()
            }
            let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { _ in
                destructiveHandler?()
            }
            alert.addAction(cancelAction)
            alert.addAction(destructiveAction)
            
            viewController.present(alert, animated: true)
        }
    }
    
    func showCancelAndDone(_ viewController: UIViewController,
                           title: String? = "",
                           message: String? = "",
                           cancelTitle: String = L10n.Alert.Button.cancel,
                           doneTitle: String = L10n.Alert.Button.done,
                           cancelHandler: (() -> Void)? = nil,
                           doneHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
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
            
            viewController.present(alert, animated: true)
        }
    }
    
    func showDone(_ viewController: UIViewController,
                  title: String? = "",
                  message: String? = "",
                  doneTitle: String? = L10n.Alert.Button.done,
                  doneHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: doneTitle, style: .default) { _ in
                alert.dismiss(animated: true)
                doneHandler?()
            }
            alert.addAction(doneAction)
            
            viewController.present(alert, animated: true)
        }
    }
    
}
