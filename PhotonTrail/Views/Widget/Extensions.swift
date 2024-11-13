//
//  Extensions.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation
import SwiftUI

struct DismissKeyboardOnScrollModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        dismissKeyboard()
                    }
            )
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func dismissKeyboardOnScroll() -> some View {
        withAnimation{
            self.modifier(DismissKeyboardOnScrollModifier())
        }
    }
}
