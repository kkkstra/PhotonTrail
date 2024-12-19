//
//  PhotoItem.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI
import NukeUI

struct PostItem: View {
    var post: Post
    @State private var showFullImageScreen = false
    @State private var selectedImageURL: String = ""
    @State private var selectedImageIndex: Int = 0
    @State private var selectedPost: Post?
    @State private var navigateToUserView = false

    @StateObject var userViewModel = UserViewModel()
    @ObservedObject var userPostsViewModel: UserPostsViewModel
    var enableUserTap: Bool
    var enableEdit: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                NavigationLink(destination: UserView(userViewModel: userViewModel), isActive: $navigateToUserView) {
                    HStack {
                        LazyImage(url: URL(string: post.avatar)) { state in
                            if let image = state.image {
                                image.resizable()
                                    .scaledToFill()
                            } else {
                                Image("defaultAvatar")
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(post.name)
                                .font(.headline)
                                .foregroundColor(.primaryText)
                                .fontWeight(.medium)
                            
                            Text(post.getPublishedTime())
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                        }
                    }
                    .onTapGesture {
                        if enableUserTap {
                            userViewModel.fetchData(userID: post.user_id) {
                                navigateToUserView = true
                            }
                        }
                    }
                }

                Spacer()
                
                if enableEdit {
                    Menu {
                        Button(action: {
                            userViewModel.deletePost(postID: post.id) {
                                userPostsViewModel.fetchData(userID: userViewModel.user?.id ?? 0)
                            }
                        }) {
                            Label("删除", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .foregroundColor(.button3)
                    }
                }
            }
            .padding(.trailing)
            .padding(.leading)
            .padding(.top)
        }

        PhotoPageView(pages: post.images.map { image in
            LazyImage(url: URL(string: image.url)) { phase in
                phase.image?.resizable()
                    .scaledToFit()
                    .transition(.opacity.animation(.smooth))
                    .onTapGesture {
                        selectedImageURL = image.url
                        selectedPost = post
                        selectedImageIndex = image.index
                        showFullImageScreen.toggle()
                    }
            }
        })
        .frame(maxWidth: .infinity)
        .aspectRatio(max(CGFloat(post.images[0].width) / CGFloat(post.images[0].height + 1), 0.75), contentMode: .fill)
        .fullScreenCover(isPresented: $showFullImageScreen) {
            FullScreenImageDetailedView(post: $selectedPost, initialIndex: $selectedImageIndex)
        }
        
        VStack(alignment: .leading){
            if(!post.title.isEmpty){
                Text(post.title)
                    .font(.title3)
                    .padding(.bottom, 1)
            }
            if(!post.content.isEmpty){
                Text(post.content)
                    .font(.body)
//                    .padding(.bottom, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
        .padding(.leading)
        .padding(.trailing)
//        .padding(.bottom)
    }
}
