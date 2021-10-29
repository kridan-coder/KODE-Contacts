//
//  UIAlertControllerAddons.swift
//  KODE-Weather
//
//  Created by Developer on 07.10.2021.
//

import UIKit

extension UIAlertController {
    static func buildAlertWithOneButton(title: String? = R.string.localizable.defaultErrorTitle(),
                                        message: String? = R.string.localizable.defaultErrorDescription(),
                                        buttonTitle: String? = R.string.localizable.okay(),
                                        handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.title = title
        alert.message = message
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: handler))
        return alert
    }
    
}
