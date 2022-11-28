//
//  UserService.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 20/11/22.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxRelay
import Firebase

public enum AuthError: Error {
    case invalidEmail
    case wrongPassword
    case unknown
}

public enum SignUpError: Error {
    case invalidEmail
    case inUseEmail
    case weakPassword
    case unknown
}

public protocol UserServiceProtocol {
    func fetchUser(uid: String ,completion: @escaping (String) -> Void)
    func auth(email: String, password: String, completion: @escaping (AuthError?) -> Void)
    func signUp(email: String, password: String, completion: @escaping (SignUpError?) -> Void)
}

class UserService: UserServiceProtocol {
    static let shared = UserService()
    
    func fetchUser(uid: String ,completion: @escaping (String) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject], let username = dict["username"] as? String else { return }
            completion(username)
        }
    }
    
    func auth(email: String, password: String, completion: @escaping (AuthError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error == nil {
                guard let user = authResult?.user else { return completion(AuthError.unknown) }
                completion(nil)
            } else {
                switch error?.localizedDescription {
                case "The password is invalid or the user does not have a password.":
                    completion(AuthError.wrongPassword)
                case "There is no user record corresponding to this identifier. The user may have been deleted.":
                    completion(AuthError.invalidEmail)
                default:
                    completion(AuthError.unknown)
                }
                
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (SignUpError?) -> Void) {
        let email = email
        let password = password
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if error == nil {
                guard let user = authResult?.user, let uid = Auth.auth().currentUser?.uid else { return completion(SignUpError.unknown) }
                let username = email.components(separatedBy: "@")[0]
                let userData = [
                    "email": email,
                    "username": username,
                    "uid": uid
                ]
                
                REF_USERS.child(user.uid).updateChildValues(userData) { error, ref in
                    if error == nil {
                        completion(nil)
                    } else {
                        completion(SignUpError.unknown)
                    }
                }
            } else {
                switch error?.localizedDescription {
                case "The password must be 6 characters long or more.":
                    completion(SignUpError.weakPassword)
                case "The email address is already in use by another account.":
                    completion(SignUpError.inUseEmail)
                case "The email address is badly formatted.":
                    completion(SignUpError.invalidEmail)
                default:
                    completion(SignUpError.unknown)
                }
                
            }
        }
    }
}
