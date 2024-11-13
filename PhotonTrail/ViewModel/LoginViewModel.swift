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
        let res = LoginResult(
            code: 0,
            user: User(
                id: 1,
                name: "Patrick Lai",
                email: "yuxin.lai@hust.edu.cn",
                avatar: "https://kkkstra.cn/assets/img/logo4.jpg",
                description: "Hello, world!",
                background: "https://icemono.oss-cn-hangzhou.aliyuncs.com/images/denis-istomin-kaspa2.jpg")
        )
        self.modelData?.saveLoginData(res: res)
    }
    
    func register(mail: String, password: String) {
    }
}
