//
//  CommonGroup.swift
//  HSTODO
//
//  Created by 박현선 on 05/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
import RealmSwift

class CommonGroup: NSObject {
    
    static let shared = CommonGroup()
    
    // 191218 hspark. 데이터 구조 변경
    // var
    var arrGroup = Array<DataGroup>()
    
    // let
        let sColors = [0x39393E,0x8ec5fc,0xFCCB90,0xfbc2eb,0xFFF6B7,0xf9d423,0x74ebd5,0x17EAD9,0xABDCFF,0x43CBFF]
        let eColors = [0x39393E,0xe0c3fc,0xD57EEA,0xa18cd1,0xF6416C,0xe14fad,0x9face6,0x8A9BEA,0x0396FF,0x9708CC]
    
    
    // func
    // 그룹 추가
    func add(_ data: DataGroup) {
        arrGroup.append(data)
    }
    
    // 그룹 정보 가져오기 (그룹 index)
    func get(gIndex: Int) -> DataGroup {
        return arrGroup[gIndex]
    }
    
    // 그룹 이름 목록 가져오기
    func getTitleArr() -> Array<String> {
        var str = Array<String>()
        for arr in arrGroup {
            str.append(arr.title)
        }
        return str
    }
    
    
    // 그룹 할일 카운트
    func countTask() {
        for group in arrGroup {
            for task in group.listTask {
                group.allTask = group.allTask + 1
                if task.isCheck {
                    group.checkTask = group.checkTask + 1
                }
            }
        }
    }
    
    
    // 그룹 이름 가져오기
//    func getTitle(gIndex: Int) -> String? {
//        return arrGroup[gIndex].title
//    }
    
    // 그룹 이름 수정
    func setTitle(gIndex: Int, title: String) {
        arrGroup[gIndex].title = title
    }
    
    // 할일 체크
    func setTaskCheck(gIndex: Int, tIndex: Int, isCheck: Bool) {
        arrGroup[gIndex].listTask[tIndex].isCheck = isCheck
        
        if isCheck {
            arrGroup[gIndex].checkTask = arrGroup[gIndex].checkTask + 1
        } else {
            arrGroup[gIndex].checkTask = arrGroup[gIndex].checkTask - 1
        }
    }

    // 완료된 할일 가져오기
    func getCheckTask(gIndex: Int) -> Int {
        return arrGroup[gIndex].checkTask
    }

    // 모든 할일 가져오기
    func getAllTask(gIndex: Int) -> Int {
        return arrGroup[gIndex].allTask
    }
    
    // 완료안된 할일 목록 가져오기
    func getArrCheck(gIndex: Int) -> [DataTaskv2] {
        var arrCheck = [DataTaskv2]()
        for task in arrGroup[gIndex].listTask {
            if !task.isCheck {
                arrCheck.append(task)
            }
        }
        return arrCheck
    }
    
    // 할일 가져오기
    func getTask(gIndex: Int, tIndex: Int) -> DataTaskv2 {
        return arrGroup[gIndex].listTask[tIndex]
    }
    
    
    // 색상 가져오기
    func getStartColor(gIndex: Int) -> Int {
       return sColors[arrGroup[gIndex].colorIndex]
    }
    
    func getEndColor(gIndex: Int) -> Int {
        return eColors[arrGroup[gIndex].colorIndex]
    }
    
    func getColorIndex(gIndex: Int) -> Int {
        return arrGroup[gIndex].colorIndex
    }
    
    func setColorIndex(gIndex: Int, colorIndex: Int) {
        arrGroup[gIndex].colorIndex = colorIndex
    }
    
    // 색상 카운트
    func colorCount() -> Int {
        return sColors.count
    }
    
    // 그룹 카운트
    func count() -> Int {
        return arrGroup.count
    }

    // 할일 추가
    func addTask(gIndex: Int, data: DataTaskv2) {
        print("data: \(data)")
        print("arrGroup[gIndex].listTask: \(arrGroup[gIndex].listTask)")
        print("allTask: \(arrGroup[gIndex].allTask)")
        arrGroup[gIndex].listTask.append(data)
        
        arrGroup[gIndex].allTask = arrGroup[gIndex].allTask + 1
        if data.isCheck {
            arrGroup[gIndex].checkTask = arrGroup[gIndex].checkTask + 1
        }
    }

    // 그룹 지우기
    func remove(gIndex: Int) {
        arrGroup.remove(at: gIndex)
        updateGOrder()
    }

    // 할일 지우기
    func removeTask(gIndex: Int, tIndex: Int) {
        let task = getTask(gIndex: gIndex, tIndex: tIndex)
        arrGroup[gIndex].allTask = arrGroup[gIndex].allTask - 1
        if task.isCheck {
            arrGroup[gIndex].checkTask = arrGroup[gIndex].checkTask - 1
        }
//        arrGroup[gIndex].listTask.remove(at: tIndex)
    }

    // 할일 수정
    func modify(gIndex: Int, tIndex: Int, data: DataTaskv2) {
        arrGroup[gIndex].listTask[tIndex] = data
    }
    
    // 그룹 순서 수정
    func updateGOrder() {
        for (i,g) in arrGroup.enumerated() {
            g.gOrder = i
        }
    }
    
    // 그룹 순서 결정
    func getMaxGOrder() -> Int {
        return arrGroup.count
    }
    
    // 할일 순서 결정
//    func getMaxTOrder(gIndex: Int) -> Int {
//        return arrGroup[gIndex].allTask
//    }
    
    // 그룹 No 결정
    func getMaxGroupNo() -> Int {
        var max = arrGroup[0].groupNo
        for group in arrGroup {
            if group.groupNo > max {
                max = group.groupNo
            }
        }
        return max + 1
    }
    
    // 할일 No 결정
//    func getMaxTaskNo(gIndex: Int) -> Int {
//        var max = -1
//        for task in arrGroup[gIndex].listTask {
//            if task.taskNo > max {
//                max = task.taskNo
//            }
//        }
//        return max + 1
//    }
    // var
//    var arrGroup = List<DataGroup>()
//    
//    // let
//    let sColors = [0x39393E,0x8ec5fc,0xFCCB90,0xfbc2eb,0xFFF6B7,0xf9d423,0x74ebd5,0x17EAD9,0xABDCFF,0x43CBFF]
//    let eColors = [0x39393E,0xe0c3fc,0xD57EEA,0xa18cd1,0xF6416C,0xe14fad,0x9face6,0x8A9BEA,0x0396FF,0x9708CC]
//    
//    func add(_ data: DataGroup) {
//        arrGroup.append(data)
//    }
//    
//    func get(groupNo: Int) -> DataGroup {
//        
//        var data = DataGroup()
//        for group in arrGroup {
//            if group.groupNo == groupNo {
//                data = group
//            }
//        }
//        return data
//    }
//    
//    func get(index: Int) -> DataGroup {
//        return arrGroup[index]
//    }
//    
//    func getIndex(groupNo: Int) -> Int {
//        for (i,group) in arrGroup.enumerated() {
//            if group.groupNo == groupNo {
//                return i
//            }
//        }
//        
//        return 0
//    }
//    
//    
//    func getNo(index: Int) -> Int {
//       return arrGroup[index].groupNo
//    }
//    
    func getTaskIndex(gIndex: Int, taskNo: Int) -> Int {
        for (i,task) in arrGroup[gIndex].listTask.enumerated() {
            if task.taskNo == taskNo {
                return i
            }
        }
        return 0
    }
//    
//    func getTitleArr() -> Array<String> {
//        var str = Array<String>()
//        for arr in arrGroup {
//            str.append(arr.title)
//        }
//        return str
//    }
//    
    func getNoArr() -> Array<Int> {
        var no = Array<Int>()
        for arr in arrGroup {
            no.append(arr.groupNo)
        }
        return no
    }
//    
//    func getTitle(groupNo: Int) -> String? {
//        return get(groupNo: groupNo).title
//    }
//    
//    func getTitle(index: Int) -> String? {
//        return arrGroup[index].title
//    }
//    
//    func setTitle(groupNo: Int, title: String) {
//        let index = getIndex(groupNo: groupNo)
//        arrGroup[index].title = title
//    }
//    
//    
//    func setTaskCheck(groupNo: Int, taskNo: Int, isCheck: Bool) {
//        let gIndex = getIndex(groupNo: groupNo)
//        let index = getTaskIndex(gIndex: gIndex, taskNo: taskNo)
//        arrGroup[gIndex].arrTask[index].isCheck = isCheck
//        if isCheck {
//            arrGroup[gIndex].checkTask = arrGroup[gIndex].checkTask + 1
//        } else {
//            arrGroup[gIndex].checkTask = arrGroup[gIndex].checkTask - 1
//        }
//    }
//    
//    func getCheckTask(groupNo: Int) -> Int {
//
//        return get(groupNo:groupNo).checkTask
//    }
//    
//    func getCheckTask(index: Int) -> Int {
//        return arrGroup[index].checkTask
//    }
//    
//    func getAllTask(groupNo: Int) -> Int {
//        return get(groupNo:groupNo).allTask
//    }
//    
//    func getAllTask(index: Int) -> Int {
//        return arrGroup[index].allTask
//    }
//    
//    func getArrCheck(index: Int) -> [DataTask] {
//        var arrCheck = [DataTask]()
//        for task in arrGroup[index].arrTask {
//            if !task.isCheck {
//                arrCheck.append(task)
//            }
//        }
//        return arrCheck
//    }
//    
//    
//    
//    func getTaskArr(groupNo: Int) -> Array<DataTask> {
//        
//        return get(groupNo:groupNo).arrTask
//    }
//    
//    func getTaskArr(index: Int) -> Array<DataTask> {
//        
//        return arrGroup[index].arrTask
//    }
//    
//    
//    func getTask(groupNo: Int, tIndex: Int) -> DataTask {
//        return get(groupNo:groupNo).arrTask[tIndex]
//    }
//    
//    func getTask(gIndex: Int, tIndex: Int) -> DataTask {
//        return arrGroup[gIndex].arrTask[tIndex]
//    }
//    
//    func getStartColor(groupNo: Int) -> Int {
//        let index = getIndex(groupNo: groupNo)
//        return sColors[arrGroup[index].colorIndex]
//    }
//    
//    
//    func getStartColor(index: Int) -> Int {
//       return sColors[arrGroup[index].colorIndex]
//    }
//    
//    func getEndColor(groupNo: Int) -> Int {
//        let index = getIndex(groupNo: groupNo)
//        return eColors[arrGroup[index].colorIndex]
//    }
//    
//    func getEndColor(index: Int) -> Int {
//        return eColors[arrGroup[index].colorIndex]
//    }
//    
//    func getColorIndex(groupNo: Int) -> Int {
//        return get(groupNo:groupNo).colorIndex
//    }
//    
//    func getColorIndex(index: Int) -> Int {
//        return arrGroup[index].colorIndex
//    }
//    
//    
//    func setColorIndex(groupNo: Int, colorIndex: Int) {
//        let index = getIndex(groupNo:groupNo)
//        arrGroup[index].colorIndex = colorIndex
//    }
//    
//    func count() -> Int {
//        return arrGroup.count
//    }
//    
//    func addTask(groupNo: Int, data: DataTask) {
//        let index = getIndex(groupNo: groupNo)
//            arrGroup[index].arrTask.append(data)
//            arrGroup[index].allTask = arrGroup[index].allTask + 1
//        if data.isCheck {
//            arrGroup[index].checkTask = arrGroup[index].checkTask + 1
//        }
//    }
//    
//    func colorCount() -> Int {
//        return sColors.count
//    }
//    
//    func remove(groupNo: Int) {
//        let index = getIndex(groupNo: groupNo)
//        arrGroup.remove(at: index)
//    }
//    
//    func remove(index: Int) {
//        arrGroup.remove(at: index)
//    }
//    
//    func removeTask(groupNo: Int, taskNo: Int) {
//        let gIndex = getIndex(groupNo: groupNo)
//        let tIndex = getTaskIndex(gIndex: gIndex, taskNo: taskNo)
//        let task = getTask(gIndex: gIndex, tIndex: tIndex)
//        arrGroup[gIndex].allTask = arrGroup[gIndex].allTask - 1
//        if task.isCheck {
//            arrGroup[gIndex].checkTask = arrGroup[gIndex].checkTask - 1
//        }
//        arrGroup[gIndex].arrTask.remove(at: tIndex)
//    }
//    
    func modifyTask(gIndex: Int, tIndex: Int, data: DataTaskv2) {
        arrGroup[gIndex].listTask[tIndex] = data
    }
}
