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
    private let pickerView = UIPickerView()
    
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
        setupNavigationController()
        setupPicker()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Actions
    @objc private func editContactDidFinish() {
        viewModel.editContactDidFinish()
    }
    
    @objc private func editContactDidCancel() {
        viewModel.editContactDidCancel()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationController() {
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editContactDidFinish))
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(editContactDidCancel))
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        setupScrollView()
        setupStackView()
        
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalToSuperview()
        }
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .equalSpacing
        
        // TODO: - get rid of test code
        let partView1 = ContactCreateRedactPartView1()
        let partView2 = ContactCreateRedactPartView2()
        let partView3 = ContactCreateRedactPartView3()
        
        stackView.addArrangedSubview(partView1)
        stackView.addArrangedSubview(partView2)
        stackView.addArrangedSubview(partView3)
    }
    
    private func setupPickerView() {
        // TODO: - setup it as subview
    }
    
}

// MARK: - UIPickerViewDataSource
extension ContactCreateRedactViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
}

// MARK: - UIPickerViewDelegate
extension ContactCreateRedactViewController: UIPickerViewDelegate {}

// MARK: - UIAdaptivePresentationControllerDelegate
extension ContactCreateRedactViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        confirmCancel()
    }
    
    func confirmCancel() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: R.string.localizable.saveContact(), style: .default) { _ in
            self.editContactDidFinish()
        })
        
        alert.addAction(UIAlertAction(title: R.string.localizable.discardChanges(), style: .default) { _ in
            self.editContactDidCancel()
        })
        
        alert.addAction(UIAlertAction(title: R.string.localizable.keepEditing(), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}
