//
//  UITableViewCell.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 03/02/23.
//

import UIKit

public extension UITableViewCell {
    
    /** Return identifier with the same name of the subclass */
    static var defaultIdentifier: String {
        return String(describing: self)
    }
}

