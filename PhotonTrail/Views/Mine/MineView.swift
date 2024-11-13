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
    
    var body: some View {
        NavigationStack{
            ScrollView{
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
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    VStack (alignment: .center) {
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
                        
                        Text(modelData.user?.name ?? "用户名")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    Text(modelData.user?.description ?? "个人简介")
                        .lineLimit(2)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 64)
                .padding(.top, -60)
                
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
                    Text("这里显示帖子的内容")
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
        }
    }
}

#Preview {
    let modelData = ModelData()
    MineView()
        .environmentObject(modelData)
}
