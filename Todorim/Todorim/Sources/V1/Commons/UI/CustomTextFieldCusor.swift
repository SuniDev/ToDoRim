//
//  CustomTextFieldCusor.swift
//  HSProject
//
//  Created by hsPark on 2019. 5. 29..
//  Copyright © 2019년 hsPark. All rights reserved.
//

import UIKit

class CustomTextFieldCusor: UITextField {

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }

}
