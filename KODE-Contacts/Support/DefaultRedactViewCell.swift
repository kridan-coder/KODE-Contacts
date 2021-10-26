//
//  DefaultRedactViewCell.swift
//  KODE-Contacts
//
//  Created by Developer on 14.10.2021.
//

import UIKit

class DefaultRedactViewCell: UIView {
    // MARK: - Properties
    let titleLabel = UILabel()
    let descriptionTextField: UITextField = .emptyTextField
    var underline: UIView?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
        createConstraints()
        additionalSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeUI()
        createConstraints()
        additionalSetup()
    }
    
    // MARK: - Public Methods
    func additionalSetup() {}
    
    // MARK: - Private Methods
    // UI
    private func initializeUI() {
        underline = createUnderline(color: .darkGrayUnderlineColor,
                                    insetBottom: Constants.insetBottom,
                                    insetLeading: Constants.insetLeading)
        initalizeTitleLabelUI()
        initalizeDescriptionTextViewUI()
    }
    
    private func initalizeTitleLabelUI() {
        titleLabel.font = .cellTitle
    }
    
    private func initalizeDescriptionTextViewUI() {
        descriptionTextField.font = .cellItem
        descriptionTextField.textColor = .secondaryTextColor
    }
    
    // Constraints
    private func createConstraints() {
        addSubview(titleLabel)
        addSubview(descriptionTextField)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.height)
        }
        
        createConstraintsForTitleLabel()
        createConstraintsForItemLabel()
    }
    
    private func createConstraintsForTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.insetLeading)
            make.trailing.equalToSuperview().inset(-Constants.TextField.insetSmall)
            make.top.equalToSuperview()
        }
    }
    
    private func createConstraintsForItemLabel() {
        descriptionTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.TextField.insetBig)
            make.trailing.equalToSuperview().inset(-Constants.TextField.insetSmall)
            make.top.equalTo(titleLabel.snp.bottom).inset(-Constants.TextField.insetSmall)
            make.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - Constants
private extension Constants {
    static let height = CGFloat(50)
    static let insetBottom = CGFloat(10)
    static let insetLeading = CGFloat(20)
    
    struct TextField {
        static let insetSmall = CGFloat(5)
        static let insetDefault = CGFloat(10)
        static let insetBig = CGFloat(20)
    }
    
}