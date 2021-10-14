//
//  UIView.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit
import SnapKit

extension UIView {
    func createUnderline(color: UIColor = .lightGrayUnderlineColor,
                         height: CGFloat = 1,
                         insetBottom: CGFloat = 1,
                         insetLeading: CGFloat = 0) {
        let bottomLine = UIView()
        self.addSubview(bottomLine)
        bottomLine.backgroundColor = color
        bottomLine.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).inset(insetLeading)
            make.trailing.equalToSuperview()
            make.top.equalTo(self.snp.bottom).inset(-insetBottom)
            make.height.equalTo(height)
        }
    }
    
}
