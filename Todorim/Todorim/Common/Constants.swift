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
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.1.3"
    }
    
    static var appBundleId: String {
        return Bundle.main.bundleIdentifier ?? "com.adcapsule.ToDoRim"
    }
    
    static var appProductId: String {
        return  Bundle.main.object(forInfoDictionaryKey: "AppProductId") as? String ?? "com.adcapsule.ToDoRim.product"
    }
    
    static let gadID: String = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String ?? ""
    static let gadGroupID: String = Bundle.main.object(forInfoDictionaryKey: "GADGroupId") as? String ?? ""
    static let gadTodoID: String = Bundle.main.object(forInfoDictionaryKey: "GADTodoId") as? String ?? ""
    
    static let privacyPolicyUrl: String = "https://sunidev.notion.site/915b9477b94f43ee88e10cdcfa6710d3?pvs=4"
    static let termsOfServiceUrl: String = "https://sunidev.notion.site/ToDoRim-30b5de4a959448098ef4c516924edf60?pvs=25"
}
