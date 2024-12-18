//
//  FullScreenImageView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/12/16.
//

import SwiftUI
import NukeUI

struct FullScreenImageView: View {
    @Binding var imageURL: String
    @Binding var defaultImage: String
    @Environment(\.presentationMode) var presentationMode
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastScale: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            LazyImage(url: URL(string: imageURL)) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = lastScale * value.magnitude
                                }
                                .onEnded { value in
                                    lastScale = scale
                                }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    withAnimation(.interactiveSpring()) {
                                        offset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                    }
                                }
                                .onEnded { value in
                                    withAnimation(.interactiveSpring()) {
                                        withAnimation(.bouncy()) {
                                            lastOffset = offset
                                        }
                                    }
                                }
                        )
                } else {
                    Image(defaultImage)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        scale = 1.0
                        offset = .zero
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}
