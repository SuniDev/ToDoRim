//
//  GroupVC.swift
//  HSTODO
//
//  Created by 박현선 on 16/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class GroupVC: UIViewController {

    
    // Outlet
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var weekText: UILabel!
    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // var
    var gradientLayer: CAGradientLayer!
    var currentColorSet = [CGColor]()
    var currentIndex = 0
    var isInit = true
    var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CommonNav.shared.vc = self
        
        // Today
        let now = Date()
        let weekFormatter = DateFormatter()
        weekFormatter.locale = Locale(identifier: "ko_KR")
        weekFormatter.dateFormat = "\(now.week())"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "M월 d일"
        
        weekText.text = weekFormatter.string(from: Date())
        dayText.text = dayFormatter.string(from: Date())
        
        var colors = [UIColor]()
//        colors.append(UIColor(rgb: CommonGroup.shared.getStartColor(index: 0)))
//        colors.append(UIColor(rgb: CommonGroup.shared.getEndColor(index: 0)))
        colors.append(UIColor(rgb: CommonGroup.shared.getStartColor(gIndex: 0)))
        colors.append(UIColor(rgb: CommonGroup.shared.getEndColor(gIndex: 0)))
        gradientLayer = CAGradientLayer(frame: self.view.frame, colors: colors, startPoint: CGPoint(x: 0.5, y:0), endPoint: CGPoint(x:0.5, y:1))
        bgView.layer.addSublayer(gradientLayer)
        
        viewConfigrations()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
            collectionView.reloadData()
            colorChange()
    }

    override func viewWillDisappear(_ animated: Bool) {
    }
}

// MARK: - extension
extension GroupVC {
    
    func reloadView() {
        
    }
    
    func viewConfigrations() {
        
        collectionView.register(UINib(nibName: "GroupCell", bundle: nil), forCellWithReuseIdentifier: "GroupCell")
        collectionView.register(UINib(nibName: "AddGroupCell", bundle: nil), forCellWithReuseIdentifier: "AddGroupCell")
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    func colorChange() {
        currentColorSet = [CGColor]()
        if currentIndex >= CommonGroup.shared.count() {
            currentColorSet = [UIColor.init(rgb: CommonGroup.shared.sColors[0]).cgColor,UIColor.init(rgb: CommonGroup.shared.eColors[0]).cgColor]
        } else {
            currentColorSet = [UIColor.init(rgb: CommonGroup.shared.getStartColor(gIndex: currentIndex)).cgColor,UIColor.init(rgb: CommonGroup.shared.getEndColor(gIndex: currentIndex)).cgColor]
        }
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.duration = 0.1
        colorAnimation.toValue = currentColorSet
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.delegate = self
        gradientLayer.add(colorAnimation, forKey: "colorChange")
    }
}
// MARK: - CAAnimationDelegate
extension GroupVC: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        gradientLayer.colors = currentColorSet
    }
}

// MARK: - UICollectionView
extension GroupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print( CommonGroup.shared.count())
        return CommonGroup.shared.count() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row >= CommonGroup.shared.count() {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddGroupCell", for: indexPath) as! AddGroupCell
            cell.contentView.hero.id = "view_addGroup"
//            cell.title.hero.id = "title_addGroup"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCell
            
            var colors = [UIColor]()
            colors.append(UIColor(rgb: CommonGroup.shared.getStartColor(gIndex: indexPath.row)))
            colors.append(UIColor(rgb: CommonGroup.shared.getEndColor(gIndex: indexPath.row)))
            let progressLayer = CAGradientLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5.0), colors: colors, startPoint: CGPoint(x: 0, y:0.5), endPoint: CGPoint(x: 1.0, y:0.5))
            cell.taskProgress.progressImage = progressLayer.createGradientImage()
            cell.title.text = CommonGroup.shared.arrGroup[indexPath.row].title
            cell.groupIndex = indexPath.row
            cell.arrTask = CommonGroup.shared.getArrCheck(gIndex: indexPath.row)
            cell.taskCount = cell.arrTask.count
            
            if CommonGroup.shared.getCheckTask(gIndex: indexPath.row) == 0 {
                cell.taskPercent.text = "0 %"
                cell.taskProgress.progress = 0.0
            } else {
                let percent =  Float(CommonGroup.shared.getCheckTask(gIndex: indexPath.row)) / Float(CommonGroup.shared.getAllTask(gIndex: indexPath.row))
                cell.taskProgress.progress = percent
                cell.taskPercent.text = "\(Int(percent * 100)) %"
            }
            cell.tableView.reloadData()
            
            cell.contentView.hero.id = "view_\(indexPath.row)"
            cell.title.hero.id = "title_\(indexPath.row)"
            cell.taskProgress.hero.id = "progress_\(indexPath.row)"
            cell.taskPercent.hero.id = "percent_\(indexPath.row)"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        
        cellSize.width -= collectionView.contentInset.left * 2
        cellSize.width -= collectionView.contentInset.right * 2
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= CommonGroup.shared.count() {
            CommonNav.shared.moveAddGroup()
        } else {
                CommonNav.shared.moveGroupTask(indexPath.row)
            
        }
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        currentIndex = Int(round(targetContentOffset.pointee.x/(self.view.frame.width-50)))
        colorChange()
    }
}
