//
//  UIView.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

extension UIView {
    func createUnderline() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.underlineColor.cgColor
        layer.addSublayer(bottomLine)
    }
}
