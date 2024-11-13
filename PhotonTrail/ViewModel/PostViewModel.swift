//
//  PhotoViewModel.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var postList = [Post]()
    
    init() {
        postList.append(Post(id: 1))
        postList.append(Post(id: 2))
        postList.append(Post(id: 3))
        postList.append(Post(id: 4))
        postList.append(Post(id: 5))
        postList.append(Post(id: 6))
    }
}
