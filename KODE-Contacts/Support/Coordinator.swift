//
//  Coordinator.swift
//  KODE-Weather
//
//  Created by Developer on 23.09.2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    var rootNavigationController: UINavigationController { get set }
    
    func start()
    
    func removeAllChildCoordinatorsWithType<T: Coordinator>(_ type: T.Type)
    
}

extension Coordinator {
    func removeAllChildCoordinatorsWithType<T: Coordinator>(_ type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T == false }
    }
    
}

extension Coordinator where Self: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
    
}
