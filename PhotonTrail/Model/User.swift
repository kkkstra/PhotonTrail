//
//  UserModel.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation

struct User: Identifiable, Codable{
    let id: Int
    var name: String?
    var avatar: String?
    let mail: String
    var description: String?
}
