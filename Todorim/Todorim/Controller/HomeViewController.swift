//
//  HomeViewController.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

import Hero

class HomeViewController: UIViewController {
    
    // MARK: - Data
    var groupStorage: GroupStorage?
    var todoStorage: TodoStorage?
    
    var groups: [Group] = []
    var todos: [Todo] = []
    
    var currentGroupIndex = 0
    var currentColors: [CGColor] = []
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    // MARK: - Outlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var weakLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGroup()
        fetchTodo()
        collectionView.reloadData()
        colorChange()
    }
    
    func configureUI() {
        configureDate()
        configureCollectionView()
        
        if groups.count > 0 {
            let group = groups[0]
            configureBackground(colors: [group.startColor, group.endColor])
        } else {
            configureBackground(colors: GroupColor.getColors(index: 0))
        }
    }
    
    func configureDate() {
        let now = Date()
        let weekFormatter = DateFormatter()
        weekFormatter.locale = Locale(identifier: "ko_KR")
        weekFormatter.dateFormat = "\(now.week())"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        
        weakLabel.text = weekFormatter.string(from: now)
        dateLabel.text = dateFormatter.string(from: now)
    }
    
    func configureCollectionView() {
        collectionView.register(UINib(nibName: "GroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GroupCollectionViewCell")
        collectionView.register(UINib(nibName: "AddGroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddGroupCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    func configureBackground(colors: [UIColor]) {
        gradientLayer = Utils.getVerticalLayer(frame: UIScreen.main.bounds, colors: colors)
        backgroundView.layer.addSublayer(gradientLayer)
    }
    
    func colorChange() {
        currentColors = []
        
        if currentGroupIndex < groups.count {
            let group = groups[currentGroupIndex]
            currentColors = [group.startColor.cgColor, group.endColor.cgColor]
        } else {
            currentColors = GroupColor.getColors(index: 0).map { $0.cgColor }
        }
        
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.duration = 0.1
        colorAnimation.toValue = currentColors
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.delegate = self
        gradientLayer.add(colorAnimation, forKey: "colorChange")
    }
    
    func fetchGroup() {
        groups = groupStorage?.getGroups() ?? []
    }
    
    func fetchTodo() {
        todos = todoStorage?.getTodos() ?? []
    }
}

// MARK: - CAAnimationDelegate
extension HomeViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        gradientLayer.colors = currentColors
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < groups.count {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCollectionViewCell", for: indexPath) as? GroupCollectionViewCell {
                let group = groups[indexPath.row]
                let todos = todos.filter { $0.groupId == group.groupId }
                cell.configure(with: group, todos: todos, delegate: self)
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddGroupCollectionViewCell", for: indexPath) as? AddGroupCollectionViewCell {
                cell.configure()
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width -= collectionView.contentInset.left * 2
        cellSize.width -= collectionView.contentInset.right * 2
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < groups.count {
            moveGroupDetail(with: groups[indexPath.row])
        } else {
            moveAddGroup()
        }
    }
    
    func moveAddGroup() {
        guard let viewController = UIStoryboard(name: "Group", bundle: nil).instantiateViewController(withIdentifier: "WriteGroupViewController") as? WriteGroupViewController else { return }
        
        viewController.delegate = self
        viewController.groupStorage = groupStorage
        viewController.view.hero.id = AppHeroId.viewGroup.getId()
        
        navigationController?.hero.isEnabled = true
        navigationController?.hero.modalAnimationType = .cover(direction: .up)
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let margin = collectionView.contentInset.left + collectionView.contentInset.right
        currentGroupIndex = Int(round(targetContentOffset.pointee.x / (collectionView.bounds.size.width - margin)))
        colorChange()
    }
}

// MARK: - GroupCollectionViewCellDelegate
extension HomeViewController: GroupCollectionViewCellDelegate {
    func completeTodo(with todo: Todo?, isComplete: Bool) {
        guard let todo else { return }
        
        todoStorage?.updateComplete(with: todo, isComplete: isComplete, completion: { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                self.updateNotification(with: todo, isComplete: isComplete)
                self.fetchTodo()
                self.collectionView.reloadData()
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
    
    func moveGroupDetail(with group: Group?) {
        guard let group else { return }
        guard let viewController = UIStoryboard(name: "Group", bundle: nil).instantiateViewController(withIdentifier: "GroupDetailViewController") as? GroupDetailViewController else { return }
        
        viewController.todoStorage = todoStorage
        viewController.groupStorage = groupStorage
        viewController.group = group
        viewController.todos = todos.filter { $0.groupId == group.groupId }
        viewController.writeGroupDelegate = self
        
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - WriteGroupViewControllerDelegate
extension HomeViewController: WriteGroupViewControllerDelegate {
    func deleteGroup(groupId: Int) {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        navigationController?.popToViewController(self, animated: true)
        self.fetchGroup()
        self.collectionView.reloadData()
        
        self.todoStorage?.deleteTodos(groupId: groupId, completion: { isSuccess in
            if isSuccess {
                self.removeNotifications(groupId: groupId)
                self.fetchTodo()
            } else {
                // TODO: 오류메시지
            }
        })
    }
    
    func removeNotifications(groupId: Int) {
        let todos = todos.filter { $0.groupId == groupId }
        for todo in todos {
            NotificationManager.shared.remove(id: todo.todoId)
        }
    }
    
    func completeEditGroup(group: Group) {
        self.fetchGroup()
        self.collectionView.reloadData()
    }
    
    func completeWriteGroup(group: Group) {
        dismiss(animated: true) {
            self.fetchGroup()
            self.collectionView.reloadData()
        }
    }
}
