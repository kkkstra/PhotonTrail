//
//  MineView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI
import NukeUI
import PhotosUI

struct UserView: View {
    @ObservedObject var userViewModel: UserViewModel
    @StateObject var userPostsViewModel = UserPostsViewModel()
    
    @State private var selectedTab: ProfileTab = .photos
    @State private var showProfile = false
    @State private var isActionSheetPresented = false
    @State private var showImageFullScreen = false
    @State private var imageUrl: String = ""
    @State private var defaultImage: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    GeometryReader { geometry in
                        LazyImage(url: URL(string: userViewModel.user?.background ?? "")) { state in
                            if let image = state.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: 400)
                            } else {
                                Image("defaultBg")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: 400)
                            }
                        }
                    }
                    .frame(height: 400)
                    .padding(.top, -100)
                    
                    Button(action: {
                        imageUrl = userViewModel.user?.background ?? ""
                        defaultImage = "defaultBg"
                        showImageFullScreen.toggle()
                    }) {
                        Color.clear
                    }
                    .frame(height: 200)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    VStack (alignment: .center) {
                        ZStack {
                            LazyImage(url: URL(string: userViewModel.user?.avatar ?? "")) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                } else {
                                    Image("defaultAvatar")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                }
                            }
                            .frame(width: 100, height: 100)
                            
                            Button(action: {
                                imageUrl = userViewModel.user?.avatar ?? ""
                                defaultImage = "defaultAvatar"
                                showImageFullScreen.toggle()
                            }) {
                                Color.clear
                            }
                            .frame(width: 100, height: 100)
                        }
                        
                        Text(userViewModel.user?.name ?? "")
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .frame(maxWidth: 200)
                    }
                    
                }
                .padding(.top, -60)
                
                Text("个人简介：" + (userViewModel.user?.description ?? ""))
                    .font(.callout)
                    .frame(maxWidth: 350, alignment: .leading)
                //                    .lineLimit(3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 1)
                
                Picker("select views", selection: $selectedTab) {
                    ForEach(ProfileTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 20)
                .padding(.horizontal, 100)
                
                if selectedTab == .photos {
                    Text(userPostsViewModel.msg)
                    UserPhotosView(userPostsViewModel: userPostsViewModel)
                        .onAppear(perform: {
                            userPostsViewModel.fetchData(userID: userViewModel.user?.id ?? 0)
                        })
                } else if selectedTab == .posts {
                    Text(userPostsViewModel.msg)
                    UserPostsView(userPostsViewModel: userPostsViewModel, enableEdit: false)
                        .onAppear(perform: {
                            userPostsViewModel.fetchData(userID: userViewModel.user?.id ?? 0)
                        })
                }
            }
            .ignoresSafeArea(.all)
//            .toolbarBackground(.hidden, for: .navigationBar)
//            .toolbarColorScheme(.dark, for: .navigationBar)
            .fullScreenCover(isPresented: $showImageFullScreen, content: {
                FullScreenImageView(imageURL: $imageUrl, defaultImage: $defaultImage)
            })
        }
        .navigationTitle(userViewModel.user?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

