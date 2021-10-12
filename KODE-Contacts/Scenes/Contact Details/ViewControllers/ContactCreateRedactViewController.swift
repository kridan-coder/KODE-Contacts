//
//  ContactDetailsCreateRedactViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

class ContactCreateRedactViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ContactCreateRedactViewModel
    
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
        setupView()
    }
    
    // MARK: Actions
    @objc private func editContactDidFinish() {
        viewModel.editContactDidFinish()
        
    }
    
    @objc private func editContactDidCancel() {
        viewModel.editContactDidCancel()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationController() {
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editContactDidFinish))
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(editContactDidCancel))
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension ContactCreateRedactViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        confirmCancel()
    }
    
    func confirmCancel() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Save Contact", style: .default) { _ in
            self.editContactDidFinish()
        })
        
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .default) { _ in
            self.editContactDidCancel()
        })
        
        alert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}
