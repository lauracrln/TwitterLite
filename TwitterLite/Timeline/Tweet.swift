//
//  Tweet.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 21/11/22.
//

import Foundation
import UIKit

public struct Tweet {
    let content: String?
    let imageUrl : URL?
    let timestamp: Date!
    let id: String
    let username: String
    let profileImage: UIImage
    let tweetId: String
    
    init(username: String, tweetData: [String: Any]) {
        self.username = username
        
        self.id = tweetData["uid"] as? String ?? ""
        self.content = tweetData["content"] as? String ?? ""
        
        let imageString = tweetData["imageURL"] as? String ?? ""
        self.imageUrl = URL(string: imageString)
        
        let intDate = tweetData["timestamp"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: TimeInterval(floatLiteral: intDate))
        
        self.profileImage = UIImage(named: "profile_icon") ?? UIImage()
        self.tweetId = tweetData["tweetID"] as? String ?? ""
    }
}
