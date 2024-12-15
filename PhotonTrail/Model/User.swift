//
//  UserModel.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation

struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
    let role: Int
    var avatar: String?
    var description: String?
    var background: String?
}
