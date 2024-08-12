//
//  AppUserDefaults.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import Foundation

class AppUserDefaults {
    
    enum UserDefaultsKey: String {
        case isInit
    }
    
    /**
     # getObject
     - parameters:
        - key : 반환할 value의 UserDefaults Key - (E) UserDefaultsKey
     - Authors: suni
     - Note: UserDefaults 값을 반환하는 공용 함수
     */
    static func getObject(forKey key: UserDefaultsKey) -> Any? {
        let defaults = UserDefaults.standard
        if let object = defaults.object(forKey: key.rawValue) {
            return object
        } else {
            return nil
        }
    }
    
    /**
     # set
     - parameters:
        - value : 저장할 값
        - key : 저장할 value의 UserDefaults Key - (E) UserDefaultsKey
     - Authors: suni
     - Note: UserDefaults 값을 저장하는 공용 함수
     */
    static func set(_ value: Any?, forKey key: UserDefaultsKey) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
    
    /**
     # remove
     - parameters:
        - key : 삭제할 value의 UserDefaults Key - (E) UserDefaultsKey
     - Authors: suni
     - Note: UserDefaults 값을 삭제하는 공용 함수
     */
    static func remove(forKey key: UserDefaultsKey) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key.rawValue)
    }
}
