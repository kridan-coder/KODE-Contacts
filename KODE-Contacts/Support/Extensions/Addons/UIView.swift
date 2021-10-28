//
//  UIView.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit
import SnapKit

extension UIView {
    @discardableResult func createUnderline(color: UIColor = .lightGrayUnderlineColor,
                                            height: CGFloat = 1,
                                            insetBottom: CGFloat = 1,
                                            insetLeading: CGFloat = 0) -> UIView {
        let underline = UIView()
        self.addSubview(underline)
        underline.backgroundColor = color
        underline.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).inset(insetLeading)
            make.trailing.equalToSuperview()
            make.top.equalTo(self.snp.bottom).inset(-insetBottom)
            make.height.equalTo(height)
        }
        return underline
    }
    
}
