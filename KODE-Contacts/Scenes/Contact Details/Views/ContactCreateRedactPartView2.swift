//
//  ContactCreateRedactPartView2.swift
//  KODE-Contacts
//
//  Created by Developer on 14.10.2021.
//

import UIKit
import SnapKit

final class ContactCreateRedactPartView2: DefaultCellView {
    // MARK: - Properties
    private let trailingImageView = UIImageView()
    
    // UI
    override func initializeUI() {
        super.initializeUI()
        initalizeArrowImageViewUI()
        // TODO: - Get rid of test code
        descriptionTextField.text = "Default"
        titleLabel.text = "Ringtone"
    }

    private func initalizeArrowImageViewUI() {
        trailingImageView.contentMode = .scaleAspectFit
        trailingImageView.image = .arrowImage
    }
    
    // Constraints
    override func createConstraints() {
        super.createConstraints()
        addSubview(trailingImageView)
        createConstraintsForArrowImageView()
    }
    
    private func createConstraintsForArrowImageView() {
        trailingImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.TrailingImageView.insetTrailing)
            make.centerY.equalToSuperview().offset(Constants.TrailingImageView.centerYOffset)
            make.width.equalTo(trailingImageView.snp.height)
            make.height.equalToSuperview().dividedBy(Constants.TrailingImageView.superViewRatio)
        }
    }
    
}

// MARK: - Constants
private extension Constants {
    struct TrailingImageView {
        static let insetTrailing = CGFloat(20)
        static let centerYOffset = CGFloat(5)
        static let superViewRatio = CGFloat(3.3)
    }
    
}
