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
    var group: Group?
    var selectedColorIndex: Int = 0
    
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
        if isValidData(), let group {
            group.title = textfield?.text ?? ""
            
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
        if isValidData(), let group {
            groupStorage?.update(
                with: group,
                title: textfield?.text ?? "",
                startColor: GroupColor.getStart(index: selectedColorIndex),
                endColor: GroupColor.getEnd(index: selectedColorIndex),
                appColorIndex: selectedColorIndex,
                completion: { [weak self] isSuccess, group in
                    if isSuccess {
                        self?.delegate?.completeWriteGroup(group: group)
                    } else {
                        // TODO: 오류 메시지
                    }
                })
        } else {
            let alert = UIAlertController(title: "그룹 이름을 입력하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(defaultAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @IBAction func tappedDeleteButton(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        createKeyboardEvent()
        
        collectionView.register(UINib(nibName: "GroupColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GroupColorCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let group {
            addButtonView.isHidden = true
            editButtonView.isHidden = false
            editBottomView.isHidden = false
            titleLabel.text = "그룹 수정"
            
            textfield.text = group.title
            selectedColorIndex = group.appColorIndex
        } else {
            addButtonView.isHidden = false
            editButtonView.isHidden = true
            editBottomView.isHidden = true
            titleLabel.text = "그룹 추가"
            
            group = Group()
            group?.groupId = groupStorage?.getNextId() ?? 0
            group?.order = groupStorage?.getNextOrder() ?? 0
            group?.startColor = GroupColor.getStart(index: 0)
            group?.endColor = GroupColor.getEnd(index: 0)
            group?.appColorIndex = 0
        }
        
        collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupColorCollectionViewCell", for: indexPath) as! GroupColorCollectionViewCell
        
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
    }
}

// MARK: - UITextFieldDelegate
extension WriteGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
