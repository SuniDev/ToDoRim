//
//  Async.swift
//  Todorim
//
//  Created by suni on 8/20/24.
//

import Foundation

class Async {
    static func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
