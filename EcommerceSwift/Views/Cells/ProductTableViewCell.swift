//
//  ProductTableViewCell.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 03/02/23.
//

import UIKit
import Combine

final class ProductTableViewCell: UITableViewCell {
    private var viewModel: ProductTableViewCellViewModel?
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var priceLabel = makePriceLabel()
    private lazy var quantityStepperView = makeStepperView()
    private lazy var quantityLabel = makeQuantityLabel()
}

// MARK: - Setup

extension ProductTableViewCell {
    private func setupView() {
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        selectionStyle = .none
        
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityLabel)

        if viewModel?.productCellType == .home {
            contentView.addSubview(quantityStepperView)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            quantityLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 4),
            quantityLabel.trailingAnchor.constraint(equalTo: viewModel?.productCellType == .home ? quantityStepperView.leadingAnchor : contentView.trailingAnchor, constant: -24)
        ])
        
        if viewModel?.productCellType == .home {
            NSLayoutConstraint.activate([
                quantityStepperView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
                quantityStepperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ])
        }
    }
    
    private func setupBindings() {
        viewModel?.product
            .sink(receiveValue: { [weak self] product in
                self?.titleLabel.text = product.name
                self?.priceLabel.text = "$\(product.price)"
            })
            .store(in: &cancelBag)
        
        viewModel?.productCount
            .sink(receiveValue: { [weak self] number in
                self?.quantityLabel.text = "\(number)"
            })
            .store(in: &cancelBag)
    }
}

// MARK: - Setup UI Elements

extension ProductTableViewCell {
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    private func makePriceLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeQuantityLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        return label
    }
    
    private func makeStepperView() -> UIStepper {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return stepper
    }
}

// MARK: - Actions

extension ProductTableViewCell {
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        viewModel?.handleStepperClicked(value: sender.value)
    }
}

// MARK: - Render

extension ProductTableViewCell {
    func render(viewModel: ProductTableViewCellViewModel) {
        guard viewModel !== self.viewModel else { return }
        self.viewModel = viewModel
        
        cancelBag = Set<AnyCancellable>()
        setupBindings()
        setupView()
    }
}
