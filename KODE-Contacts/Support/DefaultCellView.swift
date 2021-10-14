//
//  DefaultCellView.swift
//  KODE-Contacts
//
//  Created by Developer on 14.10.2021.
//

import UIKit

class DefaultCellView: UIView {
    // MARK: - Properties
    internal let titleLabel = UILabel()
    internal let descriptionTextField: UITextField = .emptyTextField
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    // UI
    internal func initializeUI() {
        createUnderline(color: .darkGrayUnderlineColor, insetBottom: Constants.insetBottom, insetLeading: Constants.insetLeading)
        initalizeTitleLabelUI()
        initalizeDescriptionTextViewUI()
    }
    
    internal func initalizeTitleLabelUI() {
        titleLabel.font = .cellTitle
    }
    
    internal func initalizeDescriptionTextViewUI() {
        descriptionTextField.font = .cellItem
        descriptionTextField.textColor = .secondaryTextColor
        descriptionTextField.isUserInteractionEnabled = false
    }
    
    // Constraints
    internal func createConstraints() {
        addSubview(titleLabel)
        addSubview(descriptionTextField)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.height)
        }
        
        createConstraintsForTitleLabel()
        createConstraintsForItemLabel()
    }
    
    internal func createConstraintsForTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.insetLeading)
            make.trailing.equalToSuperview().inset(-Constants.TextField.insetSmall)
            make.top.equalToSuperview()
        }
    }
    
    internal func createConstraintsForItemLabel() {
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
