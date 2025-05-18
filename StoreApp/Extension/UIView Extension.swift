//
//  UIView Extension.swift
//  StoreApp
//
//  Created by Vijai S on 18/05/25.
//

import Foundation
import UIKit


extension UIView {
    func setCornerRadius(radius: CGFloat = 2, borderWidth: CGFloat = 1, borderColor: UIColor = .gray) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
    }
    func makeRounded() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}

