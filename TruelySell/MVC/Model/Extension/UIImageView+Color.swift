//
//  UIImageView+Color.swift
//  VRS
//
//  Created by Guru Prasad chelliah on 5/29/17.
//  Copyright © 2017 project. All rights reserved.
//

import Foundation

import UIKit

extension UIImageView {
    
    func maskWithColorCode(colorCode: String) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        
        tintColor = HELPER.hexStringToUIColor(hex: colorCode)
    }
    
    func maskWithColorName(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        
        tintColor = color
    }
}

