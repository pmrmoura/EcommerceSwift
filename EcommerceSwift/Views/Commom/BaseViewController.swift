//
//  BaseViewController.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 09/02/23.
//

import UIKit

class BaseViewController: UIViewController {
    private lazy var activityIndicator = makeActivityIndicator()
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
    }
}

// MARK: - Setup view

extension BaseViewController {
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - Alert configuration

extension BaseViewController {
    func presentAlertController(alertInformation: AlertInformation) {
        let alert = UIAlertController(title: alertInformation.title, message: alertInformation.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertInformation.buttonText, style: .default))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Activity indicator configuration

extension BaseViewController {
    private func makeActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }
    
    func showLoading() {
        view.bringSubviewToFront(activityIndicator)
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
}
