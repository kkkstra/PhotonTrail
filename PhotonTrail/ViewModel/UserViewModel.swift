//
//  PhotoViewModel.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation
import Alamofire

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var msg: String = ""
    
    func fetchData(userID: UInt64, completion: @escaping () -> Void) {
        let url = String(format: Urls.PROFILE, userID)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + GlobalParams.token
        ]
        
        let group = DispatchGroup()
        group.enter()
        
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: UpdateProfileResult.self) { response in
                switch response.result {
                case .success(let res):
                    if let profile = res.data?.profile {
                        self.user = profile
                    }
                case .failure(let error):
                    self.msg = error.errorDescription ?? "获取数据失败"
                }
                
                group.leave()
            }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func deletePost(postID: UInt64, completion: @escaping () -> Void) {
        let url = String(format: Urls.POST_ID, postID)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + GlobalParams.token
        ]
        
        let group = DispatchGroup()
        group.enter()
        
        AF.request(url, method: .delete , headers: headers)
            .validate()
            .responseDecodable(of: DeletePostResult.self) { response in
                switch response.result {
                case .success(_):
                    self.msg = "删除成功"
                case .failure(let error):
                    self.msg = error.errorDescription ?? "获取数据失败"
                }
                
                group.leave()
            }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}
