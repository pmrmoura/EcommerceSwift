//
//  HomeCoordinator.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 02/02/23.
//

import UIKit
import Combine

final class HomeCoordinator: RootViewCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return navigationController
    }
    
    private var navigationController = UINavigationController()
    
    private var cancelBag = Set<AnyCancellable>()
    
    func start() {
        let viewModel = HomeViewModel()
        viewModel.checkoutButtonPublisher
            .sink(receiveValue: { [weak self] cart in
                self?.navigateToCheckoutController(cart: cart)
            })
            .store(in: &cancelBag)
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func navigateToCheckoutController(cart: Cart) {
        let viewModel = CheckoutViewModel(cart: cart)
        let controller = CheckoutViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}

