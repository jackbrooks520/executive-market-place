//
//  UISearchBar+textcolor.swift
//  DriverUtilites
//
//  Created by dreams on 03/11/17.
//  Copyright © 2017 project. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                textField.textColor = newValue
            }
        }
    }
}
