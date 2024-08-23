//
//  BaseViewController.swift
//  Todorim
//
//  Created by suni on 8/21/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        loadingView.isLoading = false
        
        configureHeroID()
        fetchData()
        configureUI()
    }
    
    // MARK: - 의존성 주입
    func inject() { }
    
    // MARK: - Data 설정
    func fetchData() { }
    
    // MARK: - UI 설정
    func configureUI() { }
    
    // MARK: - Hero 설정
    func configureHeroID() { }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async { 
            updates()
        }
    }
    
    func updateLoadingView(isLoading: Bool) {
        performUIUpdatesOnMain {
            self.loadingView.isLoading = isLoading
        }
    }
}
