//
//  DiscountServiceStub.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 09/02/23.
//

import Foundation
import Combine

final class DiscountServiceStub: DiscountServiceInterface {
    func fetchAllDiscounts() -> AnyPublisher<[Discount], Error> {
        Bundle.main.url(forResource: "Discounts", withExtension: "json")
            .publisher
            .tryMap({ string in
                guard let data = try? Data(contentsOf: string) else { fatalError() }
                return data
            })
            .decode(type: DiscountResponse.self, decoder: JSONDecoder())
            .map({ $0.discounts })
            .mapError({ error in
                return error
            })
            .eraseToAnyPublisher()
    }
}
