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
    let contactCreateRedactNavigationController =
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
            startCreateRedact()
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
    
    private func startCreateRedact(contact: Contact? = nil) {
        let contactCreateRedactViewModel = ContactCreateRedactViewModel(dependencies: dependencies, contact: contact)
        contactCreateRedactViewModel.delegate = self
        didGetImage = { [weak contactCreateRedactViewModel] image in
            contactCreateRedactViewModel?.setupImage(image)
        }
        
        let contactCreateRedactViewController = ContactCreateRedactViewController(viewModel: contactCreateRedactViewModel)
        
        contactCreateRedactNavigationController.setViewControllers([contactCreateRedactViewController], animated: false)
        contactCreateRedactNavigationController.presentationController?.delegate = contactCreateRedactViewController
        
        rootNavigationController.present(contactCreateRedactNavigationController, animated: true)
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
        
        contactCreateRedactNavigationController.present(alert, animated: true, completion: nil)
    }
    
    private func showCamera(with imagePicker: UIImagePickerController) {
        imagePicker.sourceType = .camera
        AVCaptureDevice.requestAccess(for: .video) { success in
            DispatchQueue.main.async {
                if success {
                    self.contactCreateRedactNavigationController.present(imagePicker, animated: true, completion: nil)
                } else {
                    self.contactCreateRedactNavigationController.showAlertWithError(PermissionError.noAccessToCamera)
                    
                }
            }
        }
    }
    
    private func showPhotoLibrary(with imagePicker: UIImagePickerController) {
        imagePicker.sourceType = .photoLibrary
        let status = PHPhotoLibrary.authorizationStatus()
        guard status != .authorized else {
            contactCreateRedactNavigationController.present(imagePicker, animated: true, completion: nil)
            return
        }
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.contactCreateRedactNavigationController.present(imagePicker, animated: true, completion: nil)
                    
                default:
                    self.contactCreateRedactNavigationController.showAlertWithError(PermissionError.noAccessToPhotos)
                    
                }
            }
        }
    }
    
}

// MARK: - ContactCreateRedactViewModelDelegate
extension ContactDetailsCoordinator: ContactCreateRedactViewModelDelegate {
    func contactCreateRedactViewModelDidAskToShowImagePicker(_ contactCreateRedactViewModel: ContactCreateRedactViewModel) {
        showImagePicker()
    }
    
    func contactCreateRedactViewModel(_ contactCreateRedactViewModel: ContactCreateRedactViewModel,
                                      didFinishCreating contact: Contact) {
        delegate?.contactDetailsCoordinatorDidFinish(self)
    }
    
    func contactCreateRedactViewModel(_ contactCreateRedactViewModel: ContactCreateRedactViewModel,
                                      didFinishEditing contact: Contact) {
        self.contact = contact
        didUpdateContact?(contact)
        rootNavigationController.dismiss(animated: true)
    }
    
    func contactCreateRedactViewModelDidCancelCreating(_ contactCreateRedactViewModel: ContactCreateRedactViewModel) {
        delegate?.contactDetailsCoordinatorDidFinish(self)
    }
    
    func contactCreateRedactViewModelDidCancelEditing(_ contactCreateRedactViewModel: ContactCreateRedactViewModel) {
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
        startCreateRedact(contact: contact)
    }
    
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ContactDetailsCoordinator: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        contactCreateRedactNavigationController.dismiss(animated: true)
        if let image = info[.editedImage] as? UIImage {
            didGetImage?(image)
            return
        }
        
        if let image = info[.originalImage] as? UIImage {
            didGetImage?(image)
        }
    }
    
}
