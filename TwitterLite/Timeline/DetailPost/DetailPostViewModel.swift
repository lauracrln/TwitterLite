//
//  DetailPostViewModel.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 28/11/22.
//

import Foundation

struct DetailPostViewModel {
    
    private let tweetService: TweetServiceProtocol
    
    init(tweetService: TweetServiceProtocol = TweetService.shared) {
        self.tweetService = tweetService
    }
    
    func deleteTweet(tweetId: String) {
        tweetService.deleteTweet(tweetId: tweetId)
    }
}
