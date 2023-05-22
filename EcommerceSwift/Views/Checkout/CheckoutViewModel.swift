//
//  CheckoutViewModel.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 02/02/23.
//

import UIKit
import Combine

final class CheckoutViewModel {
    // MARK: Properties
    let snapshot: CurrentValueSubject<NSDiffableDataSourceSnapshot<Section, CellType>, Never> = CurrentValueSubject(NSDiffableDataSourceSnapshot())
    
    // MARK: Private properties
    private let cart: Cart
    private var cells: [CellType] = [] {
        didSet {
            updateSnapshot()
        }
    }
    
    init(cart: Cart) {
        self.cart = cart
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellType>()
        snapshot.appendSections([.first])
        snapshot.appendItems(cells)
        self.snapshot.send(snapshot)
    }
}

// MARK: - Cell configurations

extension CheckoutViewModel {
    func makeCells() {
        var cells: [CellType] = []
        
        cart.productsMap.forEach { productCode, productQuantity in
            if let product = cart.products.first(where: { $0.code == productCode }) {
                cells.append(.product(viewModel: makeProductTableViewCellViewModel(product: product, quantity: Int(productQuantity))))
            }
        }
        
        cells.append(.price(viewModel: makePriceTableViewCellViewModel(price: .subtotal(price: cart.calculateSubtotal()))))
        cells.append(.price(viewModel: makePriceTableViewCellViewModel(price: .discount(price: cart.calculateDiscount()))))
        cells.append(.price(viewModel: makePriceTableViewCellViewModel(price: .total(price: cart.calculateFinalPrice()))))
        
        self.cells = cells
    }
    
    private func makeProductTableViewCellViewModel(product: Product, quantity: Int) -> ProductTableViewCellViewModel {
        ProductTableViewCellViewModel(product: product, productCount: quantity, productCellType: .checkout)
    }
    
    private func makePriceTableViewCellViewModel(price: Prices) -> PriceTableViewCellViewModel {
        PriceTableViewCellViewModel(priceType: price)
    }
}


// MARK: - Cell types

extension CheckoutViewModel {
    enum CellType: Hashable {
        case product(viewModel: ProductTableViewCellViewModel)
        case price(viewModel: PriceTableViewCellViewModel)
    }
    
    enum Section: Hashable {
        case first
    }
    
    enum Prices {
        case subtotal(price: Double),
             total(price: Double),
             discount(price: Double)
    }
}
