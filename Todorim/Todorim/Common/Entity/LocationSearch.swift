//
//  Location.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import Foundation

// MARK: - 위치 검색 타입
enum LocationSearchOption: String {
    case none
    case current = "현재위치"
    case bookmark = "즐겨찾기"
    case last = "최근검색"
}
