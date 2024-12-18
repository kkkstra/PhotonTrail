//
//  Post.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation

struct Post: Codable, Hashable, Identifiable {
    var id: UInt64
    var user_id: UInt64
    var avatar: String
    var name: String
    var published_at: String
    var images: [ImageMeta]
    var title: String
    var content: String
    var camera: String
    var lens: String
    
    func getPublishedTime() -> String {
        // 2024-11-12 16:40:25
        return String(published_at.suffix(14).prefix(11))
    }
}

struct ImageMeta: Codable, Hashable {
    let url: String
    let width: Int
    let height: Int
    let index: Int
}

struct PostImage {
    let url: String
    let width: Int
    let height: Int
    let index: Int
    let post_id: UInt64
    var title: String
    var content: String
    var camera: String
    var lens: String
    
    var id: String {
        return "\(post_id)_\(index)"
    }
}
