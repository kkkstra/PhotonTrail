//
//  MineView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI
import NukeUI

enum ProfileTab: String, CaseIterable {
    case photos = "照片"
    case albums = "影集"
}

struct MineView: View {
    @EnvironmentObject var modelData: ModelData
    
    @State private var selectedTab: ProfileTab = .photos
    @State private var showProfile = false
    @State private var isActionSheetPresented = false
    @State private var showImageFullScreen = false
    @State private var imageUrl: String = ""
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ZStack {
                    LazyImage(url: URL(string: modelData.user?.background ?? "")) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 400)
                        } else {
                            Image("defaultBg")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 400)
                        }
                    }
                    .frame(height: 400)
                    .padding(.top, -100)

                    Button(action: {
                        isActionSheetPresented.toggle()
                    }) {
                        Color.clear
                    }
                    .frame(height: 200)
                    .actionSheet(isPresented: $isActionSheetPresented) {
                        ActionSheet(
                            title: Text("操作"),
                            buttons: [
                                .default(Text("查看大图")) {
                                    imageUrl = modelData.user?.background ?? ""
                                    showImageFullScreen.toggle()
                                },
                                .default(Text("更换背景")) {
//                                    changeBackground()
                                },
                                .cancel(Text("取消"))
                            ]
                        )
                    }
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
                                showImageFullScreen.toggle()
                            }) {
                                Color.clear
                            }
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
                .padding(.horizontal, 150)
                
                if selectedTab == .photos {
                    PhotosView()
                        .padding(.horizontal, 48)
                } else if selectedTab == .albums {
                    Text("这里显示影集的内容")
                        .padding(.horizontal, 48)
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
            .sheet(isPresented: $showImageFullScreen) {
                FullScreenImageView(imageURL: $imageUrl, defaultImage: "defaultBg")
            }
        }
    }
}

#Preview {
    let modelData = ModelData()
    MineView()
        .environmentObject(modelData)
}
