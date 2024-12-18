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
    
    // 添加状态来存储缩放比例、平移偏移以及增量缩放、增量拖动
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastScale: CGFloat = 1.0 // 用于保存最后的缩放比例
    @State private var lastOffset: CGSize = .zero // 用于保存最后的偏移量

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            // 使用LazyImage加载图片
            LazyImage(url: URL(string: imageURL)) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale) // 根据scale状态应用缩放
                        .offset(offset) // 根据offset应用平移
                        .gesture(
                            // 使用MagnificationGesture处理增量式双指缩放
                            MagnificationGesture()
                                .onChanged { value in
                                    // 增量式缩放：根据手势的缩放比例与上次缩放值相乘
                                    scale = lastScale * value.magnitude
                                }
                                .onEnded { value in
                                    // 手势结束时更新lastScale为当前缩放值
                                    lastScale = scale
                                }
                        )
                        .gesture(
                            // 使用DragGesture处理增量式拖动
                            DragGesture()
                                .onChanged { value in
                                    // 增量式拖动：根据拖动的增量更新偏移量
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                                .onEnded { value in
                                    // 在拖动结束时更新lastOffset为当前偏移量
                                    lastOffset = offset
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
