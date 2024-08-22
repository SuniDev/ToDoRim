//
//  Constants.swift
//  Todorim
//
//  Created by suni on 8/21/24.
//

import Foundation

class Constants {
    static let appMail: String = "hyunsun819@gmail.com"
    static let appStoreId: String = "id1483006749"
    
    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.2"
    }
    
    static let gadID: String = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String ?? ""
    static let gadGroupID: String = Bundle.main.object(forInfoDictionaryKey: "GADGroupId") as? String ?? ""
    static let gadTodoID: String = Bundle.main.object(forInfoDictionaryKey: "GADTodoId") as? String ?? ""
}
