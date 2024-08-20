//
//  IntroViewController.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

class IntroViewController: UIViewController {
    
    var groupStorage: GroupStorage?
    var todoStorage: TodoStorage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupStorage = GroupStorage()
        todoStorage = TodoStorage()
        
        initData()
        moveHome()
    }
    
    func initData() {
        let isInit = AppUserDefaults.getObject(forKey: .isInit) as? Bool ?? true
        
        if isInit {
            groupStorage?.add(getInitGroup())
            todoStorage?.add(getInitTodo())
            AppUserDefaults.set(false, forKey: .isInit)
        }
    }
    
    func moveHome() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        viewController.groupStorage = groupStorage
        viewController.todoStorage = todoStorage
        
        DispatchQueue.main.async {
            self.navigationController?.setViewControllers([viewController], animated: true)
        }
    }
    
    func getInitGroup() -> Group {
        let group = Group()
        group.title = "그룹을 커스텀해보세요!"
        group.appColorIndex = 1
        return group
    }
    
    func getInitTodo() -> Todo {
        let todo = Todo()
        todo.title = "할일을 추가해보세요"
        return todo
    }
}
