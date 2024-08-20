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
    weak var writeGroupDelegate: WriteGroupViewControllerDelegate?
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
    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func tappedEditGroupButton(_ sender: UIButton) {
        moveEditGroup()
    }
    
    @IBAction private func tappedAddTodoButton(_ sender: UIButton) {
        guard let viewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "WriteTodoViewController") as? WriteTodoViewController else { return }
        
        viewController.todoStorage = todoStorage
        viewController.group = group
        viewController.groups = groupStorage?.getGroups() ?? []
        viewController.delegate = self
        
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .cover(direction: .up)
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
        
        updateGroupColor()
        updateProgress()
        tableView.reloadData()
    }
    
    func updateGroupColor() {
        if let group {
            titleLabel.text = group.title
            
            let colors = [group.startColor, group.endColor]
            
            let progressLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5.0), colors: colors)
            progress.progressImage = progressLayer.createGradientImage()
            
            let buttonLayer = Utils.getVerticalLayer(frame: CGRect(x: 0, y: 0, width: 70, height: 70), colors: colors)
            if let firstLayer = addButtonView.layer.sublayers?.first as? CAGradientLayer {
                firstLayer.removeFromSuperlayer()  // 기존 레이어 제거
            }
            addButtonView.layer.insertSublayer(buttonLayer, at: 0)
        }
    }
    
    func configureHeroID() {
        let id = group?.groupId ?? 0
        view.hero.id = AppHeroId.viewGroup.getId(id: id)
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
    
    func fetchTodos() {
        guard let group else { return }
        todos = todoStorage?.getTodos(groupId: group.groupId) ?? []
    }
    
    func moveEditGroup() {
        guard let viewController = UIStoryboard(name: "Group", bundle: nil).instantiateViewController(withIdentifier: "WriteGroupViewController") as? WriteGroupViewController else { return }
        viewController.hero.isEnabled = true
        viewController.modalPresentationStyle = .fullScreen
        
        viewController.delegate = self
        viewController.groupStorage = groupStorage
        viewController.group = group
        
        let groupId = group?.groupId ?? 0
        viewController.view.hero.id = AppHeroId.viewGroup.getId(id: groupId)
        viewController.textfield.hero.id = AppHeroId.title.getId(id: groupId)
        
        navigationController?.hero.isEnabled = true
        navigationController?.hero.modalAnimationType = .cover(direction: .up)
        
        DispatchQueue.main.async {
            self.navigationController?.present(viewController, animated: true)
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
        todoStorage?.updateComplete(with: todo, isComplete: isComplete, completion: { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                self.updateNotification(with: todo, isComplete: isComplete)
                self.fetchTodos()
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.updateProgress()
            } else {
                // TODO: - 오류 메시지
            }
        })
    }
    
    func updateNotification(with todo: Todo, isComplete: Bool) {
        if isComplete {
            NotificationManager.shared.remove(id: todo.todoId)
        } else {
            if todo.isDateNoti || todo.isLocationNoti {
                NotificationManager.shared.update(with: todo)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteTodo = deleteTodoAction(at: indexPath)
        let editTodo = editTodoAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteTodo, editTodo])
    }
    
    func editTodoAction(at indexPath: IndexPath) -> UIContextualAction {
        let todo = todos[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            guard let self,
                  let viewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "WriteTodoViewController") as? WriteTodoViewController else {
                completion(false)
                return
            }
            
            viewController.todoStorage = self.todoStorage
            viewController.todo = todo
            viewController.group = self.group
            viewController.groups = self.groupStorage?.getGroups() ?? []
            viewController.delegate = self
            
            navigationController?.hero.isEnabled = true
            navigationController?.hero.navigationAnimationType = .cover(direction: .up)
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            completion(true)
        }
        action.image = Asset.Assets.editWhite.image
        action.backgroundColor = .lightGray
        
        return action
    }
    
    func deleteTodoAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            guard let self,
                  indexPath.row < self.todos.count else {
                completion(false)
                return
            }
            let todo = todos[indexPath.row]
            let todoId: Int = todo.todoId
            self.todoStorage?.deleteTodo(with: todo, completion: { [weak self] isSuccess in
                if isSuccess {
                    NotificationManager.shared.remove(id: todoId)
                    self?.fetchTodos()
                    self?.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                    self?.updateProgress()
                    completion(true)
                } else {
                    // TODO: 오류 메시지
                    completion(false)
                }
            })
        }
        action.image = Asset.Assets.deleteWhite.image
        action.backgroundColor = Asset.Color.red.color
        
        return action
    }
}

// MARK: - WriteGroupViewControllerDelegate
extension GroupDetailViewController: WriteGroupViewControllerDelegate {
    func completeWriteGroup(group: Group) {
        
    }
    
    func completeEditGroup(group: Group) {
        dismiss(animated: true) {
            self.group = group
            
            self.titleLabel.text = group.title
            self.updateGroupColor()
            
            self.writeGroupDelegate?.completeEditGroup(group: group)
        }
    }
    
    func deleteGroup(groupId: Int) {
        self.dismiss(animated: true) {
            self.writeGroupDelegate?.deleteGroup(groupId: groupId)
        }
    }
}

extension GroupDetailViewController: WriteTodoViewControllerDelegate {
    func completeWriteTodo(todo: Todo) {
        self.fetchTodos()
        self.tableView.reloadData()
        self.updateProgress()
    }
}
