 
import Foundation
import UIKit

@IBDesignable
class gradientViewBlack: UIView {
    
    override func layoutSubviews() {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = self.bounds
        
        gradient.colors = [APP_GRADIENT_BLACK_COLOR_1.cgColor, APP_GRADIENT_BLACK_COLOR_2.cgColor]
        
//        gradient.locations = [0.0,1.0]
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
}
