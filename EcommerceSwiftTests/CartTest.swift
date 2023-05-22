//
//  Cart.swift
//  EcommerceSwiftTests
//
//  Created by Pedro Moura on 09/02/23.
//

import XCTest
import Combine
@testable import EcommerceSwift

final class CartTest: XCTestCase {
    
    private var cart: Cart!
    let productTest = Product(code: "TEST", name: "Test Product", price: 15)
    var cancelBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cart = Cart(service: DiscountServiceStub())
        cancelBag = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cart = nil
        cancelBag = nil
        super.tearDown()
    }
    
    func testAddProductToCart() {
        cart.addProduct(productTest)
        XCTAssertTrue(cart.products.contains(productTest))
    }
    
    func testRemoveProductToCart() {
        cart.addProduct(productTest)
        XCTAssertTrue(cart.products.contains(productTest))
        
        cart.removeProduct(productTest)
        XCTAssertFalse(cart.products.contains(productTest))
    }
    
    func testFetchedDiscounts() {
        let waiter = XCTWaiter()
        waiter.wait(for: [XCTestExpectation(description: "fetchActiveDiscounts")], timeout: 0.1)
        
        XCTAssertTrue(cart.activeDiscounts.count == 2)
    }
    
    func testIsCartEmpty() {
        cart.addProduct(productTest)
        XCTAssertFalse(cart.isCartEmpty())
        cart.removeProduct(productTest)
        XCTAssertTrue(cart.isCartEmpty())
    }
    
    func testSubtotalPrice() {
        let productServiceStub = ProductServiceStub()
        productServiceStub.fetchAllProducts()
            .sink(receiveCompletion: {_ in }, receiveValue: {[weak self] products in
                products.forEach {
                    self?.cart.addProduct($0)
                }
            })
            .store(in: &cancelBag)
        
        let waiter = XCTWaiter()
        waiter.wait(for: [XCTestExpectation(description: "fetchProducts")], timeout: 0.1)
        
        XCTAssertEqual(cart.calculateSubtotal(), 32.5)
    }
    
    func testFinalPriceWithDiscount() {
        let productServiceStub = ProductServiceStub()
        productServiceStub.fetchAllProducts()
            .sink(receiveCompletion: {_ in }, receiveValue: {[weak self] products in
                products.forEach {
                    if $0.code == "VOUCHER" {
                        self?.cart.addProduct($0, 2)
                    }
                    
                    if $0.code == "TSHIRT" {
                        self?.cart.addProduct($0, 3)
                    }
                }
            })
            .store(in: &cancelBag)
        
        let waiter = XCTWaiter()
        waiter.wait(for: [XCTestExpectation(description: "fetchProducts")], timeout: 0.1)
        
        XCTAssertEqual(cart.calculateFinalPrice(), 62.0)
    }
}

