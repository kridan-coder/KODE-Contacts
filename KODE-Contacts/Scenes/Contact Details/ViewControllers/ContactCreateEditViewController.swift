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
    
    private var textFields: [UITextField] = []
    private var textView: UITextView?
    private var activeTextField: UITextField?
    
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
        print(scrollView.frame)
        view.layoutIfNeeded()
        guard let currentTextFieldFrameInStackView = textView?.frame else { return }
        let currentTextFieldFrameInScrollView = scrollView.convert(currentTextFieldFrameInStackView,from: stackView)
        scrollView.scrollRectToVisible(currentTextFieldFrameInScrollView, animated: true)
        // Get the Y position of your child view
        // let childStartPoint = currentTextFieldFrameInScrollView.convertPoint(view.frame.origin, toView: self)
        // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
        //scrollView.scrollRectToVisible(CGRect(x: 0, y: currentTextFieldFrameInScrollView.origin.y, width: 1, height: scrollView.frame.height),
                //                       animated: true)
        
        //guard let currentTextFieldFrameInStackView = activeTextField?.frame else { return }
        //let currentTextFieldFrameInScrollView = scrollView.convert(currentTextFieldFrameInStackView,
        //                                                           from: stackView)
        //scrollView.setContentOffset(CGPoint(x: 0, y: currentTextFieldFrameInScrollView.maxY), animated: true)
        
        //scrollView.scrollRectToVisible(currentTextFieldFrameInScrollView, animated: true)
        //scrollView.scrollRectToVisible(CGRect(x: 0, y: currentTextFieldFrameInScrollView.origin.y, width: 1, height: currentTextFieldFrameInScrollView.height), animated: true)
        //guard let selectedRange = textView?.selectedRange else { return }
        //textView?.scrollRangeToVisible(selectedRange)
    }
    
    // MARK: - Private Methods
    private func bindToViewModel() {
        viewModel.didFinishUpdating = { [weak self] in
            self?.setupStackViewSubviews()
        }
        viewModel.didAskToFocusNextTextField = { [weak self] textField in
            self?.focusNextTextField(textField)
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
        viewModel.didBecomeActiveTextField = { [weak self] textField in
            self?.activeTextField = textField
        }
    }
    
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func focusNextTextField(_ currentTextField: UITextField) {
        
        print(scrollView.frame)
        guard let currentIndex = textFields.firstIndex(of: currentTextField) else { return }
        guard !textFields.indexOutOfRange(currentIndex + 1) else {
            textView?.returnKeyType = .done
            textView?.becomeFirstResponder()
            return
        }
        let nextTextField = textFields[currentIndex + 1]
        nextTextField.returnKeyType = .next
        nextTextField.becomeFirstResponder()
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
        textFields = []
        for viewModel in viewModel.cellViewModels {
            switch viewModel {
            case let viewModel1 as ContactProfileViewModel:
                let view1 = ProfileView()
                view1.configure(with: viewModel1)
                textFields.append(view1.nameTextField)
                textFields.append(view1.lastNameTextField)
                textFields.append(view1.phoneNumberTextField)
                stackView.addArrangedSubview(view1)
                
            case let viewModel2 as ContactRingtoneViewModel:
                let view2 = RingtoneView(frame: CGRect.zero)
                view2.configure(with: viewModel2)
                textFields.append(view2.descriptionTextField)
                stackView.addArrangedSubview(view2)
                
            case let viewModel3 as ContactNotesViewModel:
                let view3 = NotesView()
                view3.configure(with: viewModel3)
                textView = view3.descriptionTextView
                //textFields.append(view3.descriptionTextView)
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
