//
//  LoginViewModel.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 17/11/22.
//

import Foundation
import Firebase

public protocol LoginViewModelProtocol {
    func configureLoginAlertTitle(error: AuthError) -> String
    func configureSignupAlertTitle(error: SignUpError) -> String
}


class LoginViewModel: LoginViewModelProtocol {
    
    let successSignUpTitle = "Sign Up Success"
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService.shared) {
        self.userService = userService
    }
    
    func auth(email: String, password: String, completion: @escaping (AuthError?) -> Void) {
        return userService.auth(email: email, password: password, completion: completion)
    }
    
    func signUp(email: String, password: String, completion: @escaping (SignUpError?) -> Void) {
        return userService.signUp(email: email, password: password, completion: completion)
    }
    
    func configureLoginAlertTitle(error: AuthError) -> String {
        var alertTitle = ""
        switch error {
        case .invalidEmail:
            alertTitle = "No user record with this email"
        case .wrongPassword:
            alertTitle = "Incorrect Password"
        default:
            alertTitle = "unknown error. please check your email/password input"
        }
        return alertTitle
    }
    
    func configureSignupAlertTitle(error: SignUpError) -> String {
        var alertTitle = ""
        switch error {
        case .invalidEmail:
            alertTitle = "Please input a valid email"
        case .inUseEmail:
            alertTitle = "Email is already in use"
        case .weakPassword:
            alertTitle = "Password is too short. Must be more than 6 char"
        default:
            alertTitle = "unknown error"
        }
        return alertTitle
    }
}
