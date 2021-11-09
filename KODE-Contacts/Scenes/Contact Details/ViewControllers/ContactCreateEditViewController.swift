//
//  ContactDetailsCreateEditViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

class ContactCreateEditViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ContactCreateEditViewModel
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private var textInputs: [TextInputField] = []
    private var activeTextInput: TextInputField?
    
    private var doneBarButton: UIBarButtonItem?
    private var cancelBarButton: UIBarButtonItem?
    
    // MARK: - Init
    init(viewModel: ContactCreateEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.isModalInPresentation = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        setup()
        bindToViewModel()
        viewModel.reloadData()
    }
    
    // MARK: Actions
    @objc private func tapDone() {
        viewModel.saveContact()
    }
    
    @objc private func tapCancel() {
        viewModel.cancel()
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                                                   right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    // MARK: - Private Methods
    private func bindToViewModel() {
        viewModel.didFinishUpdating = { [weak self] in
            self?.setupStackViewSubviews()
        }
        viewModel.didAskToFocusNextTextInput = { [weak self] textInput in
            self?.focusNextTextInput(textInput)
        }
        viewModel.didAskToShowImagePicker = { [weak self] in
            self?.showImagePicker()
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlertWithError(error)
        }
        viewModel.didDoneAvailable = { [weak self] available in
            self?.doneBarButton?.isEnabled = available
        }
        viewModel.didBecomeActiveTextInput = { [weak self] textInput in
            self?.activeTextInput = textInput
        }
        viewModel.didAskToAdjustView = { [weak self] in
            self?.adjustScrollView()
        }
    }
    
    private func adjustScrollView() {
        guard let textInput = activeTextInput else { return }
        
        let currentTextFieldFrameInCellView = textInput.frame
        let currentTextFieldFrameInStackView = stackView.convert(currentTextFieldFrameInCellView,
                                                                 from: activeTextInput?.superview)
        let currentTextFieldFrameInScrollView = scrollView.convert(currentTextFieldFrameInStackView,
                                                                   from: stackView)
        scrollView.scrollRectToVisible(currentTextFieldFrameInScrollView, animated: true)
    }
    
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func focusNextTextInput(_ currentTextInput: TextInputField) {
        var currentIndex = -1
        for index in 0..<textInputs.count where textInputs[index].frame == currentTextInput.frame {
            currentIndex = index
        }
        
        guard currentIndex != -1 else { return }
        let nextIndex = currentIndex + 1
        guard !textInputs.indexOutOfRange(nextIndex) else {
            currentTextInput.resignFirstResponder()
            return
        }
        let nextTextInput = textInputs[nextIndex]
        nextTextInput.returnKeyType = (nextIndex == textInputs.count - 1) ? .done : .next
        nextTextInput.becomeFirstResponder()
    }
    
    private func setup() {
        setupNavigationController()
        setupScrollView()
        setupStackView()
        setupNotifications()
    }
    
    private func showImagePicker() {
        viewModel.showImagePicker()
    }
    
    private func setupStackViewSubviews() {
        stackView.removeAllArrangedSubviews()
        textInputs = []
        for viewModel in viewModel.cellViewModels {
            switch viewModel {
            case let viewModel1 as ContactProfileViewModel:
                let view1 = ProfileView()
                view1.configure(with: viewModel1)
                textInputs.append(view1.nameTextField)
                textInputs.append(view1.lastNameTextField)
                textInputs.append(view1.phoneNumberTextField)
                stackView.addArrangedSubview(view1)
                
            case let viewModel2 as ContactRingtoneViewModel:
                let view2 = RingtoneView(frame: CGRect.zero)
                view2.configure(with: viewModel2)
                textInputs.append(view2.descriptionTextField)
                stackView.addArrangedSubview(view2)
                
            case let viewModel3 as ContactNotesViewModel:
                let view3 = NotesView()
                view3.configure(with: viewModel3)
                textInputs.append(view3.descriptionTextView)
                stackView.addArrangedSubview(view3)
                
            default:
                break
            }
        }
        
    }
    
    private func setupNavigationController() {
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDone))
        doneBarButton?.isEnabled = false
        cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapCancel))
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.distribution = .equalSpacing
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension ContactCreateEditViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        confirmCancel()
    }
    
    private func confirmCancel() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: R.string.localizable.saveContact(), style: .default) { _ in
            self.tapDone()
        })
        
        alert.addAction(UIAlertAction(title: R.string.localizable.discardChanges(), style: .default) { _ in
            self.tapCancel()
        })
        
        alert.addAction(UIAlertAction(title: R.string.localizable.keepEditing(), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Constants
private extension Constants {
    static let stackViewSpacing = CGFloat(30)
    
}
