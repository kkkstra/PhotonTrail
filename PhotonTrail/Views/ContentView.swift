//
//  ContentView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI

enum Tab: String {
    case home
    case community
    case add
    case notification
    case mine
}

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData

    @StateObject private var postViewModel = PostViewModel()
    @StateObject private var addPostViewModel = AddPostViewModel()
    
    @State private var selection: Tab = .home
    @State private var showAddPost = false
    
    var body: some View {
        ZStack{            
            TabView(selection: $selection, content:  {
                HomeView(postViewModel: postViewModel)
                    .tag(Tab.home)
//                CommunityView()
//                    .tag(Tab.community)
                EmptyView()
                    .tag(Tab.add)
//                NotifyView()
//                    .tag(Tab.notification)
                MineView()
                    .tag(Tab.mine)
            })
            
            VStack{
                Spacer()
                CustomizeTabView(active: $selection, showAddPost: $showAddPost)
                    .background(.clear)
                    .contentShape(.rect)
                    .padding(.horizontal, 24)
            }
            
            if modelData.user == nil {
                Color.gray.ignoresSafeArea()
                LoginView()
                    .onDisappear{
                        if modelData.user != nil {
                            postViewModel.fetchFirst()
                        }
                    }
            }
        }
        .sheet(isPresented: $showAddPost, content: {
            AddPostView(showAddPost:$showAddPost, addPostViewModel: addPostViewModel)
                .environmentObject(modelData)
                .onDisappear(perform: {
                    postViewModel.fetchFirst()
                })
        })
    }
}

struct CustomizeTabView: View {
    @EnvironmentObject var modelData: ModelData
    
    @Binding var active: Tab
    @Binding var showAddPost: Bool
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
            Rectangle()
                .foregroundStyle(.clear)
                .contentShape(.rect)
                .overlay{
                    Text("首页")
                        .font(active == .home ? .headline : .callout)
                        .bold()
                        .foregroundStyle(active == .home ? .primary : .secondary)
                        .padding(.vertical, 4)
                }
                .onTapGesture {
                    withAnimation{
                        active = .home
                    }
                }
//            Rectangle()
//                .foregroundStyle(.clear)
//                .contentShape(.rect)
//                .overlay{
//                    Text("影集")
//                        .font(active == .community ? .headline : .callout)
//                        .bold()
//                        .foregroundStyle(active == .community ? .primary : .secondary)
//                        .padding(.vertical, 4)
//                }
//                .onTapGesture {
//                    withAnimation{
//                        active = .community
//                    }
//                }
            Rectangle()
                .foregroundStyle(.clear)
                .contentShape(.rect)
                .overlay{
                    Button(action: {
                        if(modelData.user == nil){
                            withAnimation{
                                active = .mine
                            }
                        }else{
                            self.showAddPost = true
                        }
                    }){
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 20)
                            .padding(10)
                            .foregroundStyle(.white)
                            .bold()
                            .background(.button)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .tabShadow, radius: 8, x: 0, y: 4)
                        
                    }
                }
                .frame(minHeight: 42)
                .onTapGesture {
                    
                }
//            Rectangle()
//                .foregroundStyle(.clear)
//                .contentShape(.rect)
//                .overlay{
//                    Text("通知")
//                        .font(active == .notification ? .headline : .callout)
//                        .bold()
//                        .foregroundStyle(active == .notification ? .primary : .secondary)
//                        .padding(.vertical, 4)
//                }
//                .onTapGesture {
//                    withAnimation{
//                        active = .notification
//                    }
//                }
            Rectangle()
                .foregroundStyle(.clear)
                .overlay{
                    Text("我的")
                        .font(active == .mine ? .headline : .callout)
                        .bold()
                        .foregroundStyle(active == .mine ? .primary : .secondary)
                }
                .padding(.vertical, 4)
                .onTapGesture {
                    withAnimation{
                        active = .mine
                    }
                }
        }
    }
}

#Preview {
    let modelData = ModelData()
    ContentView()
        .environmentObject(modelData)
}
