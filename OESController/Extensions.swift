//
//  Extensions.swift
//  OESController
//
//  Created by Avnish on 05/09/20.
//

import UIKit

@IBDesignable extension UIView {
    @IBInspectable var boarderWidth:CGFloat {
        get {
            self.layer.borderWidth
        }
        
        set {
            self.layoutIfNeeded()
            self.layer.borderWidth = newValue
            self.layer.borderColor = UIColor.black.cgColor
        }
    }
}
