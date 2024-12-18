//
//  PhotoViewModel.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation
import Alamofire

class UserPostsViewModel: ObservableObject {
    @Published var postList = [Post]()
    @Published var msg: String = ""
    
    func fetchData(userID: UInt64) {
        let url = String(format: Urls.USER_POSTS, userID)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + GlobalParams.token
        ]
        
//        let group = DispatchGroup()
//        group.enter()
        
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: GetPostsResult.self) { response in
                switch response.result {
                case .success(let posts):
                    if let newPosts = posts.data?.posts {
                        self.postList = newPosts
                    }
                    self.msg = ""
                case .failure(let error):
                    self.msg = error.errorDescription ?? "获取数据失败"
//                    print(error.errorDescription ?? "")
//                    self.msg = "没有更多数据了"
                }
//                group.leave()
            }
        
//        group.notify(queue: .main) {
//            completion()
//        }
    }
}
