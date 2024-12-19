//
//  FullScreenImageView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/12/16.
//

import SwiftUI
import NukeUI

struct FullScreenImageDetailedView: View {
    @Binding var imageURL: String
    @Binding var post: Post?
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
                                        lastOffset = offset
                                    }
                                }
                        )
                } else {
                    Image(systemName: "photo.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
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
                
                VStack(alignment: .leading) {
                    Text(post?.title ?? "")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding(.bottom, 2)
                    
                    Text(post?.content ?? "")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .padding(.bottom, 8)
                    
                    Divider()
                            .background(Color.white)
                            .padding(.bottom, 2)
                    
                    HStack(alignment: .center, spacing: 40) {
                        HStack {
                            Image(systemName: "camera")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            Text(post?.camera ?? "N/A")
                                .foregroundColor(.white)
                                .font(.caption2)
                        }
                        
                        HStack {
                            Image(systemName: "circle.dotted.circle")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            Text(post?.lens ?? "N/A")
                                .foregroundColor(.white)
                                .font(.caption2)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(BlurView(style: .systemUltraThinMaterialDark))
                .cornerRadius(10)
                .padding()
            }
        }
    }
}
