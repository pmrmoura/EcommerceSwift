//
//  PriceTableViewCellViewModel.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 08/02/23.
//

import Foundation
import Combine

final class PriceTableViewCellViewModel: ViewModelHashable {
    let priceType: CurrentValueSubject<CheckoutViewModel.Prices, Never>
    
    init(priceType: CheckoutViewModel.Prices) {
        self.priceType = CurrentValueSubject(priceType)
    }
}
