//
//  DiscountService.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 08/02/23.
//

import Foundation
import Combine

protocol DiscountServiceInterface {
    func fetchAllDiscounts() -> AnyPublisher<[Discount], Error>
}

final class DiscountService: DiscountServiceInterface {
    let baseURL = "https://gist.githubusercontent.com/pmrmoura/83a724e28ec78cac9ea930068681c78b/raw/b4966a5d64b6482605c21217ef03e13c6f5ee72d/Discounts.json"
    
    func fetchAllDiscounts() -> AnyPublisher<[Discount], Error> {
        guard let url = URL(string: baseURL) else { return Fail(error: CustomError.noConnection).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
        
        return dataTaskPublisher
            .map({ $0.data })
            .decode(type: DiscountResponse.self, decoder: JSONDecoder())
            .map({ $0.discounts })
            .eraseToAnyPublisher()
    }
}

