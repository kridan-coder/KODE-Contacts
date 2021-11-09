//
//  ContactDetailsCoordinator.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit
import AVFoundation
import Photos

protocol ContactDetailsCoordinatorDelegate: AnyObject {
    func contactDetailsCoordinatorDidFinish(_ contactDetailsCoordinator: ContactDetailsCoordinator)
}

final class ContactDetailsCoordinator: NSObject, Coordinator {
    // MARK: - Properties
    weak var delegate: ContactDetailsCoordinatorDelegate?
    
    var childCoordinators: [Coordinator]
    
    var didUpdateContact: ((Contact) -> Void)?
    var didGetImage: ((UIImage) -> Void)?
    
    var rootNavigationController: UINavigationController
    let contactCreateEditNavigationController =
    UINavigationController.createDefaultNavigationController(backgroundColor: .white)
    
    private let dependencies: AppDependencies
    
    private var contact: Contact?
    
    // MARK: - Init
    init(dependencies: AppDependencies, navigationController: UINavigationController, contact: Contact? = nil) {
        self.dependencies = dependencies
        self.contact = contact
        childCoordinators = []
        
        rootNavigationController = navigationController
        rootNavigationController.navigationBar.prefersLargeTitles = true
        rootNavigationController.navigationBar.backgroundColor = .navigationBarLight
    }
    
    // MARK: Public Methods
    func start() {
        if let contact = contact {
            startShow(contact: contact)
        } else {
            startCreateEdit()
        }
    }
    
    // MARK: - Private Methods
    private func startShow(contact: Contact) {
        rootNavigationController.navigationBar.prefersLargeTitles = false
        rootNavigationController.changeBackgroundColor(.almostWhite)
        
        let contactShowViewModel = ContactShowViewModel(contact: contact)
        contactShowViewModel.delegate = self
        didUpdateContact = { [weak contactShowViewModel] contact in
            contactShowViewModel?.contact = contact
            contactShowViewModel?.reloadData()
        }
        
        let contactShowViewController = ContactShowViewController(viewModel: contactShowViewModel)
        rootNavigationController.pushViewController(contactShowViewController, animated: true)
    }
    
    private func startCreateEdit(contact: Contact? = nil) {
        let contactCreateEditViewModel = ContactCreateEditViewModel(dependencies: dependencies,
                                                                    state: CreateEditState(contact: contact))
        contactCreateEditViewModel.delegate = self
        didGetImage = { [weak contactCreateEditViewModel] image in
            contactCreateEditViewModel?.setupImage(image)
        }
        
        let contactCreateEditViewController = ContactCreateEditViewController(viewModel: contactCreateEditViewModel)
        
        contactCreateEditNavigationController.setViewControllers([contactCreateEditViewController], animated: false)
        contactCreateEditNavigationController.presentationController?.delegate = contactCreateEditViewController
        
        rootNavigationController.present(contactCreateEditNavigationController, animated: true)
    }
    
    private func showImagePicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            alert.addAction(UIAlertAction(title: R.string.localizable.takePhoto(), style: .default) { _ in
                self.showCamera(with: imagePicker)
            })
        }
        
        alert.addAction(UIAlertAction(title: R.string.localizable.choosePhoto(), style: .default) { _ in
            self.showPhotoLibrary(with: imagePicker)
        })
        
        alert.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil))
        
        contactCreateEditNavigationController.present(alert, animated: true, completion: nil)
    }
    
    private func showCamera(with imagePicker: UIImagePickerController) {
        imagePicker.sourceType = .camera
        AVCaptureDevice.requestAccess(for: .video) { success in
            DispatchQueue.main.async {
                if success {
                    self.contactCreateEditNavigationController.present(imagePicker, animated: true, completion: nil)
                } else {
                    self.contactCreateEditNavigationController.showAlertWithError(PermissionError.noAccessToCamera)
                    
                }
            }
        }
    }
    
    private func showPhotoLibrary(with imagePicker: UIImagePickerController) {
        imagePicker.sourceType = .photoLibrary
        let status = PHPhotoLibrary.authorizationStatus()
        guard status != .authorized else {
            contactCreateEditNavigationController.present(imagePicker, animated: true, completion: nil)
            return
        }
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.contactCreateEditNavigationController.present(imagePicker, animated: true, completion: nil)
                    
                default:
                    self.contactCreateEditNavigationController.showAlertWithError(PermissionError.noAccessToPhotos)
                    
                }
            }
        }
    }
    
}

// MARK: - ContactCreateEditViewModelDelegate
extension ContactDetailsCoordinator: ContactCreateEditViewModelDelegate {
    func contactCreateEditViewModelDidAskToShowImagePicker(_ contactCreateEditViewModel: ContactCreateEditViewModel) {
        showImagePicker()
    }
    
    func contactCreateEditViewModel(_ contactCreateEditViewModel: ContactCreateEditViewModel,
                                    didFinishCreating contact: Contact) {
        delegate?.contactDetailsCoordinatorDidFinish(self)
    }
    
    func contactCreateEditViewModel(_ contactCreateEditViewModel: ContactCreateEditViewModel,
                                    didFinishEditing contact: Contact) {
        self.contact = contact
        didUpdateContact?(contact)
        rootNavigationController.dismiss(animated: true)
    }
    
    func contactCreateEditViewModelDidCancelCreating(_ contactCreateEditViewModel: ContactCreateEditViewModel) {
        delegate?.contactDetailsCoordinatorDidFinish(self)
    }
    
    func contactCreateEditViewModelDidCancelEditing(_ contactCreateEditViewModel: ContactCreateEditViewModel) {
        rootNavigationController.dismiss(animated: true)
    }
    
}

// MARK: - ContactShowViewModelDelegate
extension ContactDetailsCoordinator: ContactShowViewModelDelegate {
    func contactShowViewModel(_ contactShowViewModel: ContactShowViewModel, didAskToOpen url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    func contactShowViewModelDidCancel(_ contactShowViewModel: ContactShowViewModel) {
        delegate?.contactDetailsCoordinatorDidFinish(self)
    }
    
    func contactShowViewModel(_ contactShowViewModel: ContactShowViewModel, didAskToEdit contact: Contact) {
        startCreateEdit(contact: contact)
    }
    
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ContactDetailsCoordinator: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        contactCreateEditNavigationController.dismiss(animated: true)
        if let image = info[.editedImage] as? UIImage {
            didGetImage?(image)
            return
        }
        
        if let image = info[.originalImage] as? UIImage {
            didGetImage?(image)
        }
    }
    
}
