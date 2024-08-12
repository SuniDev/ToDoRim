//
//  CommonNav.swift
//  HSTODO
//
//  Created by 박현선 on 05/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
import MapKit

class CommonNav: NSObject {

    static let shared = CommonNav()
    var vc = UIViewController()
    
    // MARK: - setViewController
    
//    func moveToday() {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "TodayVC") as! TodayVC
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.navigationVC?.setViewControllers([vc], animated: false)
//        }
//    }
    
    func moveGroup() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "GroupVC") as! GroupVC
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.navigationVC?.setViewControllers([vc], animated: false)
        }
    }
    
    
    // MARK: - pushViewController
    func moveGroupTask(_ index: Int) {
        
        let sb = UIStoryboard(name: "Group", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "GroupTaskVC") as! GroupTaskVC
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            vc.groupIndex = index
            appDelegate.navigationVC?.hero.isEnabled = true
            appDelegate.navigationVC?.hero.navigationAnimationType = .none
            appDelegate.navigationVC?.pushViewController(vc, animated: true)
        }
        
    }
    func moveAddTask(_ index: Int, _ superVC: UIViewController) {
        let sb = UIStoryboard(name: "Task", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            vc.groupIndex = index
            vc.superVC = superVC
            vc.modify = false
            appDelegate.navigationVC?.hero.isEnabled = true
            appDelegate.navigationVC?.hero.navigationAnimationType = .cover(direction: .up)
            appDelegate.navigationVC?.pushViewController(vc, animated: true)
        }
    }
    
    func moveModifyTask(gIndex: Int, tIndex: Int, _ superVC: UIViewController) {
        let sb = UIStoryboard(name: "Task", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            vc.groupIndex = gIndex
            vc.superVC = superVC
            vc.taskIndex = tIndex
            vc.modify = true
            appDelegate.navigationVC?.hero.isEnabled = true
            appDelegate.navigationVC?.hero.navigationAnimationType = .cover(direction: .up)
            appDelegate.navigationVC?.pushViewController(vc, animated: true)
        }
    }
    
    func moveSearchLoc(superVC: UIViewController) {
        
        let sb = UIStoryboard(name: "Task", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            vc.superVC = superVC
            appDelegate.navigationVC?.hero.isEnabled = false
            appDelegate.navigationVC?.pushViewController(vc, animated: true)
        }
    }
    
    func moveSearchMap(superVC: UIViewController, searchVC: UIViewController, pin: MKPlacemark) {
        let sb = UIStoryboard(name: "Task", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchLocationMapVC") as! SearchLocationMapVC
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            vc.superVC = superVC
            vc.selectedPin = pin
            vc.searchVC = searchVC
            appDelegate.navigationVC?.pushViewController(vc, animated: true)
        }
    }
    
    
    // MARK: - persent
    func moveAddGroup() {
        
        let sb = UIStoryboard(name: "Group", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddGroupVC") as! AddGroupVC
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            //            appDelegate.navigationVC?.pushViewController(vc, animated: false)
            vc.hero.isEnabled = true
            vc.modalPresentationStyle = .fullScreen
            appDelegate.navigationVC?.hero.isEnabled = true
            appDelegate.navigationVC?.hero.modalAnimationType = .cover(direction: .up)
            appDelegate.navigationVC?.present(vc, animated: true, completion: nil)
        }
    }
    
    func moveModifyGroup(_ index: Int, _ superVC: UIViewController) {
        
        let sb = UIStoryboard(name: "Group", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ModifyGroupVC") as! ModifyGroupVC
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            //            appDelegate.navigationVC?.pushViewController(vc, animated: false)
            vc.groupIndex = index
            vc.modalPresentationStyle = .fullScreen
            vc.superVC = superVC
            vc.modalPresentationStyle = .fullScreen
            appDelegate.navigationVC?.present(vc, animated: true, completion: nil)
        }
    }
    
}
