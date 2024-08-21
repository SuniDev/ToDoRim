//
//  BaseViewController.swift
//  Todorim
//
//  Created by suni on 8/21/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
}
