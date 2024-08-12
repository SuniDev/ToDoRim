//
//  IntroVC.swift
//  HSTODO
//
//  Created by 박현선 on 05/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isInitYn = UserDefaults.standard.string(forKey: "isInitYn") ?? "N"
        if isInitYn == "N" {
            CommonRealmDB.shared.setupRealm()
            let data = DataGroup()
            CommonRealmDB.shared.writeGroup(data: data) { (response) in
                if response {
                    UserDefaults.standard.set("Y", forKey: "isInitYn")
                    CommonNav.shared.moveGroup()
                }
            }
        } else {
            CommonRealmDB.shared.updateRealm { (response) in
                CommonRealmDB.shared.updateVersion { (response) in
                   CommonRealmDB.shared.fetchGroup { (response) in
                          if response {
                              CommonNav.shared.moveGroup()
                          }
                    }
                }
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
}
