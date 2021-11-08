//
//  TextViewWithSeparatorView.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import UIKit

final class FlexibleTextView: UITextView {
    // MARK: - Properties
    override var font: UIFont? {
        didSet {
            setupMaxHeight()
        }
    }
    
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
        isScrollEnabled = lines > Constants.criticalLinesAmountForEnablingScroll
    }
    
    // MARK: - Private Methods
    private func setupMaxHeight() {
        guard let fontLineHeight = font?.lineHeight else { return }
        let height = fontLineHeight * Constants.linesAmountForMaxHeight
        snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(height)
        }
    }
    
}

// MARK: - Constants
extension Constants {
    static let criticalLinesAmountForEnablingScroll = 3
    static let linesAmountForMaxHeight = CGFloat(5)
}
