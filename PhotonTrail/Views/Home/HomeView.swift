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
    
    @State private var loading = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack{
                    ForEach(postViewModel.postList, id: \.id, content: { post in
                        PostItem(post: post)
                            .onAppear(perform: {
                                if(post == postViewModel.postList.last) {
                                    loading = true
//                                    postViewModel.fetchMore()
                                }
                            })
                            .zIndex(15)
                    })
                }
                if(loading) {
                    ProgressView()
                        .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    HomeView(postViewModel: PostViewModel())
        .environmentObject(ModelData())
}
