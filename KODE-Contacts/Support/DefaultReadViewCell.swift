//
//  DefaultReadViewCell.swift
//  KODE-Contacts
//
//  Created by Developer on 26.10.2021.
//

import UIKit

class DefaultReadViewCell: UIView {
    // MARK: - Properties
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
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
        initalizeDescriptionLabel()
    }
    
    private func initalizeTitleLabelUI() {
        titleLabel.font = .cellTitle
    }
    
    private func initalizeDescriptionLabel() {
        descriptionLabel.font = .cellItem
        descriptionLabel.numberOfLines = 0
    }
    
    // Constraints
    private func createConstraints() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        createConstraintsForTitleLabel()
        createConstraintsForDescriptionLabel()
    }
    
    private func createConstraintsForTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.insetLeading)
            make.trailing.equalToSuperview().inset(-Constants.DescriptionLabel.insetSmall)
            make.top.equalToSuperview()
        }
    }
    
    private func createConstraintsForDescriptionLabel() {
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.DescriptionLabel.insetBig)
            make.trailing.equalToSuperview().inset(-Constants.DescriptionLabel.insetSmall)
            make.top.equalTo(titleLabel.snp.bottom).inset(-Constants.DescriptionLabel.insetSmall)
            make.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - Constants
private extension Constants {
    static let insetBottom = CGFloat(10)
    static let insetLeading = CGFloat(20)
    
    struct DescriptionLabel {
        static let insetSmall = CGFloat(5)
        static let insetDefault = CGFloat(10)
        static let insetBig = CGFloat(20)
    }
    
}
