//
//  Urls.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/14.
//

import Foundation

class Urls{
//    private static let BASE_URL = "http://localhost:8211/api/v1"
    private static let BASE_URL = "https://api.pt.kkkstra.cn/api/v1"

    
    static let REGISTER = BASE_URL + "/user"
    static let LOGIN = BASE_URL + "/session"
    static let PROFILE = BASE_URL + "/user/%d/profile"
    static let USER_POSTS = BASE_URL + "/user/%d/posts"
 
    static let STS_TOKEN = BASE_URL + "/sts"
    
    static let POST = BASE_URL + "/post"
    static let POST_ID = BASE_URL + "/post/%d"
}
