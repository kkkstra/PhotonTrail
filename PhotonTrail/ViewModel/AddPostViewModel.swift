//
//  AddPostViewModel.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/12/16.
//

import Foundation
import UIKit
import Alamofire

class AddPostViewModel: ObservableObject {
    @Published var addPostLoading = false
    @Published var msg = ""
    @Published var progress = 0.0

    func addPost(title: String, content: String, images: [UIImage], camera: String, lens: String, completion: @escaping (Bool) -> Void) {
        addPostLoading = true
        var isSuccess = false
        
        // upload images
        getStsTokenThenUploadImages(imageList: images) { imageMetas in
            if let imageMetas = imageMetas {
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + GlobalParams.token
                ]
                
                var images: [[String: Any]] = []
                for (i, image) in imageMetas.enumerated() {
                    images.append([
                        "url": image.url,
                        "width": image.width,
                        "height": image.height,
                        "index": i,
                    ])
                }
                
                let parameters: [String: Any] = [
                    "title": title,
                    "content": content,
                    "camera": camera,
                    "lens": lens,
                    "images": images
                ]
                
                AF.request(Urls.POST, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: CreatePostResult.self) { response in
                        switch response.result {
                        case .success(let res):
                            self.msg = res.msg
                            isSuccess = true
                        case .failure(let error):
                            self.msg = error.errorDescription ?? "上传失败，请重试。"
                        }
                        completion(isSuccess)
                    }
            } else {
                self.msg = "上传失败，请重试。"
                completion(isSuccess)
            }
        }
    }
    
    private func uploadImage(tokenData: StsModel, image: UIImage, completion: @escaping (String?) -> Void){
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
    
    private func getStsTokenThenUploadImages(imageList: [UIImage], completion: @escaping ([ImageMeta]?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + GlobalParams.token
        ]
        
        var imageMetas: [ImageMeta] = []
        let dispatchGroup = DispatchGroup()

        AF.request(Urls.STS_TOKEN, headers: headers)
            .validate()
            .responseDecodable(of: StsResult.self) { response in
                switch response.result {
                case .success(let res):
                    if let sts = res.data?.sts {
                        for (i, image) in imageList.enumerated() {
                            dispatchGroup.enter()
                            self.uploadImage(tokenData: sts, image: image) { imageUrl in
                                if let url = imageUrl {
                                    imageMetas.append(ImageMeta(
                                        url: url,
                                        width: Int(image.size.width),
                                        height: Int(image.size.height),
                                        index: i
                                    ))
                                } else {
                                    dispatchGroup.leave()
                                    completion(nil)
                                    return
                                }
                                dispatchGroup.leave()
                            }
                        }
                        
                        dispatchGroup.notify(queue: .main) {
                            completion(imageMetas)
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
