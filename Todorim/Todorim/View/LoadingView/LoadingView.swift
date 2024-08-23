//
//  LoadingView.swift
//  MoonDuck
//
//  Created by suni on 6/10/24.
//

import UIKit

class LoadingView: UIView {
    var isLoading = false {
        didSet {
            self.isHidden = !self.isLoading
            if self.isLoading {
                self.activityIndicatorView.startAnimating()
            } else {
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.backgroundView)
        self.addSubview(self.activityIndicatorView)
        
        NSLayoutConstraint.activate([
            self.backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.backgroundView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        NSLayoutConstraint.activate([
            self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
