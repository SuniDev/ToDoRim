//
//  GroupDetailViewController.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit

import Hero

class GroupDetailViewController: UIViewController {
    
    // MARK: - Data
    var groupStorage: GroupStorage?
    var todoStorage: TodoStorage?
    
    var group: Group?
    var todos: [Todo] = []
    
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Action
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedEditGroupButton(_ sender: UIButton) {
//        CommonNav.shared.moveModifyGroup(groupIndex, self)
    }
    
    @IBAction func tappedAddTodoButton(_ sender: UIButton) {
//        CommonNav.shared.moveAddTask(groupIndex, self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHeroID()
    }
    
    func configureUI() {
        configureTableView()
        
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        progress.layer.cornerRadius = progress.frame.height / 2
        progress.layer.masksToBounds = true
        
        addButtonView.layer.cornerRadius = addButtonView.bounds.height / 2
        addButtonView.layer.masksToBounds = true
        
        if let group {
            titleLabel.text = group.title
            
            let colors = [group.startColor, group.endColor]
            
            let progressLayer = Utils.getHorizontalLayer(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5.0), colors: colors)
            progress.progressImage = progressLayer.createGradientImage()
            
            let buttonLayer = Utils.getVerticalLayer(frame: CGRect(x: 0, y: 0, width: 70, height: 70), colors: colors)
            addButtonView.layer.addSublayer(buttonLayer)
        }
        
        updateProgress()
        tableView.reloadData()
    }
    
    func configureHeroID() {
        let id = group?.groupId ?? 0
        view.hero.id = AppHeroId.viewGroupDetail.getId(id: id)
        titleLabel.hero.id = AppHeroId.title.getId(id: id)
        progress.hero.id = AppHeroId.progress.getId(id: id)
        percentLabel.hero.id = AppHeroId.percent.getId(id: id)
        addButtonView.hero.id = AppHeroId.button.getId(id: id)
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    func updateProgress() {
        
        var percent: Float = 0.0
        
        let completeTodos = todos.filter { $0.isComplete }
        
        if completeTodos.count > 0 {
            percent = Float(completeTodos.count) / Float(todos.count)
            percentLabel.text = "\(Int(percent * 100)) %"
        } else {
            percent = 0.0
            percentLabel.text = "0 %"
        }
        
        DispatchQueue.main.async {
            self.progress.setProgress(percent, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as? TodoTableViewCell,
              indexPath.row < todos.count else { return UITableViewCell() }
        
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        CommonRealmDB.shared.updateTaskCheck(gIndex: groupIndex, tIndex: index) { (response) in
//            if response {
//                tableView.reloadRows(at: [indexPath], with: .none)
//                self.updateProgress(animated: true)
//            }
//        }
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let tModify = modifyTask(at: indexPath)
//        let tDelete = deleteTask(at: indexPath)
//        return UISwipeActionsConfiguration(actions: [tDelete,tModify])
//    }
}
