//
//  TodoTableViewCell.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var completeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
        
    @IBOutlet weak var dateNotiView: UIView!
    @IBOutlet weak var dateNotiImage: UIImageView!
    @IBOutlet weak var dateNotiLabel: UILabel!
    @IBOutlet weak var dateNotiViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var locationNotiView: UIView!
    @IBOutlet weak var locationNotiImage: UIImageView!
    @IBOutlet weak var locationNotiLabel: UILabel!
    @IBOutlet weak var locationNotiViewHeight: NSLayoutConstraint!
    
    
    // MARK: - Data
    var todo: Todo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with todo: Todo) {
        let isComplete = todo.isComplete
        
        if isComplete {
            titleLabel.attributedText = Utils.getCompleteAttributedText(with: todo.title)
            titleLabel.textColor = .lightGray
            
            completeImage.image = Asset.Assets.checkGray.image
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = todo.title
            titleLabel.textColor = Asset.Color.default.color
            
            completeImage.image = Asset.Assets.uncheckDefault.image
        }
        
        if todo.isDateNoti {
            dateNotiView.isHidden = false
            dateNotiViewHeight.constant = 20
            
            dateNotiLabel.textColor = isComplete ? .lightGray : Asset.Color.default.color
            dateNotiImage.image = isComplete ? Asset.Assets.alarmGray.image : Asset.Assets.alarmDefault.image
            
            dateNotiLabel.text = getDateNotiTitle(with: todo)
        } else {
            dateNotiView.isHidden = true
            dateNotiViewHeight.constant = 0
        }
        
        if todo.isLocationNoti {
            locationNotiView.isHidden = false
            locationNotiViewHeight.constant = 20
            
            locationNotiLabel.textColor = isComplete ? .lightGray : Asset.Color.default.color
            locationNotiImage.image = isComplete ? Asset.Assets.mapGray.image : Asset.Assets.mapDefault.image
            
            locationNotiLabel.text = "\(todo.locationName) \(todo.locationNotiType.title)"
        } else {
            locationNotiView.isHidden = true
            locationNotiViewHeight.constant = 0
        }
    }
    
    private func getDateNotiTitle(with todo: Todo) -> String {
        guard let date = todo.date else { return "" }
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.timeStyle = .short
        timeFormatter.dateFormat =  "a hh:mm"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat =  "M월 d일(EEEE) a hh:mm"
               
        switch todo.repeatNotiType {
        case .none:
            dateFormatter.dateFormat =  "M월 d일(EEEE) a hh:mm"
            return "\(dateFormatter.string(from: date))"
        case .daily:
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat =  "a hh:mm"
            return "\(todo.repeatNotiType.title) \(dateFormatter.string(from: date))"
        case .weekly:
            return "\(todo.repeatNotiType.title) \(todo.weekType.title) \(timeFormatter.string(from: date))"
        case .monthly:
            return "\(todo.repeatNotiType.title) \(todo.day)일 \(timeFormatter.string(from: date))"
        }
    }
}
