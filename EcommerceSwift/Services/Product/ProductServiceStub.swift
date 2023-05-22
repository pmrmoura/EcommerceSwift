//
//  ProductServiceStub.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 09/02/23.
//

import Foundation
import Combine

class ProductServiceStub: ProductServiceInterface {
    func fetchAllProducts() -> AnyPublisher<[Product], Error> {
        Bundle.main.url(forResource: "Products", withExtension: "json")
            .publisher
            .tryMap({ string in
                guard let data = try? Data(contentsOf: string) else { fatalError() }
                return data
            })
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .map({ $0.products })
            .mapError({ error in
                return error
            })
            .eraseToAnyPublisher()
    }
}
