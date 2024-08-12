//
//  AddGroupVC.swift
//  HSTODO
//
//  Created by 박현선 on 22/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class AddGroupVC: UIViewController {

    // Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textTitle: MadokaTextField!
    @IBOutlet weak var bottomGuideView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tapAround: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // var
    var sColors = [Int]()
    var eColors = [Int]()
    var selectedColor = 0
    var groupTitle: String = ""
    
    // Action
    @IBAction func textTitleChanged(_ sender: MadokaTextField) {
        sender.setMaxLength(max: 20)
    }
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: UIButton) {
        if checkText() {
            let data = DataGroup()
            data.groupNo = CommonGroup.shared.getMaxGroupNo()
            data.gOrder = CommonGroup.shared.getMaxGOrder()
            data.title = groupTitle
            data.colorIndex = selectedColor
            CommonRealmDB.shared.writeGroup(data: data) { (response) in
                if response {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
            
            let window = UIApplication.shared.keyWindow
            
            if let bottomPadding = window?.safeAreaInsets.bottom {
                let layoutHeight = bottomGuideView.constraints.filter{ $0.identifier == "guideHeight" }.first
                layoutHeight?.constant = bottomPadding
            }
        }
        
        registHeroId()
        
        createKeyboardEvent()
        
        // 배경 색상
        sColors = CommonGroup.shared.sColors
        eColors = CommonGroup.shared.eColors
        
        collectionView.register(UINib(nibName: "GroupColorCell", bundle: nil), forCellWithReuseIdentifier: "GroupColorCell")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
}

// MARK: - extension
extension AddGroupVC {
    
    // textfield 입력 체크
    func checkText() -> Bool {
        
        if let text = textTitle.text {
            if text.isEmpty() {
                let alert = UIAlertController(title: "그룹 이름을 입력하세요.", message: "", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(defaultAction)
                self.present(alert, animated: false, completion: nil)
            } else {
                groupTitle = text
                return true
            }
        }
        return false
    }
    
    // 키보드 기본 처리
    func createKeyboardEvent() {
        // 키보드가 팝업되거나 숨김 처리될 때 화면 처리 noti
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 화면 터치 시 키보드 숨김
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
}

// MARK: - @objc
@objc extension AddGroupVC {
    
    func registHeroId() {
        view.hero.id = "view_addGroup"
//        lblTitle.hero.id = "title_addGroup"
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 키보드 팝업 처리
    func keyboardWillShow(_ sender: Notification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
    }
    
    // 키보드 숨김 처리
    func keyboardWillHide(_ sender: Notification) {
        
    }
    
}


// MARK: - UICollectionView
extension AddGroupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CommonGroup.shared.colorCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupColorCell", for: indexPath) as! GroupColorCell
        
        // 배경 색상
        let colors = [UIColor(rgb: sColors[indexPath.row]), UIColor(rgb: eColors[indexPath.row])]
        let gradientLayer = CAGradientLayer(frame: CGRect(x: 0, y: 0, width: 50, height: 50), colors: colors, startPoint: CGPoint(x: 0.5, y:0), endPoint: CGPoint(x:0.5, y:1))
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
        
        let selectedIndex = IndexPath(row: selectedColor, section: 0)
        let selectedCell = collectionView.cellForItem(at: selectedIndex) as! GroupColorCell
        selectedCell.backView.isHidden = !selectedCell.backView.isHidden
        
        selectedColor = indexPath.row
    }
}

// MARK: - UITextField
extension AddGroupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
