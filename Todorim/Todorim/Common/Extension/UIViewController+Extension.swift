//
//  UIViewController+Extension.swift
//  Todorim
//
//  Created by suni on 8/23/24.
//

import UIKit

extension UIViewController {
    func showToast(message: String) {
        DispatchQueue.main.async {
            let frameView = UIView()
            frameView.backgroundColor = Asset.Color.default.color.withAlphaComponent(0.9)
            frameView.alpha = 0.8
            frameView.layer.cornerRadius = 6
            frameView.translatesAutoresizingMaskIntoConstraints = false
            
            let toastLabel = UILabel()
            toastLabel.textColor = .white
            toastLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15.0)
            toastLabel.text = message
            toastLabel.numberOfLines = 0
            toastLabel.textAlignment = .center
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(frameView)
            frameView.addSubview(toastLabel)
            NSLayoutConstraint.activate([
                // frameView constraints
                frameView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -7),
                frameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                frameView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                frameView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                
                // toastLabel constraints
                toastLabel.topAnchor.constraint(equalTo: frameView.topAnchor, constant: 8),
                toastLabel.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -8),
                toastLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 8),
                toastLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -8)
            ])
            
            UIView.animate(withDuration: 1.5,
                           delay: 1.5,
                           options: .curveEaseOut,
                           animations: {
                frameView.alpha = 0.0
            }, completion: { _ in
                frameView.removeFromSuperview()
            })
        }
    }
}
