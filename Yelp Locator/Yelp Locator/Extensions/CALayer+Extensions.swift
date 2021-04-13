//
//  CALayer+Extensions.swift
//  Yelp Locator
//
//  Created by Steven Layug on 9/04/21.
//

import Foundation
import UIKit

extension CALayer {
    func addWaghaBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: 1, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - 1, y: 0, width: 1, height: self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}
