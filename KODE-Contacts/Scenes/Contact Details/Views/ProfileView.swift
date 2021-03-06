//
//  ProfileView.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit
import PhoneNumberKit

class ProfileView: UIView {
    // MARK: - Properties
    private var viewModel: ContactProfileViewModel?
    
    private let contactImageView = UIImageView()
    
    let nameTextField = TextFieldWithSeparatorView()
    let lastNameTextField = TextFieldWithSeparatorView()
    let phoneNumberTextField = PhoneNumberTextFieldWithSeparatorView(frame: CGRect.zero)
    
    private let toolbar = CustomToolbar(frame: CGRect.zero)
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        setupDynamicUI()
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: ContactProfileViewModel) {
        self.viewModel = viewModel
        self.viewModel?.didSetupImage = { [weak self] image in
            self?.contactImageView.image = image
        }
        setupData()
    }
    
    // MARK: - Actions
    @objc private func imageTapped() {
        viewModel?.showImagePicker()
    }
    
    // MARK: - Private Methods
    private func setupDynamicUI() {
        layoutIfNeeded()
        contactImageView.layer.cornerRadius = contactImageView.bounds.width / 2
    }
    
    private func setupData() {
        nameTextField.placeholder = viewModel?.data.firstTextFieldPlaceholder
        lastNameTextField.placeholder = viewModel?.data.secondTextFieldPlaceholder
        phoneNumberTextField.placeholder = viewModel?.data.thirdTextFieldPlaceholder
        nameTextField.text = viewModel?.data.firstTextFieldText
        lastNameTextField.text = viewModel?.data.secondTextFieldText
        phoneNumberTextField.text = viewModel?.data.thirdTextFieldText
        contactImageView.image = viewModel?.data.avatarImage
    }
    
    private func setup() {
        initializeUI()
        createConstraints()
        setupToolbar()
        setupImageView()
    }
    
    private func setupToolbar() {
        toolbar.buttonsDelegate = self
    }
    
    private func setupImageView() {
        contactImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        contactImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // UI
    private func initializeUI() {
        initializeNameTextFieldUI()
        initializeLastNameTextFieldUI()
        initializePhoneNumberTextFieldUI()
        initializeContactImageViewUI()
    }
    
    private func initializeContactImageViewUI() {
        contactImageView.image = R.image.placeholder()
        contactImageView.clipsToBounds = true
    }
    
    private func initializeNameTextFieldUI() {
        nameTextField.placeholder = R.string.localizable.firstName()
        nameTextField.delegate = self
        nameTextField.returnKeyType = .next
    }
    
    private func initializeLastNameTextFieldUI() {
        lastNameTextField.placeholder = R.string.localizable.lastName()
        lastNameTextField.delegate = self
        lastNameTextField.returnKeyType = .next
    }
    
    private func initializePhoneNumberTextFieldUI() {
        phoneNumberTextField.placeholder = R.string.localizable.phone()
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.inputAccessoryView = toolbar
        phoneNumberTextField.maxDigits = Constants.maxCharacterCount
        phoneNumberTextField.defaultRegion = "RU"
        phoneNumberTextField.withExamplePlaceholder = true
        phoneNumberTextField.withPrefix = true
        phoneNumberTextField.withFlag = true
        phoneNumberTextField.delegate = self
        phoneNumberTextField.returnKeyType = .next
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

// MARK: - UITextFieldDelegate
extension ProfileView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel?.didBecomeActiveTextInputField?(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel?.textInputFieldDidAskToFocusNext?(textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = textField.text?.updatedText(replacementString: string,
                                                      replacementRange: range) ?? ""
        
        guard updatedText.count <= Constants.maxCharacterCount else { return false }
        
        updateViewModelData(currentTextField: textField, updatedText: updatedText)
        return true
    }
    
    // Helpers
    private func updateViewModelData(currentTextField: UITextField, updatedText: String) {
        switch currentTextField {
        case nameTextField:
            viewModel?.data.firstTextFieldText = updatedText
            if updatedText.isEmpty {
                viewModel?.makeDoneUnavailable()
            } else {
                viewModel?.makeDoneAvailable()
            }
        case lastNameTextField:
            viewModel?.data.secondTextFieldText = updatedText
        case phoneNumberTextField:
            viewModel?.data.thirdTextFieldText = updatedText
        default:
            break
        }
        viewModel?.didUpdateData?()
    }
    
}

// MARK: - ToolbarPickerViewDelegate
extension ProfileView: CustomToolbarDelegate {
    func customToolbarDidChooseFirstOption(_ customToolbar: CustomToolbar) {
        viewModel?.textInputFieldDidAskToFocusNext?(phoneNumberTextField)
    }
    
    func customToolbarDidChooseSecondOption(_ customToolbar: CustomToolbar) {
        phoneNumberTextField.resignFirstResponder()
    }
    
}

// MARK: - Constants
private extension Constants {
    static let maxCharacterCount = 18
    
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
