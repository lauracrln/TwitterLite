//
//  TweetCellViewModel.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 22/11/22.
//

import Foundation
import UIKit

struct TweetCellViewModel {
    
    let tweet: Tweet
    
    var content: String? {
        return tweet.content ?? ""
    }
    
    var imageContent: URL? {
        return tweet.imageUrl ?? nil
    }
    
    var profileImage: UIImage {
        return tweet.profileImage
    }
    
    var userInfo: NSAttributedString {
        
        let title = NSMutableAttributedString(string: "@\(tweet.username)", attributes: [.font: UIFont.systemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " ·\(timeStamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: tweet.timestamp, to: Date()) ?? "2m"
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
}
