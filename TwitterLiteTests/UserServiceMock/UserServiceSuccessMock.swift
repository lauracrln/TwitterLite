//
//  UserServiceMock.swift
//  TwitterLiteTests
//
//  Created by Laura Caroline K on 28/11/22.
//

import Foundation

struct UserServiceSuccessMock: UserServiceProtocol {
    var mockError: Bool = false
    
    func fetchUser(uid: String, completion: @escaping (String) -> Void) {
        completion("username")
    }
    
    func auth(email: String, password: String, completion: @escaping (AuthError?) -> Void) {
        completion(nil)
    }
    
    func signUp(email: String, password: String, completion: @escaping (SignUpError?) -> Void) {
        completion(nil)
    }
    
    
}
