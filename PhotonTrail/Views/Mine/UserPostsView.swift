//
//  HomeView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/12/18.
//

import SwiftUI


struct UserPostsView: View {
    @ObservedObject var userPostsViewModel: UserPostsViewModel
    @State var enableEdit: Bool = false

    var body: some View {
//            if userPostsViewModel.postList.isEmpty {
//                Text("还没有照片哦～")
//                    .frame(width: geometry.size.width, alignment: .center)
//                    .padding(.top, 10)
//            }
            
            ScrollView {
                LazyVStack {
                    ForEach(userPostsViewModel.postList, id: \.id, content: { post in
                        PostItem(post: post, userPostsViewModel: userPostsViewModel, enableUserTap: false, enableEdit: enableEdit)
                            .zIndex(15)
                    })
                }
                
                Text("")
                    .frame(height: 100)
            }
        }
}

#Preview {
    UserPostsView(userPostsViewModel: UserPostsViewModel())
}
