//
//  ViewModelHashable.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 03/02/23.
//

class ViewModelHashable: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: ViewModelHashable, rhs: ViewModelHashable) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
