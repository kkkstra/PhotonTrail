//
//  PhotosView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI
import NukeUI

struct UserPhotosView: View {
    @ObservedObject var userPostsViewModel: UserPostsViewModel
    @State private var selectedPost: Post?
    @State private var selectedImage: String = ""
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let columns = [
                    GridItem(.flexible(), spacing: 1),
                    GridItem(.flexible(), spacing: 1),
                    GridItem(.flexible(), spacing: 1),
                    GridItem(.flexible(), spacing: 1)
                ]
                
                let length = geometry.size.width / 4 // 计算每个单元格的宽度和高度
                
                if userPostsViewModel.postList.isEmpty {
                    Text("还没有照片哦～")
                        .frame(width: geometry.size.width, alignment: .center)
                        .padding(.top, 10)
                } else {
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(userPostsViewModel.postList, id: \.id) { post in
                            ForEach(post.images, id: \.self) { image in
                                ZStack {
                                    LazyImage(url: URL(string: image.url)) { state in
                                        if let image = state.image {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: length - 1, height: length - 1)
                                                .clipped()
                                        } else {
                                            Color.gray
                                                .frame(width: length - 1, height: length - 1)
                                        }
                                    }
                                    .frame(width: length, height: length)
                                    
                                    Button(action: {
                                        selectedPost = post
                                        selectedImage = image.url
                                    }) {
                                        Color.clear
                                            .frame(width: length, height: length)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: calculateGridHeight())
        }
        .fullScreenCover(item: $selectedPost) { post in
            FullScreenImageDetailedView(imageURL: $selectedImage, post: $selectedPost)
        }
    }
    
    private func calculateGridHeight() -> CGFloat {
        let columns: CGFloat = 4
        let imageHeight = UIScreen.main.bounds.width / 4
        
        let totalImages = userPostsViewModel.postList.flatMap { $0.images }.count
        let rows = ceil(CGFloat(totalImages) / columns) // 计算需要多少行
        
        return rows * imageHeight + 100
    }
}

#Preview {
    UserPhotosView(userPostsViewModel: UserPostsViewModel())
}
