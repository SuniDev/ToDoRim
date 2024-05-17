//
//  Configs.swift
//  TodorimMVC
//
//  Created by suni on 5/17/24.
//

import Foundation

internal struct Configs {
    // 반복 알림 타입
    internal enum notiRepeat: String {
        case none = "반복 안함"
        case daily = "매 일"
        case weekly = "매 주"
        case monthly = "매 월"
    }
    
    // 위치 알림 타입
    internal enum notiLocation: String {
        case entry = "도착할 때"
        case exit = "출발할 때"
    }
    
    // 위치 검색 타입
    internal enum searchLocation: String {
        case none
        case current = "현재 위치"
        case bookmark = "즐겨 찾기"
        case last = "최근 검색"
    }
}
