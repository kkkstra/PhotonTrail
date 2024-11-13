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
    
    @State private var selection: Tab = .home
    @State private var showAddNote = false
    
    var body: some View {
        ZStack{
            TabView(selection: $selection, content: {
                HomeView(postViewModel: postViewModel)
                    .tag(Tab.home)
                HomeView(postViewModel: postViewModel)
                    .tag(Tab.community)
                EmptyView()
                    .tag(Tab.add)
                HomeView(postViewModel: postViewModel)
                    .tag(Tab.notification)
                HomeView(postViewModel: postViewModel)
                    .tag(Tab.mine)
            })
            
            VStack{
                Spacer()
                CustomizeTabView(active: $selection, showAddNote: $showAddNote)
                    .background(.clear)
                    .contentShape(.rect)
                    .onTapGesture {
                        print("tap tab view")
                    }
            }
        }
    }
}

struct CustomizeTabView: View {
    @EnvironmentObject var modelData: ModelData
    
    @Binding var active: Tab
    @Binding var showAddNote: Bool
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 5), spacing: 0) {
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
            Rectangle()
                .foregroundStyle(.clear)
                .contentShape(.rect)
                .overlay{
                    Text("影集")
                        .font(active == .community ? .headline : .callout)
                        .bold()
                        .foregroundStyle(active == .community ? .primary : .secondary)
                        .padding(.vertical, 4)
                }
                .onTapGesture {
                    withAnimation{
                        active = .community
                    }
                }
            Rectangle()
                .foregroundStyle(.clear)
                .contentShape(.rect)
                .overlay{
                    Button(action: {
//                        if(modelData.user == nil){
//                            withAnimation{
//                                active = .note
//                            }
//                        }else{
//                            self.showAddNote = true
//                        }
                        self.showAddNote = true
                    }){
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 20)
                            .padding(10)
                            .foregroundStyle(.white)
                            .bold()
                            .background(.tabButton)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .tabShadow, radius: 8, x: 0, y: 4)
                        
                    }
                }
                .frame(minHeight: 42)
                .onTapGesture {
                    
                }
            Rectangle()
                .foregroundStyle(.clear)
                .contentShape(.rect)
                .overlay{
                    Text("通知")
                        .font(active == .notification ? .headline : .callout)
                        .bold()
                        .foregroundStyle(active == .notification ? .primary : .secondary)
                        .padding(.vertical, 4)
                }
                .onTapGesture {
                    withAnimation{
                        active = .notification
                    }
                }
            Rectangle()
                .foregroundStyle(.clear)
                .overlay{
                    Text("我")
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
