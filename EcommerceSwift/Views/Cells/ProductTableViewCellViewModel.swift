//
//  ProductTableViewCellViewModel.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 03/02/23.
//

import Foundation
import Combine

final class ProductTableViewCellViewModel: ViewModelHashable {
    // MARK: - Private properties
    let product: CurrentValueSubject<Product, Never>
    let productOperationPublisher = PassthroughSubject<ProductCartOperation, Never>()
    let productCount: CurrentValueSubject<Int, Never>
    let productCellType: ProductCellType
    
    init(product: Product, productCount: Int = 0, productCellType: ProductCellType) {
        self.product = CurrentValueSubject(product)
        self.productCount = CurrentValueSubject(productCount)
        self.productCellType = productCellType
    }
    
    // MARK: - Enums
    
    enum ProductCartOperation {
        case addProduct(product: Product),
             removeProduct(product: Product)
    }
    
    enum ProductCellType {
        case home,
             checkout
    }
}

extension ProductTableViewCellViewModel {
    private func executeProductOperation(value: Int) {
        guard productCount.value > value else {
            productOperationPublisher.send(.addProduct(product: product.value))
            return
        }
        productOperationPublisher.send(.removeProduct(product: product.value))
    }
    
    func handleStepperClicked(value: Double) {
        let intValue = Int(value)
        
        executeProductOperation(value: intValue)
        productCount.send(intValue)
    }
}
