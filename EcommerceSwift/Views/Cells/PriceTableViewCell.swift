//
//  PriceTableViewCell.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 08/02/23.
//

import UIKit
import Combine

final class PriceTableViewCell: UITableViewCell {
    private var viewModel: PriceTableViewCellViewModel?
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var priceLabel = makePriceLabel()
    private lazy var separatorView = makeSeparatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Constants {
        static let totalTitle = "Total"
        static let subtotalTitle = "Subtotal"
        static let discountTitle = "Discount"
    }
}

// MARK: - Setup

extension PriceTableViewCell {
    private func setupView() {
        selectionStyle = .none
        
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(separatorView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupBindings() {
        viewModel?.priceType
            .sink(receiveValue: { [weak self] priceType in
                switch priceType {
                case .total(let price):
                    self?.titleLabel.text = Constants.totalTitle
                    self?.priceLabel.text = "$\(price)"
                case .subtotal(let price):
                    self?.titleLabel.text = Constants.subtotalTitle
                    self?.priceLabel.text = "$\(price)"
                case .discount(let price):
                    self?.titleLabel.text = Constants.discountTitle
                    self?.priceLabel.text = "$\(price)"
                }
            })
            .store(in: &cancelBag)
    }
}

// MARK: - Setup UI Elements

extension PriceTableViewCell {
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makePriceLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeSeparatorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }
}

// MARK: - Render

extension PriceTableViewCell {
    func render(viewModel: PriceTableViewCellViewModel) {
        guard viewModel !== self.viewModel else { return }
        self.viewModel = viewModel
        
        cancelBag = Set<AnyCancellable>()
        setupBindings()
    }
}
