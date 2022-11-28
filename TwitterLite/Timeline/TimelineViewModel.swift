//
//  TimelineViewModel.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 22/11/22.
//

import Foundation
import RxRelay
import RxSwift

class TimelineViewModel {
    
    private let tweetService: TweetServiceProtocol
    
    init(tweetService: TweetServiceProtocol = TweetService.shared) {
        self.tweetService = tweetService
    }
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        tweetService.fetchTweets(completion: completion)
    }
}
