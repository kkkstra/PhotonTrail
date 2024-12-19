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
    
//    func getPublishedTime() -> String {
//        // 2024-11-12 16:40:25
//        return String(published_at.suffix(14).prefix(11))
//    }
    
    func getPublishedTime() -> String {
        let utcTimeString = self.published_at
        
        struct Formatter {
            static let input: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                return formatter
            }()
            
            static let outputWithYear: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                formatter.timeZone = TimeZone.current
                return formatter
            }()
            
            static let outputWithoutYear: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd HH:mm"
                formatter.timeZone = TimeZone.current
                return formatter
            }()
        }
        
        guard let date = Formatter.input.date(from: utcTimeString) else {
            return utcTimeString
        }
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let publishedYear = calendar.component(.year, from: date)
        
        if publishedYear == currentYear {
            return Formatter.outputWithoutYear.string(from: date)
        } else {
            return Formatter.outputWithYear.string(from: date)
        }
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
