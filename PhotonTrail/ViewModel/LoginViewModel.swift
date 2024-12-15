//
//  LoginVM.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation
import Combine
import Alamofire

class LoginViewModel: ObservableObject {
    private var modelData: ModelData?
    @Published var error: AFError?
    @Published var loginLoading = false
    @Published var registerLoading = false
    @Published var errorMsg = ""
    @Published var usePassword = false
    @Published var isRegister = false
    
    func initData(modelData: ModelData) {
        if(self.modelData == nil) {
            self.modelData = modelData
        }
    }
    
    func login(mail: String, password: String) {
        self.loginLoading = true
        self.errorMsg = ""
        let parameters: [String: Any] = [
            "email": mail,
            "password": password
        ]
        
        AF.request(Urls.LOGIN, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LoginResult.self) { response in
                self.loginLoading = false
                switch response.result {
                case .success(let res):
                    if (res.data != nil) {
                        GlobalParams.token = res.data?.token ?? ""
                        GlobalParams.tokenExpire = res.data?.expire ?? 0
                        
                        self.modelData?.saveLoginData(res: res)
                    }
                    self.errorMsg = res.msg
                case .failure(let error):
                    self.error = error
                    self.errorMsg = error.errorDescription ?? "登录遇到了一点小问题，请重试。"
                }
            }
    }
    
    func register(mail: String, password: String) {
        self.registerLoading = true
        self.errorMsg = ""
        let parameters: [String: Any] = [
            "email": mail,
            "password": password
        ]
        
        AF.request(Urls.REGISTER, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RegisterResult.self) { response in
                self.registerLoading = false
                switch response.result {
                case .success(let res):
                    self.errorMsg = res.msg
                case .failure(let error):
                    self.error = error
                    self.errorMsg = error.errorDescription ?? "登录遇到了一点小问题，请重试。"
                }
            }
    }
}
