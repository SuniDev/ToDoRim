//
//  Constants.swift
//  Todorim
//
//  Created by suni on 8/21/24.
//

import Foundation

class Constants {
    static let appMail: String = "suniapps919@gmail.com"
    static let appStoreId: String = "id1483006749"
    static var appName: String {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return appName
        } else {
            return "ToDoRim"
        }
    }
    
    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.2"
    }
    
    static var appBundleId: String {
        return Bundle.main.bundleIdentifier ?? "com.adcapsule.ToDoRim"
    }
    
    static let gadID: String = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String ?? ""
    static let gadGroupID: String = Bundle.main.object(forInfoDictionaryKey: "GADGroupId") as? String ?? ""
    static let gadTodoID: String = Bundle.main.object(forInfoDictionaryKey: "GADTodoId") as? String ?? ""
}
