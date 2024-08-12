//
//  RealmManager.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import Foundation

import RealmSwift

class RealmManager {
    
    private var realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch let error as NSError {
            fatalError("Failed to open Realm database: \(error.localizedDescription)")
        }
    }
    
    static let shared = RealmManager()
    
    func add<T: Object>(_ object: T, update: Realm.UpdatePolicy = .error) {
        do {
            try realm.write {
                realm.add(object, update: update)
            }
        } catch let error as NSError {
            print("Failed to add object to Realm: \(error.localizedDescription)")
        }
    }
    
    func delete<T: Object>(object: T, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> (Void)) {
        do {
            try realm.write {
                realm.delete(object)
                completion(true, nil)
            }
        } catch let error as NSError {
            print("Failed to delete object from Realm: \(error.localizedDescription)")
            completion(false, error)
        }
    }
    
    func delete<T: Object>(object: Results<T>, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> (Void)) {
        do {
            try realm.write {
                realm.delete(object)
                completion(true, nil)
            }
        } catch let error as NSError {
            print("Failed to delete object from Realm: \(error.localizedDescription)")
            completion(false, error)
        }
    }
    
    func fetch<T: Object>(_ type: T.Type) -> Results<T>? {
        return realm.objects(type)
    }

    func update(block: () -> (Void), completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> (Void)) {
        do {
            try realm.write {
                block()
                completion(true, nil)
            }
        } catch let error as NSError {
            print("Failed to update object in Realm: \(error.localizedDescription)")
            completion(false, error)
        }
    }
}
