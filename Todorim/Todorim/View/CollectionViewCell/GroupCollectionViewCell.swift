//
//  GroupCollectionViewCell.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit

protocol GroupCollectionViewCellDelegate: AnyObject {
    func completeTodo(with todo: Todo?, isComplete: Bool)
    func moveGroupDetail(with group: Group?)
}

class GroupCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Data
    weak var delegate: GroupCollectionViewCellDelegate?
    var group: Group?
    var todos: [Todo] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        
        self.setCardBorder()
        
        tableView.register(UINib(nibName: "HomeTodoTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTodoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configure(with group: Group, todos: [Todo], delegate: GroupCollectionViewCellDelegate) {
        self.group = group
        self.todos = todos
        self.delegate = delegate
        
        let colors = [group.startColor, group.endColor]
        let progressLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5.0), colors: colors)
        progress.progressImage = progressLayer.createGradientImage()
        progress.layer.cornerRadius = progress.frame.height / 2
        progress.clipsToBounds = true
        if progress.layer.sublayers?.count ?? 0 > 0 && progress.subviews.count > 0 {
            progress.layer.sublayers?[1].cornerRadius = progress.frame.height / 2
            progress.subviews[1].clipsToBounds = true
        }
        
        titleLabel.text = group.title
        
        updateProgress()
        tableView.reloadData()
        
        configureHeroID()
        
        let tappedView = UITapGestureRecognizer.init(target: self, action: #selector(tappedView))
        tableView.addGestureRecognizer(tappedView)
    }
    
    func configureHeroID() {
        let id = group?.groupId ?? 0
        contentView.hero.id = AppHeroId.viewGroupDetail.getId(id: id)
        titleLabel.hero.id = AppHeroId.title.getId(id: id)
        progress.hero.id = AppHeroId.progress.getId(id: id)
        percentLabel.hero.id = AppHeroId.percent.getId(id: id)
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
        
        progress.setProgress(percent, animated: true)
    }
    
    @objc
    func tappedView() {
        delegate?.moveGroupDetail(with: group)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTodoTableViewCell", for: indexPath) as? HomeTodoTableViewCell,
              indexPath.row < todos.count else { return UITableViewCell() }
        
        let todo = todos[indexPath.row]
        cell.configure(with: todo, delegate: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.moveGroupDetail(with: group)
    }
    
}

extension GroupCollectionViewCell: HomeTodoTableViewCellDelegate {
    func completeTodo(with todo: Todo?, isComplete: Bool) {
        delegate?.completeTodo(with: todo, isComplete: isComplete)
    }
}
