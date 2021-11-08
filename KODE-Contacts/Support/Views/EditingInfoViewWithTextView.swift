//
//  EditingInfoViewWithTextView.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import UIKit

class EditingInfoViewWithTextView: UIView {
    // MARK: - Properties
    let titleLabel = UILabel()
    let descriptionTextView = FlexibleTextView()
    let separatorView = UIView()
    
    var separatorColor: UIColor = .darkGraySeparatorColor {
        didSet {
            separatorView.backgroundColor = separatorColor
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Public Methods
    func additionalSetup() {}
    
    // MARK: - Private Methods
    private func setup() {
        initializeUI()
        createConstraints()
        additionalSetup()
    }
    
    // UI
    private func initializeUI() {
        initalizeTitleLabelUI()
        initalizeDescriptionTextViewUI()
        initializeSeparatorUI()
    }
    
    private func initializeSeparatorUI() {
        separatorView.backgroundColor = separatorColor
    }

    private func initalizeTitleLabelUI() {
        titleLabel.font = .cellTitle
    }
    
    private func initalizeDescriptionTextViewUI() {
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = .cellItem
        descriptionTextView.textColor = .secondaryTextColor
    }
    
    // Constraints
    private func createConstraints() {
        addSubview(titleLabel)
        addSubview(descriptionTextView)
        addSubview(separatorView)
        
        createConstraintsForTitleLabel()
        createConstraintsForItemLabel()
        createConstraintsForSeparator()
    }
    
    private func createConstraintsForTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(Constants.insetLeading)
            make.trailing.equalToSuperview().inset(-Constants.TextView.insetSmall)
        }
    }
    
    private func createConstraintsForItemLabel() {
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-Constants.TextView.insetSmall)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.TextView.insetBig)
        }
    }
    
    private func createConstraintsForSeparator() {
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom)
            make.leading.equalToSuperview().inset(Constants.insetLeading)
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}

// MARK: - Constants
private extension Constants {
    static let insetBottom = CGFloat(10)
    static let insetLeading = CGFloat(20)
    
    struct TextView {
        static let insetSmall = CGFloat(5)
        static let insetDefault = CGFloat(10)
        static let insetBig = CGFloat(15)
    }
    
}
