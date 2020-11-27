//
//  IfViewModifier.swift
//  PocNavegacao3
//
//  Created by Lucas Claro on 09/11/20.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        }
        else {
            self
        }
    }
}
