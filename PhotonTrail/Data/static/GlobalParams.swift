//
//  GlobalParams.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/14.
//


import Foundation
class GlobalParams{
    static var token = ""
    static var tokenExpire = 0
    static var id: UInt64 = 0
    
    static func logout(){
        GlobalParams.token = ""
        GlobalParams.tokenExpire = 0
        GlobalParams.id = 0
    }
}
