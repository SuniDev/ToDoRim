//
//  IntroViewController.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

class IntroViewController: UIViewController {
    
    // MARK: - Dependencies
    private var initService: InitializationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 초기 데이터 설정
        initService?.initializeData()
        
        // 홈 화면으로 이동
        moveToHome()
    }
    
    // MARK: - 의존성 주입 메서드
    func inject(initService: InitializationService) {
        self.initService = initService
    }
    
    func moveToHome() {
        guard let groupStorage = initService?.groupStorage, let todoStorage = initService?.todoStorage else { return }
        let service = HomeService(groupStorage: groupStorage, todoStorage: todoStorage)
        
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        viewController.inject(service: service)
        
        DispatchQueue.main.async {
            self.navigationController?.setViewControllers([viewController], animated: true)
        }
    }
}
