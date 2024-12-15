//
//  Urls.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/14.
//

import Foundation

class Urls{
    private static let BASE_URL = "http://localhost:8011/api/v1"

    
    static let REGISTER = BASE_URL + "/user"
    static let LOGIN = BASE_URL + "/session"
    static let PROFILE = BASE_URL + "/user/%d/profile"
 
    static let STS_TOKEN = BASE_URL + "/sts"
}
