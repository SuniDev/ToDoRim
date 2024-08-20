//
//  HomeTodoTableViewCell.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit

protocol HomeTodoTableViewCellDelegate: AnyObject {
    func completeTodo(with todo: Todo?, isComplete: Bool)
}
class HomeTodoTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var completeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - IBAction
    @IBAction private func tappedCompleteButton(_ sender: Any) {
        let isComplete = !(todo?.isComplete ?? true)
        delegate?.completeTodo(with: todo, isComplete: isComplete)
    }
    
    // MARK: - Data
    weak var delegate: HomeTodoTableViewCellDelegate?
    var todo: Todo?
    
    func configure(with todo: Todo, delegate: HomeTodoTableViewCellDelegate) {
        self.todo = todo
        self.delegate = delegate
        
        if todo.isComplete {
            completeImage.image = Asset.Assets.checkGray.image
            titleLabel.textColor = .lightGray
            titleLabel.attributedText = Utils.getCompleteAttributedText(with: todo.title)
        } else {
            completeImage.image = Asset.Assets.uncheckDefault.image
            titleLabel.textColor = Asset.Color.default.color
            titleLabel.attributedText = nil
            titleLabel.text = todo.title
        }
    }
}
