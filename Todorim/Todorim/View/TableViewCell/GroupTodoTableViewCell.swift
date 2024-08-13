//
//  GroupTodoTableViewCell.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit

protocol GroupTodoTableViewCellDelegate: AnyObject {
    func completeTodo(with todo: Todo?, isComplete: Bool)
}
class GroupTodoTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var completeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - IBAction
    @IBAction func tappedCompleteButton(_ sender: Any) {
        let isComplete = !(todo?.isComplete ?? true)
        delegate?.completeTodo(with: todo, isComplete: isComplete)
    }
    
    // MARK: - Data
    weak var delegate: GroupTodoTableViewCellDelegate?
    var todo: Todo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with todo: Todo, delegate: GroupTodoTableViewCellDelegate) {
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
