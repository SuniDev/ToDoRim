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
    func completeEditGroup(group: Group)
    func deleteGroup(groupId: Int)
}

class WriteGroupViewController: UIViewController {
    
    // MARK: - Data
    weak var delegate: WriteGroupViewControllerDelegate?
    var groupStorage: GroupStorage?
    var group: Group?
    var writeGroup: Group = Group()
    var selectedColorIndex: Int = 0
    
    // MARK: - Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textfield: MadokaTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButtonView: UIView!
    
    // MARK: - Action
    @IBAction private func changedTextField(_ sender: MadokaTextField) {
        sender.setMaxLength(max: 20)
    }
    
    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func tappedAddButton(_ sender: UIButton) {
        if isValidData() {
            writeGroup.title = textfield?.text ?? ""
            writeGroup.appColorIndex = selectedColorIndex
            
            groupStorage?.add(writeGroup)
            delegate?.completeWriteGroup(group: writeGroup)
        } else {
            let alert = UIAlertController(title: L10n.Alert.WriteGroup.EmptyName.title, message: "", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: L10n.Alert.Button.done, style: .default)
            alert.addAction(defaultAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @IBAction private func tappedEditButton(_ sender: UIButton) {
        if isValidData(), let group {
            writeGroup.title = textfield?.text ?? ""
            writeGroup.appColorIndex = selectedColorIndex
            
            groupStorage?.update(
                with: group,
                writeGroup: writeGroup,
                completion: { [weak self] isSuccess, updateGroup in
                    if isSuccess {
                        self?.delegate?.completeEditGroup(group: updateGroup)
                    } else {
                        // TODO: 오류 메시지
                    }
                })
        } else {
            let alert = UIAlertController(title: L10n.Alert.WriteGroup.EmptyName.title, message: "", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: L10n.Alert.Button.done, style: .default)
            alert.addAction(defaultAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @IBAction private func tappedDeleteButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: L10n.Alert.DeleteGroup.title, message: L10n.Alert.DeleteGroup.message, preferredStyle: UIAlertController.Style.alert)
        let deleteAction = UIAlertAction(title: L10n.Alert.Button.delete, style: .destructive) {  [weak self] _ in
            guard let self, let group else { return }
            let id = group.groupId
            self.groupStorage?.delete(with: group, completion: { [weak self] isSuccess in
                if isSuccess {
                    self?.delegate?.deleteGroup(groupId: id)
                } else {
                    // TODO: 오류 메시지
                }
            })
            
        }
        let cancleAction = UIAlertAction(title: L10n.Alert.Button.cancel, style: .default)
        alert.addAction(cancleAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: false, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        createKeyboardEvent()
        
        configureHeroID()
        configureData()
        configureCollectionView()
        
        collectionView.reloadData()
        configureButtonColor()
    }
    
    func configureHeroID() {
        if let group {
            editButton.hero.id = AppHeroId.button.getId(id: group.groupId)
        }
    }
    
    func configureData() {
        if let group {
            addButtonView.isHidden = true
            editButtonView.isHidden = false
            titleLabel.text = L10n.Group.Edit.title
            
            writeGroup.title = group.title
            writeGroup.appColorIndex = group.appColorIndex
        } else {
            addButtonView.isHidden = false
            editButtonView.isHidden = true
            titleLabel.text = L10n.Group.Write.title
            
            writeGroup.groupId = groupStorage?.getNextId() ?? 0
            writeGroup.order = groupStorage?.getNextOrder() ?? 0
            writeGroup.startColor = GroupColor.getStart(index: 0)
            writeGroup.endColor = GroupColor.getEnd(index: 0)
            writeGroup.appColorIndex = 0
        }
        
        textfield.text = writeGroup.title
        selectedColorIndex = writeGroup.appColorIndex
    }
    
    func configureCollectionView() {
        collectionView.register(UINib(nibName: "GroupColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GroupColorCollectionViewCell")
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
    
    func configureButtonColor() {
        
        let colors = GroupColor.getColors(index: selectedColorIndex)
        if group != nil {
            deleteButton.layer.cornerRadius = 15
            deleteButton.layer.masksToBounds = true
            editButton.layer.cornerRadius = 15
            editButton.layer.masksToBounds = true
            let gradientLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 32) / 2, height: 70), colors: colors)
            if let firstLayer = editButton.layer.sublayers?.first as? CAGradientLayer {
                firstLayer.removeFromSuperlayer()  // 기존 레이어 제거
            }
            editButton.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            addButton.layer.cornerRadius = 15
            addButton.layer.masksToBounds = true
            let gradientLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 70), colors: colors)
            if let firstLayer = addButton.layer.sublayers?.first as? CAGradientLayer {
                firstLayer.removeFromSuperlayer()  // 기존 레이어 제거
            }
            addButton.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension WriteGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GroupColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupColorCollectionViewCell", for: indexPath) as? GroupColorCollectionViewCell else { return UICollectionViewCell() }
        
        // 배경 색상
        let colors = GroupColor.getColors(index: indexPath.row)
        let isSelected = indexPath.row == selectedColorIndex
        
        cell.configure(with: colors, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GroupColorCollectionViewCell else { return }
        
        cell.setSelect()
        
        let selectedIndex = IndexPath(row: selectedColorIndex, section: 0)
        if let selectedCell = collectionView.cellForItem(at: selectedIndex) as? GroupColorCollectionViewCell {
            selectedCell.setSelect()
        }
        
        selectedColorIndex = indexPath.row
        configureButtonColor()
    }
}

// MARK: - UITextFieldDelegate
extension WriteGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
