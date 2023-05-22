import XCTest
import Combine
@testable import EcommerceSwift

final class HomeViewModelTest: XCTestCase {
    
    private var viewModel: HomeViewModel!
    let productTest = Product(code: "TEST", name: "Test Product", price: 15)
    
    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel(service: ProductServiceStub(), cart: Cart(service: DiscountServiceStub()))
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    
    func testExecuteCartOperationAddProduct() {
        viewModel.executeCartOperation(.addProduct(product: productTest))
        
        XCTAssert(viewModel.cart.products.contains(productTest))
    }
    
    func testExecuteCartOperationRemoveProduct() {
        viewModel.executeCartOperation(.addProduct(product: productTest))
        
        XCTAssert(viewModel.cart.products.contains(productTest))
        
        viewModel.executeCartOperation(.removeProduct(product: productTest))
        
        XCTAssertFalse(viewModel.cart.products.contains(productTest))
    }
    
    func testFetchData() {
        viewModel.fetchData()
        
        let waiter = XCTWaiter()
        waiter.wait(for: [XCTestExpectation(description: "fetchData")], timeout: 0.1)
        
        XCTAssertEqual(3, viewModel.products.count)
    }
}
