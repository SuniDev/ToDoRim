//
//  HomeViewController.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

import Hero

class HomeViewController: BaseViewController {
    
    // MARK: - Dependencies
    private var homeService: HomeService?
    
    // MARK: - Data
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
    
    // MARK: - 의존성 주입
    func inject(service: HomeService) {
        self.homeService = service
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataAndUI()
    }
    
    // MARK: - Data 설정
    func fetchDataAndUI() {
        guard let homeService = homeService else { return }
        groups = homeService.fetchGroups()
        todos = homeService.fetchTodos()
        
        collectionView.reloadData()
        updateBackground()
    }
    
    // MARK: - UI 설정
    override func configureUI() {
        configureDateLabel()
        configureCollectionView()
        
        if let firstGroup = groups.first {
            configureBackground(colors: [firstGroup.startColor, firstGroup.endColor])
        } else {
            configureBackground(colors: GroupColor.getColors(index: 0))
        }
    }
    
    private func configureDateLabel() {
        let now = Date()
        let weekFormatter = DateFormatter()
        weekFormatter.locale = Locale(identifier: "ko_KR")
        weekFormatter.dateFormat = "\(now.week())"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        performUIUpdatesOnMain {
            self.weakLabel.text = weekFormatter.string(from: now)
            self.dateLabel.text = dateFormatter.string(from: now)
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "GroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GroupCollectionViewCell")
        collectionView.register(UINib(nibName: "AddGroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddGroupCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    private func configureBackground(colors: [UIColor]) {
        gradientLayer = Utils.getVerticalLayer(frame: UIScreen.main.bounds, colors: colors)
        
        performUIUpdatesOnMain {
            self.backgroundView.layer.addSublayer(self.gradientLayer)
        }
    }
    
    private func updateBackground() {
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
}

// MARK: - Navigation
extension HomeViewController {
    private func popToSelf() {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        
        performUIUpdatesOnMain {
            self.navigationController?.popToViewController(self, animated: true)
        }
    }
    
    private func moveToAddGroup() {
        guard let groupStorage = homeService?.groupStorage else { return }
        let service = WriteGroupService(groupStorage: groupStorage)
        
        guard let viewController = UIStoryboard(name: "Group", bundle: nil).instantiateViewController(withIdentifier: "WriteGroupViewController") as? WriteGroupViewController else { return }
        
        viewController.inject(service: service)
        viewController.delegate = self
        viewController.view.hero.id = AppHeroId.viewGroup.getId()
        
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        
        performUIUpdatesOnMain {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func moveToGroupDetail(with group: Group) {
        guard let groupStorage = homeService?.groupStorage, let todoStorage = homeService?.todoStorage else { return }
        let service = GroupDetailService(groupStorage: groupStorage, todoStorage: todoStorage)
        
        guard let viewController = UIStoryboard(name: "Group", bundle: nil).instantiateViewController(withIdentifier: "GroupDetailViewController") as? GroupDetailViewController else { return }
        
        viewController.inject(service: service)
        viewController.group = group
        viewController.todos = todos.filter { $0.groupId == group.groupId }
        viewController.writeGroupDelegate = self
        
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .none
        
        performUIUpdatesOnMain {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
            moveToGroupDetail(with: groups[indexPath.row])
        } else {
            moveToAddGroup()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let margin = collectionView.contentInset.left + collectionView.contentInset.right
        currentGroupIndex = Int(round(targetContentOffset.pointee.x / (collectionView.bounds.size.width - margin)))
        updateBackground()
    }
}
// MARK: - GroupCollectionViewCellDelegate
extension HomeViewController: GroupCollectionViewCellDelegate {
    func completeTodo(with todo: Todo?, isComplete: Bool) {
        guard let todo else { return }
        
        homeService?.completeTodo(todo: todo, isComplete: isComplete, completion: { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                self.fetchDataAndUI()
            } else {
                // TODO: - 오류 메시지
            }
        })
    } 
    
    func tappedGroup(with group: Group) {
        moveToGroupDetail(with: group)
    }
}

// MARK: - WriteGroupViewControllerDelegate
extension HomeViewController: WriteGroupViewControllerDelegate {
    func deleteGroup(groupId: Int) {
        popToSelf()
        
        performUIUpdatesOnMain {
            self.homeService?.deleteGroup(groupId: groupId, completion: { [weak self] isSuccess in
                guard let self = self else { return }
                if isSuccess {
                    self.fetchDataAndUI()
                } else {
                    // TODO: 오류 메시지
                }
            })
        }
    }
    
    func completeEditGroup(group: Group) {
        fetchDataAndUI()
    }
    
    func completeWriteGroup(group: Group) {
        fetchDataAndUI()
    }
}
