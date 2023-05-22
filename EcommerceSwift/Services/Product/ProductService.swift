//
//  ProductService.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 02/02/23.
//

import Foundation
import Combine

protocol ProductServiceInterface {
    func fetchAllProducts() -> AnyPublisher<[Product], Error>
}

final class ProductService: ProductServiceInterface {
    let baseURL = "https://gist.githubusercontent.com/pmrmoura/3b861deed7c32e5e240047fd0ad2290b/raw/97c63b212da3f0180d3550c46211c6fdc7efc0b8/Products.json"
    
    func fetchAllProducts() -> AnyPublisher<[Product], Error> {
        guard let url = URL(string: baseURL) else { return Fail(error: CustomError.noConnection).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
        
        return dataTaskPublisher
            .map({ $0.data })
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .map({ $0.products })
            .eraseToAnyPublisher()
    }
}
