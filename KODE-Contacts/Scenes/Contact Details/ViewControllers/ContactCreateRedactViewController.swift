//
//  ContactDetailsCreateRedactViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit
import TPKeyboardAvoiding

class ContactCreateRedactViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ContactCreateRedactViewModel
    
    private let scrollView = TPKeyboardAvoidingScrollView()
    private let stackView = UIStackView()
    
    private var neededTextFields: [UITextField] = []
    
    private var doneBarButton: UIBarButtonItem?
    private var cancelBarButton: UIBarButtonItem?
    
    // MARK: - Init
    init(viewModel: ContactCreateRedactViewModel) {
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
    
    // MARK: - Private Methods
    private func bindToViewModel() {
        viewModel.didFinishUpdating = { [weak self] in
            self?.setupStackViewSubviews()
        }
        viewModel.didAskToFocusNextTextField = { [weak self] in
            self?.scrollView.focusNextTextField()
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
    }
    
    private func setup() {
        setupNavigationController()
        setupScrollView()
        setupStackView()
    }
    
    private func showImagePicker() {
        viewModel.showImagePicker()
    }
    
    private func setupStackViewSubviews() {
        stackView.removeAllArrangedSubviews()
        
        for viewModel in viewModel.cellViewModels {
            switch viewModel {
            case let viewModel1 as ContactProfileViewModel:
                let view1 = ProfileView()
                view1.configure(with: viewModel1)
                stackView.addArrangedSubview(view1)
                
            case let viewModel2 as ContactRingtoneViewModel:
                let view2 = RingtoneView(frame: CGRect.zero)
                view2.configure(with: viewModel2)
                stackView.addArrangedSubview(view2)
                
            case let viewModel3 as ContactNotesViewModel:
                let view3 = NotesView()
                view3.configure(with: viewModel3)
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
extension ContactCreateRedactViewController: UIAdaptivePresentationControllerDelegate {
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
