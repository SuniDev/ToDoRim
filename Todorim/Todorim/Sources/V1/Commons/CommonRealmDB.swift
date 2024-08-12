//
//  CommonSQLite.swift
//  HSTODO
//
//  Created by 박현선 on 05/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
import RealmSwift

class CommonRealmDB: NSObject {
    
    static let shared = CommonRealmDB()
    
    var realm: Realm!
    var isUpdate: Bool = false
    
    // 200105 hspark. v1.0.1 데이터 구조 변경: 그룹 마이그레이션
    func updateRealm(completion: @escaping (Bool)->()) {
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                print("oldSchemaVersion :\(oldSchemaVersion)")
                if (oldSchemaVersion < 1) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Person object stored in the Realm file
                    
                    migration.enumerateObjects(ofType: DataGroup.className()) { oldObject, newObject in
                        // combine name fields into a single field
                        print("oldObject :\(oldObject)")
                        print("newObject :\(newObject)")
                        
                        newObject!["gOrder"] = oldObject!["groupNo"]
                    }
                    self.isUpdate = true
                }
                print("newSchemaVersion :\(Realm.Configuration.defaultConfiguration.schemaVersion)")
        })
        
        self.realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        completion(true)
        
    }
    
    // 200105 hspark. v1.0.1 데이터 구조 변경
    func updateVersion(completion: @escaping (Bool)->()) {
        if isUpdate {
            let task = realm.objects(DataTask.self).sorted(byKeyPath: "taskNo")
            let group = realm.objects(DataGroup.self).sorted(byKeyPath: "groupNo")
            
            print("group \(group)")
            print("task \(task)")
            
            for t in task {
                for g in group {
                    if g.groupNo == t.groupNo {
                        let data = DataTaskv2()
                        data.taskNo = t.taskNo
                        data.title = t.title
                        data.isCheck = t.isCheck
                        data.isDateNoti = t.isDateNoti
                        data.date = t.date
                        data.week = t.week
                        data.day = t.day
                        data.tOrder = t.taskNo   // hspark. DataTaskv2 추가
                        data.repeatType = t.repeatType
                        data.isLocNoti = t.isLocNoti
                        data.locTitle = t.locTitle
                        data.locType = t.locType
                        data.longitude = t.longitude
                        data.latitude = t.latitude
                        data.radius = t.radius
                        try! self.realm.write {
                            g.allTask = g.allTask + 1
                            if t.isCheck {
                                g.checkTask = g.checkTask + 1
                            }
                            g.listTask.append(data)
                        }
                    }
                }
            }

            // 수정
            try! realm.write {
              realm.delete(task)
            }
            
        }
        completion(true)
        
    }
    
    // 그룹 순서 지정
    //    func getGroupOrder() -> Int {
    //        return (realm.objects(DataGroup.self).max(ofProperty: "gOrder") as Int? ?? 0) + 1
    //    }
    
    // 할일 기본키 지정
    func getTaskNo() -> Int {
        return (realm.objects(DataTaskv2.self).max(ofProperty: "taskNo") as Int? ?? 0) + 1
    }
    
    func getTaskOrder() -> Int {
        return (realm.objects(DataTaskv2.self).max(ofProperty: "tOrder") as Int? ?? 0) + 1
    }
    
    
    // RealmDB 세팅
    func setupRealm() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1)
        realm = try! Realm()
        print("SchemaVersion :\(Realm.Configuration.defaultConfiguration.schemaVersion)")
        print(Realm.Configuration.defaultConfiguration.fileURL!)

    }
    
    // 자동 id
    func getGroupNo() -> Int {
        return (realm.objects(DataGroup.self).max(ofProperty: "groupNo") as Int? ?? 0) + 1
    }
    
    func writeGroup(data: DataGroup, completion: @escaping (Bool)->()) {
        try! realm.write {
            realm.add(data)
            CommonGroup.shared.add(data)
        }
        completion(true)
    }
    
    func writeTask(gIndex: Int, data: DataTaskv2, completion: @escaping (Bool)->()) {
        
        let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
        
        if let group = self.realm.objects(DataGroup.self).filter("groupNo == \(groupNo)").first {
            
            try! self.realm.write {
                group.listTask.append(data)
                //                group.allTask = group.allTask + 1
            }
            
            CommonNoti.shared.addDateNoti(data: data, gIndex: gIndex)
            CommonNoti.shared.addLocNoti(data: data, gIndex: gIndex)
            CommonGroup.shared.arrGroup[gIndex].allTask += 1
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func updateGroup(data: DataGroup, completion: @escaping (Bool)->()) {
        
        if let group = realm.objects(DataGroup.self).filter("groupNo == \(data.groupNo)").first {
            try! realm.write {
                
                group.title = data.title
                group.colorIndex = data.colorIndex
                CommonGroup.shared.setTitle(gIndex: data.gOrder, title: data.title)
                CommonGroup.shared.setColorIndex(gIndex: data.groupNo, colorIndex: data.colorIndex)
            }
            completion(true)
        } else {
            completion(false)
        }
        
    }
    
    
    func updateTaskCheck(gIndex: Int, tIndex: Int, completion: @escaping (Bool)->()) {
        let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
        let taskNo = CommonGroup.shared.arrGroup[gIndex].listTask[tIndex].taskNo
        let data = CommonGroup.shared.getTask(gIndex: gIndex, tIndex: tIndex)
        let isCheck = !data.isCheck
        
        if let group = self.realm.objects(DataGroup.self).filter("groupNo == \(groupNo)").first {
            try! self.realm.write {
                
                
                if isCheck {
                    CommonNoti.shared.removeNoti(taskNo: taskNo, gIndex: gIndex)
                } else {
                    CommonNoti.shared.addDateNoti(data: data, gIndex: gIndex)
                    CommonNoti.shared.addLocNoti(data: data, gIndex: gIndex)
                }
                
                CommonGroup.shared.setTaskCheck(gIndex: gIndex, tIndex: tIndex, isCheck: isCheck)
                
                group.listTask[tIndex].isCheck = isCheck
            }
            completion(true)
        } else {
            completion(false)
        }
        
    }
    //
    func updateTask(gIndex: Int, tIndex: Int, data: DataTaskv2, completion: @escaping (Bool)->()) {
        let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
        if let group = self.realm.objects(DataGroup.self).filter("groupNo == \(groupNo)").first {
            try! self.realm.write {
                CommonNoti.shared.updateNoti(data: data, gIndex: gIndex)
                group.listTask[tIndex].title = data.title
                group.listTask[tIndex].isDateNoti = data.isDateNoti
                group.listTask[tIndex].date = data.date
                group.listTask[tIndex].week = data.week
                group.listTask[tIndex].day = data.day
                group.listTask[tIndex].repeatType = data.repeatType
                group.listTask[tIndex].isLocNoti = data.isLocNoti
                group.listTask[tIndex].locTitle = data.locTitle
                group.listTask[tIndex].locType = data.locType
                group.listTask[tIndex].latitude = data.latitude
                group.listTask[tIndex].longitude = data.longitude
                group.listTask[tIndex].radius = data.radius
            }
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func deleteGroup(gIndex: Int, completion: @escaping (Bool)->()) {
        let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
        
        if let group = realm.objects(DataGroup.self).filter("groupNo == \(groupNo)").first {
            try! realm.write {
                
                CommonGroup.shared.remove(gIndex: gIndex)
                //                group.isDeleted = true
                realm.delete(group)
                
                let arrGroup = CommonGroup.shared.arrGroup
                for i in gIndex ..< arrGroup.count {
                    realm.add(arrGroup[i], update: .modified)
                }
                
            }
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func deleteTask(gIndex: Int, tIndex: Int, completion: @escaping (Bool)->()) {
        let groupNo = CommonGroup.shared.arrGroup[gIndex].groupNo
        let taskNo = CommonGroup.shared.arrGroup[gIndex].listTask[tIndex].taskNo
        if let group = self.realm.objects(DataGroup.self).filter("groupNo == \(groupNo)").first {
            try! self.realm.write {
                CommonNoti.shared.removeNoti(taskNo: taskNo, gIndex: groupNo)
                CommonGroup.shared.removeTask(gIndex: gIndex, tIndex: tIndex)
                
                group.allTask = CommonGroup.shared.getAllTask(gIndex: gIndex)
                group.checkTask = CommonGroup.shared.getCheckTask(gIndex: gIndex)
                group.listTask.remove(at: tIndex)
                
                let arrTask = CommonGroup.shared.arrGroup[gIndex].listTask
                for i in tIndex ..< arrTask.count {
                    group.listTask[i].tOrder = i
                }
            }
            completion(true)
        } else {
            completion(false)
        }
    }
    
    //    // 그룹 데이터 받기
    func fetchGroup(completion: @escaping (Bool)->()) {
        
        let group = realm.objects(DataGroup.self).sorted(byKeyPath: "gOrder")
        
        for g in group {
            CommonGroup.shared.add(g)
        }
        CommonGroup.shared.countTask()
        
        completion(true)
    }
}
