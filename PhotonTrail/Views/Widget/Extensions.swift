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

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        // Use the correct scale factor for the current screen
        let rendererFormat = UIGraphicsImageRendererFormat.default() // 3:1
        rendererFormat.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: rendererFormat)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
