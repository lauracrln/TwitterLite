//
//  NewPostViewModel.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 28/11/22.
//

import Foundation
import UIKit

struct NewPostViewModel {
    
    private var tweetService: TweetServiceProtocol
    
    init(tweetService: TweetServiceProtocol = TweetService.shared) {
        self.tweetService = tweetService
    }
    
    func uploadTweet(content: String?, image: Data?, completion: @escaping ((Error?) -> Void)) {
        tweetService.uploadTweet(content: content, image: image, completion: completion)
    }
}
