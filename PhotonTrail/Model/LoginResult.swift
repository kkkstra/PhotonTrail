//
//  LoginResult.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation

struct LoginResult: Codable {
    var code: Int?
    var error: String?
    var user: User?
    var token = ""
    var tokenExpires = 0
}
