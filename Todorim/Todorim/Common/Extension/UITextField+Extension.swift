//
//  TextFieldExtension.swift
//  HSProject
//
//  Created by hsPark on 2019. 5. 24..
//  Copyright © 2019년 hsPark. All rights reserved.
//

import UIKit

extension UITextField {
    func setMaxLength(max: Int) {
        if let str = self.text {
            let length = str.count
            if length > max {
                self.text = String(str.prefix(max))
            }
        }
    }
}
