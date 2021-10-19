//
//  UIViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 19.10.2021.
//

import UIKit

extension UIViewController {
    func showAlertWithError(_ error: Error) {
        let title: String
        if let customError = error as? CustomError {
            title = customError.errorTitle
        } else {
            title = R.string.localizable.defaultErrorTitle()
        }
        let alert = UIAlertController.buildAlertWithOneButton(title: title, message: error.localizedDescription)
        present(alert, animated: true)
    }
}
