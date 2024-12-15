//
//  LoginResult.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation

struct LoginResult: Codable {
    var code: Int
    var data: Data?
    var error: String?
    var msg: String
    
    struct Data: Codable {
        var id: Int
        var role: Int
        var token: String
        var expire: Int
        var profile: User
    }
}

struct RegisterResult: Codable {
    var code: Int
    var data: Data?
    var error: String?
    var msg: String
    
    struct Data: Codable {
        var id: Int
    }
}

struct UpdateProfileResult: Codable {
    var code: Int
    var data: Data?
    var error: String?
    var msg: String
    
    struct Data: Codable {
        var profile: User
    }
}

struct StsResult: Codable {
    var code: Int
    var data: Data?
    var error: String?
    var msg: String
    
    struct Data: Codable {
        var sts: StsModel
    }
}

struct StsModel: Codable {
    var dir: String
    var host: String
    var policy: String
    var security_token: String
    var signature: String
    var x_oss_credential: String
    var x_oss_date: String
    var x_oss_signature_version: String
}
