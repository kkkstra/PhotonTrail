//
//  ModelData.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation

class ModelData: ObservableObject {
    @Published var user: User?
    
    init() {
        if let loginData = UserDefaults.standard.data(forKey: DataKeys.LOGIN_RESULT) {
            if let loginResult = try? JSONDecoder().decode(LoginResult.self, from: loginData) {
                // 校验token是否过期
                let expires = loginResult.data?.expire ?? 0
                let timestampAfter6h = Int(Date().timeIntervalSince1970) +  6 * 60 * 60
                if(timestampAfter6h < expires){
                    self.user = loginResult.data?.profile
                    GlobalParams.token = loginResult.data?.token ?? ""
                    GlobalParams.tokenExpire = loginResult.data?.expire ?? 0
                }
            }
        }
    }
    
    func saveLoginData(res: LoginResult){
        self.user = res.data?.profile
        if let encoded = try? JSONEncoder().encode(res) {
            UserDefaults.standard.set(encoded, forKey: DataKeys.LOGIN_RESULT)
        }
        if let encoded = try? JSONEncoder().encode(res.data?.profile.email) {
            UserDefaults.standard.set(encoded, forKey: DataKeys.LAST_LOGIN_EMAIL)
        }
    }
    
    func updateUserData(res: UpdateProfileResult) {
        self.user = res.data?.profile
        if let loginData = UserDefaults.standard.data(forKey: DataKeys.LOGIN_RESULT) {
            if var loginResult = try? JSONDecoder().decode(LoginResult.self, from: loginData) {
                if let profile = res.data?.profile {
                    loginResult.data?.profile = profile
                    
                    if let updatedData = try? JSONEncoder().encode(loginResult) {
                        UserDefaults.standard.set(updatedData, forKey: DataKeys.LOGIN_RESULT)
                    }
                }
            }
        }
    }
}
