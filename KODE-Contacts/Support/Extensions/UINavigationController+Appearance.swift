//
//  UINavigationController.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

extension UINavigationController {
    static func createDefaultNavigationController(backgroundColor: UIColor = .navigationBarLight) -> UINavigationController {
        let navigationController = UINavigationController()
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = backgroundColor
            navigationController.navigationBar.standardAppearance = navBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController.navigationBar.barTintColor = backgroundColor
            navigationController.navigationBar.isTranslucent = false
        }
        return navigationController
    }
    
    func changeBackgroundColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = color
            self.navigationBar.standardAppearance = navBarAppearance
            self.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            self.navigationBar.barTintColor = color
        }
    }
    
}
