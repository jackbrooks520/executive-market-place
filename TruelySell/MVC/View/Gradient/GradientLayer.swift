//
//  Gradient.swift
//  Laundry
//
//  Created by user on 18/09/19.
//  Copyright © 2019 DreamGuys. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class gradientView: UIView {
 override func layoutSubviews() {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = self.bounds

    gradient.colors = [Gradient().APP_GRADIENT_COLOR_2.cgColor, Gradient().APP_GRADIENT_COLOR_1.cgColor]
        
      
//        gradient.locations = [0.0, 1.0]
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
}





