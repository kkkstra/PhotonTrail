//
//  Post.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation

struct Post: Codable, Hashable, Identifiable {
    var id: UInt64
    var avatar: String
    var name: String
    var published_at: String
    var images: [Image]
    var title: String
    var content: String
    
    struct Image: Codable, Hashable{
        let imageUrl: String
        let width: Int
        let height: Int
    }
    
    init(id: UInt64) {
        self.id = id
        self.avatar = "https://kkkstra.cn/assets/img/logo4.jpg"
        self.name = "kkkstra"
        self.published_at = "2024-11-12 16:40:25"
        self.images = [
            Image(imageUrl: "https://kkkstra.cn/assets/img/logo4.jpg", width: 500, height: 500),
            Image(imageUrl: "https://kkkstra.cn/assets/img/logo4.jpg", width: 500, height: 500)
        ]
        self.title = "TEST"
        self.content = "just a test"
    }
    
    func getPublishedTime()->String{
        // 2024-11-12 16:40:25
        return String(published_at.suffix(14).prefix(11))
    }
}
