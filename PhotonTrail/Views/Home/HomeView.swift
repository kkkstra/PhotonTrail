//
//  HomeView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var postViewModel: PostViewModel
        
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(postViewModel.postList, id: \.id, content: { post in
                        PostItem(post: post, userPostsViewModel: UserPostsViewModel(), enableUserTap: true, enableEdit: false)
                            .onAppear(perform: {
                                if(post == postViewModel.postList.last) {
                                     postViewModel.fetchMore()
                                }
                            })
                            .zIndex(15)
                    })
                }
                if postViewModel.curPostCount == 0 {
                    Text("没有更多了")
                } else {
                    ProgressView()
                        .padding(.bottom)
                }
            }
            .onAppear {
                if(postViewModel.postList.isEmpty) {
                    postViewModel.fetchFirst()
                }
            }
            .refreshable {
                postViewModel.fetchFirst()
            }
            .navigationTitle("光迹")
        }
    }
}

#Preview {
    HomeView(postViewModel: PostViewModel())
        .environmentObject(ModelData())
}
