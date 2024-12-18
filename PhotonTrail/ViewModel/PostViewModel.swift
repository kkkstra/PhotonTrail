//
//  PhotoViewModel.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation
import Alamofire

class PostViewModel: ObservableObject {
    @Published var postList = [Post]()
    @Published var error: AFError?
    @Published var curPostCount: Int = 0
    private var page = 1
    private let pageSize = 10
    
    func fetchFirst(){
        self.page = 1
        self.postList = []
        self.error = nil
        fetchPost()
    }
    
    func fetchMore(){
        self.error = nil
        self.page += 1
        fetchPost()
    }
    
    private func fetchPost() {
        let url = "\(Urls.POST)?page=\(self.page)&page_size=\(self.pageSize)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + GlobalParams.token
        ]
        
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: GetPostsResult.self) { response in
                switch response.result {
                case .success(let posts):
                    if let newPosts = posts.data?.posts {
                        self.postList.append(contentsOf: newPosts)
                        self.curPostCount = posts.data?.total ?? 0
                    }
                    self.curPostCount = 0
                case .failure(let error):
                    self.error = error
                    self.page -= 1
                    self.curPostCount = 0
                    print("Request failed with error: \(error)")
                }
            }
    }
}
