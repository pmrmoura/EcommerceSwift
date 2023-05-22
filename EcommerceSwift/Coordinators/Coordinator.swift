//
//  Coordinator.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 02/02/23.
//

import Foundation

/// The Coordinator protocol
public protocol Coordinator: AnyObject {
        
    /// The array containing any child Coordinators
    var childCoordinators: [Coordinator] { get set }
    
}

public extension Coordinator {
    
    /// Add a child coordinator to the parent
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    /// Remove a child coordinator from the parent
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
    
}
