//
//  Drawing.swift
//  OESController
//
//  Created by Avnish on 05/09/20.
//

import UIKit

enum Option:Int {
    case brush
    case texts
    case reset
}

class DrawingConstants {
    static let shared = DrawingConstants()
    private init(){}
    var lastPoint = CGPoint(x: 0, y: 0)
    var isPath = false
    var color:UIColor = .black
    var lineWidth:CGFloat = 3.0
}

extension UIImageView {
    
    func drawLineFrom(startPoint:CGPoint, toPoint:CGPoint) {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        image?.draw(in: self.bounds)
        context.move(to: startPoint)
        context.addLine(to: toPoint)
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(DrawingConstants.shared.lineWidth)
        context.setStrokeColor(DrawingConstants.shared.color.cgColor)
        context.strokePath()
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func drawText(string:String = "", atPoint:CGPoint, size:CGSize, textColor:UIColor) {
        UIGraphicsBeginImageContext(self.frame.size)
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return
//        }
        let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Thin", size: 18)!, NSAttributedString.Key.foregroundColor:textColor]
        self.image?.draw(in: self.bounds)
        let str = NSString(string: string)
        str.draw(with: CGRect(origin: atPoint, size: size), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        self.image = newImage
    }
}
