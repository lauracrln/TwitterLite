//
//  TweetServiceSuccessMock.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 28/11/22.
//

import Foundation

class TweetServiceSuccessMock: TweetServiceProtocol {
    func uploadTweet(content: String?, image: Data?, completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        let tweet = Tweet(username: "test", tweetData: ["name": "test"])
        completion([tweet])
    }
    
    func deleteTweet(tweetId: String) {
        //
    }
    
    
}
