//
//  MineView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI
import NukeUI
import PhotosUI

enum ProfileTab: String, CaseIterable {
    case photos = "照片"
    case posts = "帖子"
}

struct MineView: View {
    @EnvironmentObject var modelData: ModelData
    
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
                        LazyImage(url: URL(string: modelData.user?.background ?? "")) { state in
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
                        imageUrl = modelData.user?.background ?? ""
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
                            LazyImage(url: URL(string: modelData.user?.avatar ?? "")) { state in
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
                                imageUrl = modelData.user?.avatar ?? ""
                                defaultImage = "defaultAvatar"
                                showImageFullScreen.toggle()
                            }) {
                                Color.clear
                            }
                            .frame(width: 100, height: 100)
                        }
                        
                        Text(modelData.user?.name ?? "")
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .frame(maxWidth: 200)
                    }
                    
                }
                .padding(.top, -60)
                
                Text("个人简介：" + (modelData.user?.description ?? ""))
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
                            userPostsViewModel.fetchData(userID: modelData.user?.id ?? 0)
                        })
                } else if selectedTab == .posts {
                    Text(userPostsViewModel.msg)
                    UserPostsView(userPostsViewModel: userPostsViewModel, enableEdit: true)
                        .onAppear(perform: {
                            userPostsViewModel.fetchData(userID: modelData.user?.id ?? 0)
                        })
                }
            }
            .ignoresSafeArea(.all)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        showProfile.toggle()
                    } label: {
                        Label("Edit Profile", systemImage: "gearshape")
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showProfile, content: { ProfileView(showProfile:$showProfile) })
            .fullScreenCover(isPresented: $showImageFullScreen, content: {
                FullScreenImageView(imageURL: $imageUrl, defaultImage: $defaultImage)
            })
            .refreshable(action: {
                userPostsViewModel.fetchData(userID: modelData.user?.id ?? 0)
            })
        }
    }
}


#Preview {
    let modelData = ModelData()
    MineView()
        .environmentObject(modelData)
}
