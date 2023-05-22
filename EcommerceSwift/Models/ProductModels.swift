//
//  ProductModels.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 02/02/23.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]
}

struct Product: Codable, Equatable {
    let code: String
    let name: String
    let price: Double
}
