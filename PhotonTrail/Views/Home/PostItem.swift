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
    @State private var selectedPost: Post?
    @State private var navigateToUserView = false

    @StateObject var userViewModel = UserViewModel()
    @ObservedObject var userPostsViewModel: UserPostsViewModel
    var enableUserTap: Bool
    var enableEdit: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                NavigationLink(destination: UserView(userViewModel: userViewModel), isActive: $navigateToUserView) {
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
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    .onTapGesture {
                        if enableUserTap {
                            userViewModel.fetchData(userID: post.user_id) {
                                navigateToUserView = true
                            }
                        }
                    }
                }
                
                Text(post.name)
                    .font(.headline)
                    .fontWeight(.medium)

                Spacer()
                
                Text(post.getPublishedTime())
                    .font(.subheadline)
                
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
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
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
                        showFullImageScreen.toggle()
                    }
            }
        })
        .frame(maxWidth: .infinity)
        .aspectRatio(max(CGFloat(post.images[0].width) / CGFloat(post.images[0].height + 1), 1), contentMode: .fill)
        .fullScreenCover(isPresented: $showFullImageScreen) {
            FullScreenImageDetailedView(imageURL: $selectedImageURL, post: $selectedPost)
        }
        
        VStack(alignment: .leading){
            if(!post.title.isEmpty){
                Text(post.title)
                    .font(.title3)
                    .padding(.bottom, 4)
            }
            if(!post.content.isEmpty){
                Text(post.content)
                    .font(.body)
                    .padding(.bottom, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 6)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
    }
}
