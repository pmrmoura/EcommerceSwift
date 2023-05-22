//
//  Discount.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 05/02/23.
//

import Foundation

struct DiscountResponse: Codable {
    let discounts: [Discount]
}

final class Discount: Codable {
    let numberOfPiecesNeeded: Int
    let discountReceived: Double
    let discountType: String
    let productCode: String

    lazy var discountTypeEnum = DiscountType(rawValue: discountType)
    
    enum DiscountType: String {
        case bulk,
             oneForFree
    }
}
