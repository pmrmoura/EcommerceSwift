//
//  CustomError.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 02/02/23.
//

import Foundation
enum CustomError {
    case noConnection, noData, invalidURL
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData: return "Well, weird thing happens"
        case .noConnection: return "No Internet Connection"
        case .invalidURL: return "There was a problem with the URL"
        }
    }
}
