//
//  ModifyGroupVC.swift
//  HSTODO
//
//  Created by 박현선 on 23/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class ModifyGroupVC: UIViewController {

    // Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textTitle: MadokaTextField!
    @IBOutlet weak var bottomGuideView1: UIView!
    @IBOutlet weak var bottomGuideView2: UIView!
    @IBOutlet weak var btnModify: UIButton!
    @IBOutlet weak var textNotice: UILabel!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tapAround: UIView!
    
    // var
    var sColors = [Int]()
    var eColors = [Int]()
    var selectedColor = 0       // 선택된 색상
    var groupIndex = 0
    var groupNo = 0
    var superVC: UIViewController!
    var groupTitle: String = ""
    
    // Action
    @IBAction func textTitleChanged(_ sender: MadokaTextField) {
        sender.setMaxLength(max: 20)
    }
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func modifyGroup(_ sender: UIButton) {
        if checkText() {
            let data = DataGroup()
            data.groupNo = groupNo
            data.title = groupTitle
            data.colorIndex = selectedColor
            CommonRealmDB.shared.updateGroup(data: data) { (response) in
                if response {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // TODO: - 태스크도 다 지울지 물어보기
    @IBAction func deleteGroup(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "그룹을 삭제하시겠습니까?", message: "그룹내 할일이 모두 삭제됩니다.", preferredStyle: UIAlertController.Style.alert)
        let deleteAction = UIAlertAction(title: "네", style: .default) {  (result) in
//            CommonRealmDB.shared.deleteGroupTask(groupNo: self.groupNo) { (response) in
//                if response {
            CommonRealmDB.shared.deleteGroup(gIndex: self.groupIndex) { (response) in
                        if response {
                            self.superVC.navigationController?.popViewController(animated: false)
                            self.dismiss(animated: true, completion: nil)
                        }
//                    }
//                }
            }
            
        }
        let cancleAction = UIAlertAction(title: "아니요", style: .destructive)
        alert.addAction(cancleAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: false, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
            
            let window = UIApplication.shared.keyWindow
            
            if let bottomPadding = window?.safeAreaInsets.bottom {
                let layoutHeight1 = bottomGuideView1.constraints.filter{ $0.identifier == "guideHeight" }.first
               let layoutHeight2 = bottomGuideView2.constraints.filter{ $0.identifier == "guideHeight" }.first
                layoutHeight1?.constant = bottomPadding
                layoutHeight2?.constant = bottomPadding
            }
        }
        
        createKeyboardEvent()
        
//        groupNo = CommonGroup.shared.getNo(index: groupIndex)
        groupNo = CommonGroup.shared.arrGroup[groupIndex].groupNo
        
        // 배경 색상
        sColors = CommonGroup.shared.sColors
        eColors = CommonGroup.shared.eColors
        
        collectionView.register(UINib(nibName: "GroupColorCell", bundle: nil), forCellWithReuseIdentifier: "GroupColorCell")
        
        // modify 세팅
        textTitle.text = CommonGroup.shared.arrGroup[groupIndex].title
        selectedColor = CommonGroup.shared.getColorIndex(gIndex: groupIndex)
        
        // 기본그룹은 삭제 불가
        if groupNo == 0 {
            btnModify.isEnabled = false
            btnModify.backgroundColor = UIColor.lightGray
            bottomGuideView1.backgroundColor = UIColor.lightGray
            textNotice.text = "* 기본그룹은 삭제할 수 없습니다."
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
}

extension ModifyGroupVC {
    
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
@objc extension ModifyGroupVC {
    
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
extension ModifyGroupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CommonGroup.shared.colorCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupColorCell", for: indexPath) as! GroupColorCell
        
        // 배경 색상
        let colors = [UIColor(rgb: sColors[indexPath.row]), UIColor(rgb: eColors[indexPath.row])]
        let gradientLayer = CAGradientLayer(frame: CGRect(x: 0, y: 0, width: 50, height: 50), colors: colors, startPoint: CGPoint(x: 0.5, y:0), endPoint: CGPoint(x:0.5, y:1))
        cell.view.layer.addSublayer(gradientLayer)
        
        // default 배경 색상
        if indexPath.row == selectedColor {
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
extension ModifyGroupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
