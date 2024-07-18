//
//  Transition.swift
//  crypto
//
//  Created by Kushal Patel on 6/17/24.
//

import SwiftUI

extension AnyTransition {
    static var slideInFromLeft: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .trailing)
        )
    }
}
