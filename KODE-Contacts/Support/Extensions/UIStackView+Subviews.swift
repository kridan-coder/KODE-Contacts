//
//  UIStackView.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        for subview in self.subviews {
            self.removeArrangedSubview(subview)
        }
    }
    
}
