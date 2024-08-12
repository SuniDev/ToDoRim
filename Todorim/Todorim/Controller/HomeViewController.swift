//
//  HomeViewController.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

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
        fetchGroup()
        fetchTodo()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        collectionView.reloadData()
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
        collectionView.register(UINib(nibName: "AddGroupCell", bundle: nil), forCellWithReuseIdentifier: "AddGroupCell")
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    func fetchGroup() {
        groups = groupStorage?.getGroups() ?? []
    }
    
    func fetchTodo() {
        todos = todoStorage?.getTodos() ?? []
    }
    
    func configureBackground(colors: [UIColor]) {
        gradientLayer = Utils.getBackgroundLayer(colors: colors)
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
                let todos = todos.filter{ $0.groupId == group.groupId }
                cell.configure(group: group, todos: todos, delegate: self)
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddGroupCell", for: indexPath) as? AddGroupCell {
                cell.contentView.hero.id = "view_addGroup"
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width -= collectionView.contentInset.left
        cellSize.width -= collectionView.contentInset.right
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < groups.count {
            // TODO: - 상세로 이동
        } else {
            // TODO: - 추가로 이동
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
    func completeTodo(with group: Group, todo: Todo, isComplete: Bool) {
        todoStorage?.update(todo, completion: { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                self.fetchTodo()
                self.collectionView.reloadData()
            } else {
                // TODO: - 오류 메시지
            }
        })
    }
    
    func moveGroupDetail(with group: Group) {
        // TODO: - 상세로 이동
    }
}