//
//  CheckoutViewController.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 02/02/23.
//

import UIKit
import Combine

final class CheckoutViewController: BaseViewController {
    // MARK: - Private properties
    private typealias CellType = CheckoutViewModel.CellType
    
    private lazy var dataSource = makeDiffableDataSource()
    
    private lazy var tableViewController = makeTableViewController()
    private var tableView: UITableView {
        tableViewController.tableView
    }
    
    private var cancelBag = Set<AnyCancellable>()
    
    private let viewModel: CheckoutViewModel
    
    required init(viewModel: CheckoutViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupView()
        setupTableViewSnapshotBinding()
        viewModel.makeCells()
    }
}

// MARK: - Setup

extension CheckoutViewController {
    private func setupView() {
        view.backgroundColor = .white
        
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupViewHierarchy() {
        addChild(tableViewController)
        tableViewController.didMove(toParent: self)
        tableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableViewController.view)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func registerCells() {
        tableView.registerCell(cellClass: ProductTableViewCell.self)
        tableView.registerCell(cellClass: PriceTableViewCell.self)
    }
}

// MARK: - Cells

extension CheckoutViewController {
    private func cellForType(_ type: CellType, forIndexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .product(let viewModel):
            return cellForProductTableViewCellViewModel(viewModel: viewModel, forIndexPath: forIndexPath)
        case .price(let viewModel):
            return cellForPriceTableViewCellViewModel(viewModel: viewModel, forIndexPath: forIndexPath)
        }
    }
}

// MARK: - Cell configuration

extension CheckoutViewController {
    private func cellForProductTableViewCellViewModel(viewModel: ProductTableViewCellViewModel, forIndexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: ProductTableViewCell.self, indexPath: forIndexPath)
        cell.render(viewModel: viewModel)
        return cell
    }
    
    private func cellForPriceTableViewCellViewModel(viewModel: PriceTableViewCellViewModel, forIndexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: PriceTableViewCell.self, indexPath: forIndexPath)
        cell.render(viewModel: viewModel)
        return cell
    }
}

// MARK: - Bindings

extension CheckoutViewController {
    private func setupTableViewSnapshotBinding() {
        viewModel.snapshot
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .store(in: &cancelBag)
    }
}

// MARK: - Setup UI Components

extension CheckoutViewController {
    private func makeTableViewController() -> UITableViewController {
        let controller = UITableViewController(nibName: nil, bundle: nil)
        controller.tableView.rowHeight = UITableView.automaticDimension
        controller.tableView.estimatedRowHeight = UITableView.automaticDimension
        controller.tableView.separatorStyle = .none
        return controller
    }
    
    private func makeDiffableDataSource() -> UITableViewDiffableDataSource<CheckoutViewModel.Section, CellType> {
        return UITableViewDiffableDataSource(tableView: tableView) { [weak self] _, indexPath, cellType in
            self?.cellForType(cellType, forIndexPath: indexPath)
        }
    }
}
