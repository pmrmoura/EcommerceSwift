//
//  HomeViewModel.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 02/02/23.
//

import Combine
import UIKit

final class HomeViewModel {
    // MARK: Properties
    
    let snapshot: CurrentValueSubject<NSDiffableDataSourceSnapshot<Section, CellType>, Never> = CurrentValueSubject(NSDiffableDataSourceSnapshot())
    let state: CurrentValueSubject<State, Never> = CurrentValueSubject(.idle)
    let checkoutButtonPublisher = PassthroughSubject<Cart, Never>()
    let alertPublisher = PassthroughSubject<AlertInformation, Never>()
    var products: [Product] = []
    var cart: Cart
    
    // MARK: Private properties
    
    private var cells: [CellType] = [] {
        didSet {
            updateSnapshot()
        }
    }

    private var cancelBag = Set<AnyCancellable>()
    private let service: ProductServiceInterface
    
    init(service: ProductServiceInterface = ProductService(),
         cart: Cart = Cart()) {
        self.service = service
        self.cart = cart
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellType>()
        snapshot.appendSections([.first])
        snapshot.appendItems(cells)
        self.snapshot.send(snapshot)
    }
    
    enum Constants {
        static let cartEmptyAlertMessage = "The cart is empty, please add products"
        static let errorAlertTitle = "Error"
        static let defaultAlertButtonText = "OK"
    }
}

// MARK: - External actions

extension HomeViewModel {
    func fetchData() {
        state.send(.loading)
        
        service.fetchAllProducts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state.send(.error(error: error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
                self?.cells = self?.makeCells() ?? []
                self?.state.send(.success)
            })
            .store(in: &cancelBag)
    }
    
    func executeCartOperation(_ operation: ProductTableViewCellViewModel.ProductCartOperation) {
        switch operation {
        case .addProduct(let product):
            cart.addProduct(product)
        case .removeProduct(let product):
            cart.removeProduct(product)
        }
    }
    
    func checkoutButtonClicked() {
        guard !cart.isCartEmpty() else {
            let alertInformation = AlertInformation(title: Constants.errorAlertTitle , message: Constants.cartEmptyAlertMessage, buttonText: Constants.defaultAlertButtonText)
            alertPublisher.send(alertInformation)
            return
        }
        checkoutButtonPublisher.send(cart)
    }
}

// MARK: - Cell configurations

extension HomeViewModel {
    private func makeCells() -> [CellType] {
        var cells: [CellType] = []
        
        products.forEach {
            cells.append(.product(viewModel: makeProductTableViewCellViewModel(product: $0)))
        }
        
        return cells
    }
    
    private func makeProductTableViewCellViewModel(product: Product) -> ProductTableViewCellViewModel {
        ProductTableViewCellViewModel(product: product, productCellType: .home)
    }
}

// MARK: - Cell types

extension HomeViewModel {
    enum CellType: Hashable {
        case product(viewModel: ProductTableViewCellViewModel)
    }
    
    enum Section: Hashable {
        case first
    }
    
    enum State {
        case idle,
             loading,
             success,
             error(error: Error)
    }
}
