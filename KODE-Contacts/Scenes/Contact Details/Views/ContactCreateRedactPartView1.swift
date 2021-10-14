//
//  ContactCreateRedactPartView1.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit
import SnapKit

class ContactCreateRedactPartView1: UIView {
    // MARK: - Properties
    private let contactImageView = UIImageView()
    
    private let nameTextField: UITextField = .emptyTextField
    private let lastNameTextField: UITextField = .emptyTextField
    private let phoneNumberTextField: UITextField = .emptyTextField
    
    // MARK: - Init
    init() {
        
        super.init(frame: CGRect.zero)
        
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    // UI
    private func initializeUI() {
        initializeNameTextFieldUI()
        initializeLastNameTextFieldUI()
        initializePhoneNumberTextFieldUI()
        initializeContactImageViewUI()
    }
    
    private func initializeContactImageViewUI() {
        contactImageView.image = .placeholderImage
    }
    
    private func initializeNameTextFieldUI() {
        nameTextField.placeholder = R.string.localizable.firstName()
        nameTextField.createUnderline()
    }
    
    private func initializeLastNameTextFieldUI() {
        lastNameTextField.placeholder = R.string.localizable.lastName()
        lastNameTextField.createUnderline()
    }
    
    private func initializePhoneNumberTextFieldUI() {
        phoneNumberTextField.placeholder = R.string.localizable.phone()
        phoneNumberTextField.createUnderline()
    }
    
    // Constraints
    private func createConstraints() {
        addSubview(contactImageView)
        addSubview(nameTextField)
        addSubview(lastNameTextField)
        addSubview(phoneNumberTextField)
        
        createConstraintsForContactImageView()
        createConstraintsForNameTextField()
        createConstraintsForLastNameTextField()
        createConstraintsForPhoneNumberTextField()
    }
    
    private func createConstraintsForContactImageView() {
        contactImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(Constants.ContactImageView.inset)
            make.width.equalTo(contactImageView.snp.height)
            make.width.equalToSuperview().dividedBy(Constants.ContactImageView.superViewRatio)
        }
    }
    
    private func createConstraintsForNameTextField() {
        nameTextField.snp.makeConstraints { make in
            make.leading.equalTo(contactImageView.snp.trailing).inset(-Constants.TextField.insetDefault)
            make.trailing.equalToSuperview().inset(Constants.TextField.insetDefault)
            make.top.equalTo(contactImageView).inset(-Constants.TextField.insetSmall)
            make.height.equalTo(contactImageView).dividedBy(Constants.TextField.contactImageViewRatio)
        }
    }
    
    private func createConstraintsForLastNameTextField() {
        lastNameTextField.snp.makeConstraints { make in
            make.leading.equalTo(contactImageView.snp.trailing).inset(-Constants.TextField.insetDefault)
            make.trailing.equalToSuperview().inset(Constants.TextField.insetDefault)
            make.top.equalTo(nameTextField.snp.bottom).inset(-Constants.TextField.insetSmall)
            make.height.equalTo(contactImageView).dividedBy(Constants.TextField.contactImageViewRatio)
        }
    }
    
    private func createConstraintsForPhoneNumberTextField() {
        phoneNumberTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.TextField.insetDefault)
            make.top.equalTo(lastNameTextField.snp.bottom).inset(-Constants.TextField.insetDefault)
            make.height.equalTo(contactImageView).dividedBy(Constants.TextField.contactImageViewRatio)
            make.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - Constants
private extension Constants {
    struct ContactImageView {
        static let inset = CGFloat(20)
        static let size = CGFloat(75)
        static let superViewRatio = CGFloat(4.36)
    }
    
    struct TextField {
        static let insetSmall = CGFloat(10)
        static let insetDefault = CGFloat(20)
        static let contactImageViewRatio = CGFloat(2)
    }
    
}
