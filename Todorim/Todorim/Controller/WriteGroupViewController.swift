//
//  WriteGroupViewController.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit

import Hero

protocol WriteGroupViewControllerDelegate: AnyObject {
    func completeWriteGroup(group: Group)
}

class WriteGroupViewController: UIViewController {
    
    // MARK: - Data
    weak var delegate: WriteGroupViewControllerDelegate?
    var groupStorage: GroupStorage?
    var selectedColorIndex = 0
    var isNew: Bool = false {
        didSet {
            addButtonView.isHidden = !isNew
            editButtonView.isHidden = isNew
            editBottomView.isHidden = isNew
            titleLabel.text = isNew ? "그룹 추가" : "그룹 수정"
        }
    }
    
    // MARK: - Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textfield: MadokaTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var editBottomView: UIView!
    
    
    // MARK: - Action
    @IBAction func changedTextField(_ sender: MadokaTextField) {
        sender.setMaxLength(max: 20)
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedAddButton(_ sender: UIButton) {
        if isValidData() {
            let group = Group()
            group.groupId = groupStorage?.getNextId() ?? 0
            group.order = groupStorage?.getNextOrder() ?? 0
            group.title = textfield?.text ?? ""
            group.startColor = GroupColor.getStart(index: selectedColorIndex)
            group.endColor = GroupColor.getEnd(index: selectedColorIndex)
            
            groupStorage?.add(group)
            delegate?.completeWriteGroup(group: group)
        } else {
            let alert = UIAlertController(title: "그룹 이름을 입력하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(defaultAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @IBAction func tappedEditButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tappedDeleteButton(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.hero.id = AppHeroId.viewAddGroup.getId()
        
        scrollView.contentInsetAdjustmentBehavior = .never
        createKeyboardEvent()
        
        collectionView.register(UINib(nibName: "GroupColorCell", bundle: nil), forCellWithReuseIdentifier: "GroupColorCell")
    }
    
    
    // 키보드 기본 처리
    func createKeyboardEvent() {
        // 화면 터치 시 키보드 숨김
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func isValidData() -> Bool {
        if let text = textfield.text, text.isNotEmpty {
            return true
        } else {
            return false
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension WriteGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GroupColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupColorCell", for: indexPath) as! GroupColorCell
        
        // 배경 색상
        let colors = GroupColor.getColors(index: indexPath.row)
        let gradientLayer = Utils.getVerticalLayer(frame: CGRect(x: 0, y: 0, width: 50, height: 50), colors: colors)
        cell.view.layer.addSublayer(gradientLayer)
        
        // default 색상
        if indexPath.row == 0 {
            cell.backView.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GroupColorCell
        cell.backView.isHidden = !cell.backView.isHidden
        
        let selectedIndex = IndexPath(row: selectedColorIndex, section: 0)
        let selectedCell = collectionView.cellForItem(at: selectedIndex) as! GroupColorCell
        selectedCell.backView.isHidden = !selectedCell.backView.isHidden
        
        selectedColorIndex = indexPath.row
    }
}

// MARK: - UITextFieldDelegate
extension WriteGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
