//
//  GroupDetailViewController.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit
import Hero

class GroupDetailViewController: UIViewController {
    
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
    
    // MARK: - 의존성 주입 메서드
    func inject(service: GroupDetailService) {
        self.groupDetailService = service
    }
    
    // MARK: - Action
    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func tappedEditGroupButton(_ sender: UIButton) {
        moveToEditGroup()
    }
    
    @IBAction private func tappedAddTodoButton(_ sender: UIButton) {
        moveToWriteTodo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHeroID()
        fetchTodosAndUpdateUI()
    }
    
    // MARK: - UI 설정 및 데이터 로드
    func configureUI() {
        configureTableView()
        configureProgress()
        configureAddButtonView()
        updateGroupColor()
    }
    
    private func configureProgress() {
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        progress.layer.cornerRadius = progress.frame.height / 2
        progress.layer.masksToBounds = true
    }
    
    func fetchTodosAndUpdateUI() {
        guard let group else { return }
        todos = groupDetailService?.fetchTodos(for: group) ?? []
        updateProgress()
        tableView.reloadData()
    }
    
    private func configureAddButtonView() {
        addButtonView.layer.cornerRadius = addButtonView.bounds.height / 2
        addButtonView.layer.masksToBounds = true
    }
    
    
    func updateGroupColor() {
        guard let group else { return }
        titleLabel.text = group.title
        let colors = [group.startColor, group.endColor]
        
        let progressLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5.0), colors: colors)
        progress.progressImage = progressLayer.createGradientImage()
        
        let buttonLayer = Utils.getVerticalLayer(frame: CGRect(x: 0, y: 0, width: 70, height: 70), colors: colors)
        addButtonView.layer.sublayers?.first?.removeFromSuperlayer()
        addButtonView.layer.insertSublayer(buttonLayer, at: 0)
    }
    
    func configureHeroID() {
        guard let group else { return }
        let id = group.groupId
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
        let completeTodos = todos.filter { $0.isComplete }
        let percent = todos.isEmpty ? 0.0 : Float(completeTodos.count) / Float(todos.count)
        
        percentLabel.text = "\(Int(percent * 100)) %"
        
        DispatchQueue.main.async {
            self.progress.setProgress(percent, animated: true)
        }
    }
}

// MARK: - Navigation
extension GroupDetailViewController {
    private func moveToWriteTodo() {
        guard let viewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "WriteTodoViewController") as? WriteTodoViewController else { return }
        
        viewController.todoStorage = groupDetailService?.todoStorage
        viewController.group = group
        viewController.groups = groupDetailService?.groupStorage.getGroups() ?? []
        viewController.delegate = self
        
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .cover(direction: .up)
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func moveToEditGroup() {
        guard let groupStorage = groupDetailService?.groupStorage else { return }
        let service = WriteGroupService(groupStorage: groupStorage)
        
        guard let viewController = UIStoryboard(name: "Group", bundle: nil).instantiateViewController(withIdentifier: "WriteGroupViewController") as? WriteGroupViewController else { return }
        
        viewController.inject(service: service)
        viewController.delegate = self
        viewController.group = group
        
        let groupId = group?.groupId ?? 0
        viewController.view.hero.id = AppHeroId.viewGroup.getId(id: groupId)
        
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func moveToEditTodo(todo: Todo) {
        guard let viewController = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "WriteTodoViewController") as? WriteTodoViewController else { return }
        
        viewController.todo = todo
        viewController.group = group
        viewController.groups = groupDetailService?.groupStorage.getGroups() ?? []
        viewController.delegate = self
        
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .cover(direction: .up)
        
        DispatchQueue.main.async {
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
        
        groupDetailService?.updateTodoCompletion(todo: todo, isComplete: isComplete) { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                self.fetchTodosAndUpdateUI()
            } else {
                // TODO: - 오류 메시지 처리
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
            self?.groupDetailService?.deleteTodo(todo: todo) { isSuccess in
                if isSuccess {
                    self?.fetchTodosAndUpdateUI()
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        action.image = Asset.Assets.deleteWhite.image
        action.backgroundColor = Asset.Color.red.color
        
        return action
    }
}

// MARK: - WriteGroupViewControllerDelegate
extension GroupDetailViewController: WriteGroupViewControllerDelegate {
    func completeWriteGroup(group: Group) { /* Handle group write completion */ }
    
    func completeEditGroup(group: Group) {
        self.group = group
        titleLabel.text = group.title
        updateGroupColor()
        writeGroupDelegate?.completeEditGroup(group: group)
    }
    
    func deleteGroup(groupId: Int) {
        writeGroupDelegate?.deleteGroup(groupId: groupId)
    }
}

extension GroupDetailViewController: WriteTodoViewControllerDelegate {
    func completeWriteTodo(todo: Todo) {
        fetchTodosAndUpdateUI()
    }
}
