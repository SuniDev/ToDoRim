//
//  StringExtension.swift
//  HSProject
//
//  Created by hsPark on 2019. 5. 24..
//  Copyright © 2019년 hsPark. All rights reserved.
//

import UIKit

extension String {
    
    // 텍스트 입력 유무
    func isEmpty() -> Bool {
        
        let value = self.trimmingCharacters(in: .whitespaces)
        if value.isEmpty || value == "" {
            return true
        }
        
        return false
    }
    
    // 정규식 함수
    func isStringCheck(regexStr: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: regexStr, options: .anchorsMatchLines)
        if (regex?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count))) != nil {
            return false
        }
        return true
    }
    
    // 공백 제거
    func removeSpace() -> String {
        let result = self.components(separatedBy: [" "]).joined()
        return result
    }
    
    // 공백 유무
    func isSpace() -> Bool {
        if self.range(of: " ") != nil {
            return true
        }
        return false
            
    }
    
}
