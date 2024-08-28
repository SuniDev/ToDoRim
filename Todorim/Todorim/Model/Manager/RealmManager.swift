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
        realm = RealmManager.initializeRealm()
    }
    
    static let shared = RealmManager()
    
    // MARK: - Start - Old Version: 삭제 예정
    private static func initializeRealm() -> Realm {
        do {
            let config = Realm.Configuration(
                schemaVersion: 3,
                migrationBlock: { migration, oldSchemaVersion in
                    self.performMigration(migration: migration, oldSchemaVersion: oldSchemaVersion)
                }
            )
            return try Realm(configuration: config)
        } catch let error as NSError {
            fatalError("Failed to open Realm database: \(error.localizedDescription)")
        }
    }
    
    private static func performMigration(migration: Migration, oldSchemaVersion: UInt64) {
        if oldSchemaVersion < 3 {
            // 2. DataGroup -> Group으로 변환 및 listTask 내 DataTaskv2 -> Todo로 변환
            migration.enumerateObjects(ofType: DataGroup.className()) { oldObject, _ in
                guard let oldObject = oldObject else {
                    return
                }
                // 새로운 Group 객체 생성
                let newGroup = migration.create(Group.className())
                
                self.mapDataGroupToGroup(oldObject: oldObject, newObject: newGroup)
                
                // DataGroup 내 listTask를 Todo 목록으로 변환
                if let listTask = oldObject["listTask"] as? List<MigrationObject> {
                    for task in listTask {
                        let todo = migration.create(Todo.className())
                        self.mapDataTaskv2ToTodo(oldObject: task, newObject: todo)
                        
                        // groupId는 DataGroup의 groupNo를 사용합니다
                        todo["groupId"] = oldObject["groupNo"] as? Int
                    }
                }
            }
        }
    }
    
    private static func mapDataTaskv2ToTodo(oldObject: MigrationObject, newObject: MigrationObject) {
        if let taskNo = oldObject["taskNo"] as? Int { newObject["todoId"] = taskNo }
        if let title = oldObject["title"] as? String { newObject["title"] = title }
        if let isCheck = oldObject["isCheck"] as? Bool { newObject["isComplete"] = isCheck }
        if let tOrder = oldObject["tOrder"] as? Int { newObject["order"] = tOrder }
        if let isDateNoti = oldObject["isDateNoti"] as? Bool { newObject["isDateNoti"] = isDateNoti }
        newObject["date"] = oldObject["date"] as? Date
        
        if let week = oldObject["week"] as? Int { newObject["week"] = week }
        if let day = oldObject["day"] as? Int { newObject["day"] = day }
        if let repeatType = oldObject["pRepeatType"] as? String { newObject["repeatType"] = repeatType }
        if let isLocNoti = oldObject["isLocNoti"] as? Bool { newObject["isLocationNoti"] = isLocNoti }
        if let locTitle = oldObject["locTitle"] as? String { newObject["locationName"] = locTitle }
        if let locType = oldObject["plocType"] as? String { newObject["locationType"] = locType }
        if let longitude = oldObject["longitude"] as? Double { newObject["longitude"] = longitude }
        if let latitude = oldObject["latitude"] as? Double { newObject["latitude"] = latitude }
        if let radius = oldObject["radius"] as? Double { newObject["radius"] = radius }
    }
    
    private static func mapDataGroupToGroup(oldObject: MigrationObject, newObject: MigrationObject) {
        if let groupNo = oldObject["groupNo"] as? Int { newObject["groupId"] = groupNo }
        if let gOrder = oldObject["gOrder"] as? Int { newObject["order"] = gOrder }
        if let title = oldObject["title"] as? String { newObject["title"] = title }
        
        if let colorIndex = oldObject["colorIndex"] as? Int {
            newObject["appColorIndex"] = colorIndex
            newObject["startColorHax"] = GroupColor.getStart(index: colorIndex).toHexString()
            newObject["endColorHax"] = GroupColor.getEnd(index: colorIndex).toHexString()
        }
    }
    // MARK: - End - Old Version: 삭제 예정
    
    func add<T: Object>(_ object: T, update: Realm.UpdatePolicy = .error) {
        do {
            try realm.write {
                realm.add(object, update: update)
            }
        } catch let error as NSError {
            print("Failed to add object to Realm: \(error.localizedDescription)")
        }
    }
    
    func delete<T: Object>(object: T, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
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
    
    func delete<T: Object>(object: Results<T>, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
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
    
    func update(block: () -> Void, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
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
