//
//  OldConfig.swift
//  Todorim
//
//  Created by suni on 8/28/24.
//

import Foundation

// MARK: - 반복 알림 타입
enum RepeatConfig: String {
    case none = "반복안함"
    case daily = "매일"
    case weekly = "매주"
    case monthly = "매월"
}

// MARK: - 위치 알림 타입
enum LocationConfig: String {
    case entry = "도착할 때"
    case exit = "출발할 때"
}

// MARK: - 위치 검색 타입
enum LocSearchConfig: String {
    case none
    case current = "현재위치"
    case bookmark = "즐겨찾기"
    case last = "최근검색"
}
