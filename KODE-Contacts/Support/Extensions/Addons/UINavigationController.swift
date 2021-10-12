//
//  UINavigationController.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

extension UINavigationController {
    static var transparentNavigationController: UINavigationController {
        let navigationController = UINavigationController()
        let navigationBar = navigationController.navigationBar
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        return navigationController
    }
}
