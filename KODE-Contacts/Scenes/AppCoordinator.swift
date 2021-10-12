//
//  AppCoordinator.swift
//  KODE-Weather
//
//  Created by Developer on 23.09.2021.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    let dependencies: AppDependencies
    
    weak var delegate: Coordinator?
    
    var childCoordinators: [Coordinator]
    
    var rootNavigationController: UINavigationController = .transparentNavigationController
    
    private let window: UIWindow
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
        dependencies = AppDependencies(coreDataClient: CoreDataClient())
        childCoordinators = []
    }
    
    // MARK: - Public Methods
    func start() {
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        showContactsListScene()
    }
    
    // MARK: - Private Methods
    private func showContactsListScene() {
        let contactsListScene = ContactsListCoordinator(dependencies: dependencies,
                                                        navigationController: rootNavigationController)
        childCoordinators.append(contactsListScene)
        contactsListScene.start()
    }
    
}
