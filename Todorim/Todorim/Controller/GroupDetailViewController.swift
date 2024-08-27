//
//  GroupDetailViewController.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit
import Hero

class GroupDetailViewController: BaseViewController {
    
    // MARK: - Dependencies
    private var groupDetailService: GroupDetailService?
    
    // MARK: - Data
    weak var writeGroupDelegate: WriteGroupViewControllerDelegate?
    var group: Group?
    var todos: [Todo] = []
    
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - 의존성 주입
    func inject(service: GroupDetailService) {
        self.groupDetailService = service
    }
    
    // MARK: - Action
    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        pop()
    }
    
    @IBAction private func tappedEditGroupButton(_ sender: UIButton) {
        moveToEditGroup()
    }
    
    @IBAction private func tappedAddTodoButton(_ sender: UIButton) {
        moveToWriteTodo()
    }
    
    // MARK: - Data 설정
    override func configureHeroID() {
        guard let group else { return }
        let id = group.groupId
        view.hero.id = AppHeroId.viewGroup.getId(id: id)
        titleLabel.hero.id = AppHeroId.title.getId(id: id)
        progress.hero.id = AppHeroId.progress.getId(id: id)
        percentLabel.hero.id = AppHeroId.percent.getId(id: id)
        addButtonView.hero.id = AppHeroId.button.getId(id: id)
    }
    
    override func fetchData() {
        guard let group else { return }
        todos = groupDetailService?.fetchTodos(for: group) ?? []
    }
    
    // MARK: - UI 설정
    override func configureUI() {
        configureTableView()
        configureProgress()
        configureAddButtonView()
        
        updateGroupUI()
        updateTodosUI()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    private func configureProgress() {
        performUIUpdatesOnMain {
            self.progress.transform = self.progress.transform.scaledBy(x: 1, y: 2)
            self.progress.layer.cornerRadius = self.progress.frame.height / 2
            self.progress.layer.masksToBounds = true
        }
    }
    
    private func configureAddButtonView() {
        performUIUpdatesOnMain {
            self.addButtonView.layer.cornerRadius = self.addButtonView.bounds.height / 2
            self.addButtonView.layer.masksToBounds = true
        }
    }
    
    private func updateGroupUI() {
        guard let group else { return }
        
        performUIUpdatesOnMain {
            self.titleLabel.text = group.title
            
            let colors = [group.startColor, group.endColor]
            
            let progressLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5.0), colors: colors)
            self.progress.progressImage = progressLayer.createGradientImage()
            
            let buttonLayer = Utils.getVerticalLayer(frame: CGRect(x: 0, y: 0, width: 70, height: 70), colors: colors)
            self.addButtonView.layer.sublayers?.first?.removeFromSuperlayer()
            self.addButtonView.layer.insertSublayer(buttonLayer, at: 0)
        }
    }
    
    private func updateTodosUI() {
        let completeTodos = todos.filter { $0.isComplete }
        let percent = todos.isEmpty ? 0.0 : Float(completeTodos.count) / Float(todos.count)
        
        performUIUpdatesOnMain {
            self.percentLabel.text = "\(Int(percent * 100)) %"
            self.progress.setProgress(percent, animated: true)
            
            self.tableView.reloadData()
        }
    }
}

// MARK: - Navigation
extension GroupDetailViewController {
    private func pop() {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        performUIUpdatesOnMain {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func moveToWriteTodo() {
        guard let groupStorage = groupDetailService?.groupStorage, let todoStoreage = groupDetailService?.todoStorage else { return }
        let service = WriteTodoService(groupStoreage: groupStorage, todoStorage: todoStoreage)
        
        guard let viewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "WriteTodoViewController") as? WriteTodoViewController else { return }
        
        viewController.inject(service: service)
        viewController.delegate = self
        viewController.group = group
        
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .cover(direction: .up)
        
        performUIUpdatesOnMain {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func moveToEditGroup() {
        guard let groupStorage = groupDetailService?.groupStorage else { return }
        let service = WriteGroupService(groupStorage: groupStorage)
        
        performUIUpdatesOnMain {
            guard let viewController = UIStoryboard(name: "Group", bundle: nil).instantiateViewController(withIdentifier: "WriteGroupViewController") as? WriteGroupViewController else { return }
            
            viewController.inject(service: service)
            viewController.delegate = self
            viewController.group = self.group
            
            let groupId = self.group?.groupId ?? 0
            viewController.view.hero.id = AppHeroId.viewGroup.getId(id: groupId)
            
            self.navigationController?.hero.isEnabled = true
            self.navigationController?.hero.navigationAnimationType = .none
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func moveToEditTodo(todo: Todo) {
        guard let groupStorage = groupDetailService?.groupStorage, let todoStoreage = groupDetailService?.todoStorage else { return }
        let service = WriteTodoService(groupStoreage: groupStorage, todoStorage: todoStoreage)
        
        performUIUpdatesOnMain {
            guard let viewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "WriteTodoViewController") as? WriteTodoViewController else { return }
            
            viewController.inject(service: service)
            viewController.delegate = self
            viewController.group = self.group
            viewController.todo = todo
            
            self.navigationController?.hero.isEnabled = true
            self.navigationController?.hero.navigationAnimationType = .cover(direction: .up)
            self.navigationController?.pushViewController(viewController, animated: true)
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
        guard indexPath.row < todos.count else { return }
        
        let todo = todos[indexPath.row]
        let isComplete = !todo.isComplete
        
        groupDetailService?.completeTodo(todo: todo, isComplete: isComplete) { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                self.fetchData()
                self.updateTodosUI()
            } else {
                Alert.showError(self, title: "할 일 완료")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteTodo = deleteTodoAction(at: indexPath)
        let editTodo = editTodoAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteTodo, editTodo])
    }
    
    private func editTodoAction(at indexPath: IndexPath) -> UIContextualAction {
        let todo = todos[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completion in
            self?.moveToEditTodo(todo: todo)
            completion(true)
        }
        action.image = Asset.Assets.editWhite.image
        action.backgroundColor = .lightGray
        
        return action
    }
    
    private func deleteTodoAction(at indexPath: IndexPath) -> UIContextualAction {
        let todo = todos[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            guard let self else {
                completion(false)
                return
            }
            self.deleteTodo(todo: todo, completion: completion)
        }
        action.image = Asset.Assets.deleteWhite.image
        action.backgroundColor = Asset.Color.red.color
        
        return action
    }
    
    private func deleteTodo(todo: Todo, completion: @escaping (Bool) -> Void) {
        groupDetailService?.deleteTodo(todo: todo) { [weak self] isSuccess in
            guard let self else {
                completion(false)
                return
            }
            if isSuccess {
                self.fetchData()
                self.updateTodosUI()
                completion(true)
            } else {
                Alert.showError(self, title: "할 일 삭제")
                completion(false)
            }
        }
    }
}

// MARK: - WriteGroupViewControllerDelegate
extension GroupDetailViewController: WriteGroupViewControllerDelegate {
    func completeWriteGroup(group: Group) { /* Handle group write completion */ }
    
    func completeEditGroup(group: Group) {
        self.group = group
        titleLabel.text = group.title
        updateGroupUI()
        writeGroupDelegate?.completeEditGroup(group: group)
    }
    
    func deleteGroup(groupId: Int) {
        writeGroupDelegate?.deleteGroup(groupId: groupId)
    }
}

extension GroupDetailViewController: WriteTodoViewControllerDelegate {
    func completeWriteTodo(todo: Todo) {
        self.fetchData()
        self.updateTodosUI()
    }
}
