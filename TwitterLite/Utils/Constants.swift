//
//  Constants.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 21/11/22.
//

import Foundation
import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_TWEET_IMAGES = STORAGE_REF.child("tweet_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
