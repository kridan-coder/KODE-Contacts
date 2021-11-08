//
//  TextViewWithSeparatorView.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import UIKit

final class FlexibleTextView: UITextView {
    // MARK: - Properties
    private var numberOfLines: Int? {
        guard let fontLineHeight = font?.lineHeight,
              fontLineHeight != 0 else { return nil }
        return Int(contentSize.height / fontLineHeight)
    }
    
    var placeholder: String? {
        didSet {
            text = placeholder
        }
    }
    
    // MARK: - Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        setupScrollAppearance()
    }
    
    // MARK: - Public Methods
    func setupScrollAppearance() {
        guard let lines = numberOfLines else { return }
        isScrollEnabled = lines > 4
    }
    
}
