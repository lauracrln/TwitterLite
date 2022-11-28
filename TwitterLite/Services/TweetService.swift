//
//  TweetService.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 21/11/22.
//

import Foundation
import UIKit
import RxSwift
import Firebase
import RxRelay

public enum TweetError: Error {
    case unknown
    case failedImageUpload
}

public protocol TweetServiceProtocol {
    func uploadTweet(content: String?, image: Data?, completion: @escaping (Error?) -> Void)
    func fetchTweets(completion: @escaping ([Tweet]) -> Void)
    func deleteTweet(tweetId: String)
}

class TweetService: TweetServiceProtocol {
    static let shared = TweetService()
    let userService = UserService.shared
    
    func uploadTweet(content: String?, image: Data?, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return completion(TweetError.unknown) }
        
        let tweetId = REF_TWEETS.childByAutoId()
        let ref = STORAGE_TWEET_IMAGES.child(tweetId.key ?? "")
        
        if let imageData = image {
            uploadTweet(
                withImage: imageData,
                content: content,
                uid: uid,
                tweetId: tweetId,
                ref: ref,
                completion: completion)
        } else {
            uploadTweet(
                content: content,
                uid: uid,
                tweetId: tweetId,
                ref: ref,
                completion: completion)
        }
        
    }
    
    private func uploadTweet(
        content: String?,
        uid: String,
        tweetId: DatabaseReference,
        ref: StorageReference,
        completion: @escaping (Error?) -> Void
    ) {
        let values = [
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "content": content,
            "imageURL": nil,
            "uid": uid,
            "tweetID": tweetId.key
        ] as [String: Any]
        
        tweetId.updateChildValues(values) { (error, result) in
            if let error = error {
                print("Error Uploading tweet \(error.localizedDescription)")
                completion(SignUpError.unknown)
            } else {
                guard let tweetId = tweetId.key else { return }
                REF_USER_TWEETS.child(uid).updateChildValues([tweetId: 1])
                completion(nil)
            }
        }
    }
    
    private func uploadTweet(
        withImage imageData: Data,
        content: String?,
        uid: String,
        tweetId: DatabaseReference,
        ref: StorageReference,
        completion: @escaping (Error?) -> Void
    ) {
        ref.putData(imageData, metadata: nil) { (imageMetaData, error) in
            if error != nil {
                completion(TweetError.failedImageUpload)
                print("Error Uploading Image \(error?.localizedDescription)")
            } else {
                print("Successfully Uploaded Image")
                ref.downloadURL { (url, error) in
                    guard let imageUrl = url?.absoluteString else { return }
                    
                    let values = [
                        "timestamp": Int(NSDate().timeIntervalSince1970),
                        "content": content,
                        "imageURL": imageUrl,
                        "uid": uid,
                        "tweetID": tweetId.key
                    ] as [String: Any]
                    
                    tweetId.updateChildValues(values) { (error, result) in
                        if let error = error {
                            print("Error Uploading tweet \(error.localizedDescription)")
                            completion(SignUpError.unknown)
                        } else {
                            guard let tweetId = tweetId.key else { return }
                            REF_USER_TWEETS.child(uid).updateChildValues([tweetId: 1])
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_TWEETS.child(uid).observe(.childAdded) { [weak self] (tweetID) in
            
            let tweetID = tweetID.key
            
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { (tweetData) in
                
                guard let dataDict = tweetData.value as? [String: Any] else { return }
                guard let uid = dataDict["uid"] as? String else { return }
                self?.userService.fetchUser(uid: uid) { (user) in
                    let tweet = Tweet(username: user, tweetData: dataDict)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func deleteTweet(tweetId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_TWEETS.child(uid).child(tweetId).removeValue()
        REF_TWEETS.child(tweetId).removeValue()
    }
}

