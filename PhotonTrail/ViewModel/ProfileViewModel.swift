//
//  ProfileViewModel.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/14.
//

import Foundation
import Alamofire
import UIKit

class ProfileViewModel: ObservableObject {
    private var modelData: ModelData?
    @Published var success = false
    @Published var msg = ""
    @Published var progress = 0.0
    
    func initData(modelData: ModelData) {
        if(self.modelData == nil) {
            self.modelData = modelData
        }
    }
    
    func updateProfile(name: String, description: String, image: UIImage?) {
        self.msg = ""
        self.success = false

        // update avatar if exist
        if let image = image {
            getStsTokenThenUploadImages(image: image) { imageUrl in
                if let url = imageUrl {
                    self.uploadProfile(name: name, description: description, avatar: url)
                } else {
                    self.msg = "上传头像时遇到了一点小问题，请重试。"
                }
            }
        } else {
            uploadProfile(name: name, description: description, avatar: modelData?.user?.avatar ?? "")
        }
    }
    
    private func uploadProfile(name: String, description: String, avatar: String) {
        // update profile
        let parameters: [String: Any] = [
            "name": name,
            "description": description,
            "avatar": avatar,
            "background": modelData?.user?.background ?? ""
        ]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + GlobalParams.token
        ]
        
        AF.request(String(format: Urls.PROFILE, modelData?.user?.id ?? 0), method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UpdateProfileResult.self) { response in
                switch response.result {
                case .success(let res):
                    self.msg = res.msg
                    if res.data != nil {
                        self.success = true
                        self.modelData?.updateUserData(res: res)
                    }
                case .failure(let error):
                    self.msg = error.errorDescription ?? "遇到了一点小问题，请重试。"
                }
            }
    }
    
    private func uploadImages(tokenData: StsModel, image: UIImage, completion: @escaping (String?) -> Void){
        let dispatchGroup = DispatchGroup()
        var imageUrl: String?

        dispatchGroup.enter()
        let resizedImage = image.aspectFittedToHeight(1440)
        let imageData = resizedImage.jpegData(compressionQuality: 0.3)!
        print("\(image) size: \(imageData.count)")
        
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
        ]
        
        let imageName="\(UUID().uuidString).jpg"
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("200".data(using: .utf8)!, withName: "success_action_status")
            multipartFormData.append(tokenData.policy.data(using: .utf8)!, withName: "policy")
            multipartFormData.append(tokenData.signature.data(using: .utf8)!, withName: "x-oss-signature")
            multipartFormData.append(tokenData.x_oss_signature_version.data(using: .utf8)!, withName: "x-oss-signature-version")
            multipartFormData.append(tokenData.x_oss_credential.data(using: .utf8)!, withName: "x-oss-credential")
            multipartFormData.append(tokenData.x_oss_date.data(using: .utf8)!, withName: "x-oss-date")
            multipartFormData.append("\(tokenData.dir)\(imageName)".data(using: .utf8)!, withName: "key")
            multipartFormData.append(tokenData.security_token.data(using: .utf8)!, withName: "x-oss-security-token")
            multipartFormData.append(imageData, withName: "file", fileName: imageName, mimeType: "image/jpeg")
        }, to: tokenData.host, method: .post, headers: headers)
        .uploadProgress { progress in
            self.progress = progress.fractionCompleted * 0.9
        }
        .responseString(emptyResponseCodes: [200], completionHandler: { response in
            switch(response.result) {
            case .success(let res):
                if(res.isEmpty) {
                    imageUrl = tokenData.host + "/" + tokenData.dir + imageName
                }
            case .failure(let error):
                print("uploadImage error: \(error)")
            }
            dispatchGroup.leave()
        })

        dispatchGroup.notify(queue: .main) {
            completion(imageUrl)
        }
    }
    
    private func getStsTokenThenUploadImages(image: UIImage, completion: @escaping (String?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + GlobalParams.token
        ]
        AF.request(Urls.STS_TOKEN, headers: headers)
            .validate()
            .responseDecodable(of: StsResult.self) { response in
                switch response.result {
                case .success(let res):
                    if let sts = res.data?.sts {
                        self.uploadImages(tokenData: sts, image: image) { imageUrl in
                            completion(imageUrl) // 回调返回上传后的 URL
                        }
                    } else {
                        self.msg = "登录信息已过期，请重新登录"
                        completion(nil)
                    }
                case .failure(let error):
                    self.msg = error.errorDescription ?? "获取STS失败"
                    completion(nil)
                }
            }
    }
}
