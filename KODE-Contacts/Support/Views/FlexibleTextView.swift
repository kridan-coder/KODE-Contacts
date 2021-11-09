//
//  TextViewWithSeparatorView.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import UIKit

protocol FlexibleTextViewDelegate: AnyObject {
    func flexibleTextView(_ flexibleTextView: FlexibleTextView, setScrollEnabled: Bool)
}

final class FlexibleTextView: UITextView {
    // MARK: - Properties
    weak var flexibleDelegate: FlexibleTextViewDelegate?
    
    override var font: UIFont? {
        didSet {
            setupMaxHeight()
        }
    }
    
    override var isScrollEnabled: Bool {
        didSet {
            flexibleDelegate?.flexibleTextView(self, setScrollEnabled: isScrollEnabled)
        }
    }
    
    var placeholder: String? {
        didSet {
            text = placeholder
        }
    }
    
    private var numberOfLines: Int? {
        guard let fontLineHeight = font?.lineHeight,
              fontLineHeight != 0 else { return nil }
        return Int(contentSize.height / fontLineHeight)
    }
    
    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
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
    
    // MARK: - Actions
    @objc private func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentInset = .zero
        } else if isScrollEnabled {
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            scrollIndicatorInsets = contentInset
        }
    }
    
    // MARK: - Private Methods
    private func setup() {
        let notificationCenter = NotificationCenter.default
        //notificationCenter.addObserver(self,
                                      // selector: #selector(adjustForKeyboard),
                                       //name: UIResponder.keyboardWillHideNotification,
                                       //object: nil)
        //notificationCenter.addObserver(self,
                                       //selector: #selector(adjustForKeyboard),
                                      // name: UIResponder.keyboardWillChangeFrameNotification,
                                       //object: nil)
    }
    
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
