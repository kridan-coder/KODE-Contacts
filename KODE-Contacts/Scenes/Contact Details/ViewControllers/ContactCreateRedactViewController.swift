//
//  ContactDetailsCreateRedactViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit
import TPKeyboardAvoiding
import AVFoundation
import Photos

class ContactCreateRedactViewController: UIViewController {
    // MARK: - Properties
    var stackViewSubviews: [UIView] = []
    
    private let viewModel: ContactCreateRedactViewModel
    
    private let scrollView = TPKeyboardAvoidingScrollView()
    private let stackView = UIStackView()
    private let imagePicker = UIImagePickerController()
    
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
        setupImagePicker()
        bindToViewModel()
        viewModel.reloadData()
    }
    
    // MARK: Actions
    @objc private func editContactDidFinish() {
        viewModel.editContactDidFinish()
    }
    
    @objc private func editContactDidCancel() {
        viewModel.editContactDidCancel()
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
    }
    
    private func showImagePicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            alert.addAction(UIAlertAction(title: R.string.localizable.takePhoto(), style: .default) { _ in
                self.showCamera()
            })
        }
        
        alert.addAction(UIAlertAction(title: R.string.localizable.choosePhoto(), style: .default) { _ in
            self.showPhotoLibrary()
        })
        
        alert.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showCamera() {
        self.imagePicker.sourceType = .camera
        AVCaptureDevice.requestAccess(for: .video) { success in
            DispatchQueue.main.async {
                if success {
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    self.showAlertWithError(PermissionError.noAccessToCamera)
                    
                }
            }
        }
    }
    
    private func showPhotoLibrary() {
        self.imagePicker.sourceType = .photoLibrary
        let status = PHPhotoLibrary.authorizationStatus()
        guard status != .authorized else {
            self.present(self.imagePicker, animated: true, completion: nil)
            return
        }
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.present(self.imagePicker, animated: true, completion: nil)
                    
                default:
                    self.showAlertWithError(PermissionError.noAccessToPhotos)
                    
                }
            }
        }
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func setupStackViewSubviews() {
        stackView.removeAllArrangedSubviews()
        
        for viewModel in viewModel.cellViewModels {
            switch viewModel {
            case let viewModel1 as ContactCreateRedactPartViewModel1:
                let view1 = ContactCreateRedactPartView1()
                view1.configure(with: viewModel1)
                view1.setupDynamicUI()
                stackView.addArrangedSubview(view1)
                
            case let viewModel2 as ContactCreateRedactPartViewModel2:
                let view2 = ContactCreateRedactPartView2()
                view2.configure(with: viewModel2)
                stackView.addArrangedSubview(view2)
                
            case let viewModel3 as ContactCreateRedactPartViewModel3:
                let view3 = ContactCreateRedactPartView3()
                view3.configure(with: viewModel3)
                stackView.addArrangedSubview(view3)
                
            default:
                break
            }
        }
        
    }
    
    private func setupNavigationController() {
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editContactDidFinish))
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(editContactDidCancel))
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
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
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.distribution = .equalSpacing
    }
    
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ContactCreateRedactViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true)
        if let image = info[.editedImage] as? UIImage {
            viewModel.setupImage(image)
            return
        }
        
        if let image = info[.originalImage] as? UIImage {
            viewModel.setupImage(image)
        }
    }
    
}

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

// MARK: - Constants
private extension Constants {
    static let stackViewSpacing = CGFloat(30)
}
