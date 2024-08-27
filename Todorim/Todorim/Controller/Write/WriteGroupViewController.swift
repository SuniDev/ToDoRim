//
//  WriteGroupViewController.swift
//  Todorim
//
//  Created by suni on 8/13/24.
//

import UIKit
import Hero
import GoogleMobileAds

protocol WriteGroupViewControllerDelegate: AnyObject {
    func completeWriteGroup(group: Group)
    func completeEditGroup(group: Group)
    func deleteGroup(groupId: Int)
}

class WriteGroupViewController: BaseViewController {
    
    // MARK: - Dependencies
    private var writeGroupService: WriteGroupService?
    
    // MARK: - Data
    weak var delegate: WriteGroupViewControllerDelegate?
    
    var group: Group?
    var writeGroup: Group = Group()
    var selectedColorIndex: Int = 0
    var interstitial: GADInterstitialAd?
    var isNew: Bool {
        return group == nil
    }
    
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
    
    // MARK: - 의존성 주입 메서드
    func inject(service: WriteGroupService) {
        self.writeGroupService = service
    }
    
    // MARK: - Action
    @IBAction private func changedTextField(_ sender: MadokaTextField) {
        sender.setMaxLength(max: 20)
    }
    
    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        pop()
    }
    
    @IBAction private func tappedAddButton(_ sender: UIButton) {
        if isValidData() {
            writeGroup.title = textfield?.text ?? ""
            writeGroup.appColorIndex = selectedColorIndex
            
            writeGroupService?.addGroup(writeGroup) { [weak self] isSuccess in
                guard let self else { return }
                if isSuccess {
                    self.showInterstitialAd()
                } else {
                    Alert.showError(self, title: "그룹 추가")
                }
            }
        } else {
            Alert.showDone(
                self,
                title: L10n.Alert.WriteGroup.EmptyName.title
            )
        }
    }
    
    @IBAction private func tappedEditButton(_ sender: UIButton) {
        if isValidData(), let group {
            writeGroup.title = textfield?.text ?? ""
            writeGroup.appColorIndex = selectedColorIndex
            
            writeGroupService?.updateGroup(group, with: writeGroup) { [weak self] isSuccess in
                guard let self else { return }
                if isSuccess {
                    self.showInterstitialAd()
                } else {
                    Alert.showError(self, title: "그룹 수정")
                }
            }
        } else {
            Alert.showDone(
                self,
                title: L10n.Alert.WriteGroup.EmptyName.title
            )
        }
    }
    
    @IBAction private func tappedDeleteButton(_ sender: UIButton) {
        let alert = UIAlertController(
            title: L10n.Alert.DeleteGroup.title,
            message: L10n.Alert.DeleteGroup.message,
            preferredStyle: .alert
        )
        let deleteAction = UIAlertAction(title: L10n.Alert.Button.delete, style: .destructive) { [weak self] _ in
            guard let self, let group else { return }
            let id: Int = group.groupId
            self.writeGroupService?.deleteGroup(group) { [weak self] isSuccess in
                guard let self else { return }
                if isSuccess {
                    self.delegate?.deleteGroup(groupId: id)
                } else {
                    Alert.showError(self, title: "그룹 삭제")
                }
            }
        }
        let cancelAction = UIAlertAction(title: L10n.Alert.Button.cancel, style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        performUIUpdatesOnMain {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createKeyboardEvent()
        loadInterstitialAd()
    }
    
    // MARK: - Data 설정
    override func configureHeroID() {
        if let group {
            editButton.hero.id = AppHeroId.button.getId(id: group.groupId)
        }
    }
    
    override func fetchData() {
        writeGroup = writeGroupService?.initializeGroupData(group: group) ?? Group()
    }
    
    // MARK: - UI 설정
    override func configureUI() {
        scrollView.contentInsetAdjustmentBehavior = .never
        configureCollectionView()
        collectionView.reloadData()
        
        configureUIWithData()
        updateButtonColor()
    }
    
    private func configureUIWithData() {
        performUIUpdatesOnMain {
            let writeGroup = self.writeGroup
            if self.isNew {
                self.addButtonView.isHidden = false
                self.editButtonView.isHidden = true
                self.titleLabel.text = L10n.Group.Write.title
            } else {
                self.addButtonView.isHidden = true
                self.editButtonView.isHidden = false
                self.titleLabel.text = L10n.Group.Edit.title
                
                self.selectedColorIndex = writeGroup.appColorIndex
            }
            
            self.textfield.text = writeGroup.title
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "GroupColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GroupColorCollectionViewCell")
    }
    
    private func updateButtonColor() {
        performUIUpdatesOnMain {
            let colors = GroupColor.getColors(index: self.selectedColorIndex)
            if self.isNew {
                self.addButton.layer.cornerRadius = 15
                self.addButton.layer.masksToBounds = true
                let gradientLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 70), colors: colors)
                if let firstLayer = self.addButton.layer.sublayers?.first as? CAGradientLayer {
                    firstLayer.removeFromSuperlayer()  // 기존 레이어 제거
                }
                self.addButton.layer.insertSublayer(gradientLayer, at: 0)
            } else {
                self.deleteButton.layer.cornerRadius = 15
                self.deleteButton.layer.masksToBounds = true
                self.editButton.layer.cornerRadius = 15
                self.editButton.layer.masksToBounds = true
                let gradientLayer = Utils.getHorizontalLayer(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 32) / 2, height: 70), colors: colors)
                if let firstLayer = self.editButton.layer.sublayers?.first as? CAGradientLayer {
                    firstLayer.removeFromSuperlayer()  // 기존 레이어 제거
                }
                self.editButton.layer.insertSublayer(gradientLayer, at: 0)
            }
        }
    }
    
    private func createKeyboardEvent() {
        // 화면 터치 시 키보드 숨김
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helper Methods
    func isValidData() -> Bool {
        if let text = textfield.text, text.isNotEmpty {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Navigation
    private func pop() {
        navigationController?.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .none
        
        performUIUpdatesOnMain {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - 광고
    func loadInterstitialAd() {
        if !Utils.isAdsRemoved {
            let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID: Constants.gadGroupID, request: request, completionHandler: { [weak self] gad, error in
                guard let self else { return }
                if let error = error {
                    print("Failed to load interstitial ad: \(error)")
                    return
                }
                interstitial = gad
                interstitial?.fullScreenContentDelegate = self
            })
        }
    }
    
    func showInterstitialAd() {
        if let interstitial = interstitial, !Utils.isAdsRemoved {
            interstitial.present(fromRootViewController: self)
        } else {
            delegate?.completeWriteGroup(group: writeGroup)
            pop()
            print("Ad wasn't ready")
        }
    }
}

// MARK: - GADFullScreenContentDelegate
extension WriteGroupViewController: GADFullScreenContentDelegate {
    // 광고가 닫힐 때 호출되는 메서드
    func adDidDismissFullScreenContent(_ gad: GADFullScreenPresentingAd) {
        print("Ad was dismissed.")
        if isNew {
            delegate?.completeWriteGroup(group: writeGroup)
        } else {
            delegate?.completeEditGroup(group: writeGroup)
        }
        pop()
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
        updateButtonColor()
    }
}

// MARK: - UITextFieldDelegate
extension WriteGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
