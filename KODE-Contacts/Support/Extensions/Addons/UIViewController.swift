//
//  UIViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 19.10.2021.
//

import UIKit
import AVFoundation
import Photos

extension UIViewController {
    func showAlertWithError(_ error: Error) {
        let title: String
        if let customError = error as? CustomError {
            title = customError.errorTitle
            print(customError.localizedDescription)
        } else {
            title = R.string.localizable.defaultErrorTitle()
        }
        print(error.localizedDescription)
        let alert = UIAlertController.buildAlertWithOneButton(title: title, message: error.localizedDescription)
        present(alert, animated: true)
    }
}
