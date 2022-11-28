//
//  LoginViewModelTests.swift
//  TwitterLiteTests
//
//  Created by Laura Caroline K on 28/11/22.
//

import XCTest
@testable import TwitterLite

class LoginViewModelTests: XCTestCase {
    
    override func setUp() {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_auth_success() {
        let loginViewModel = LoginViewModel(userService: UserServiceSuccessMock())
        loginViewModel.auth(email: "", password: "") { error in
            XCTAssertNil(error)
        }
    }
    
    func test_signUp_success() {
        let loginViewModel = LoginViewModel(userService: UserServiceSuccessMock())
        loginViewModel.signUp(email: "", password: "") { error in
            XCTAssertNil(error)
        }
    }
    
    func test_ConfigureLoginAlertTitle_invalidEmail() {
        let loginViewModel = LoginViewModel()
        let result = loginViewModel.configureLoginAlertTitle(error: AuthError.invalidEmail)
        
        XCTAssertEqual(result, "No user record with this email")
    }
    
    func test_ConfigureLoginAlertTitle_incorrectPassowrd() {
        let loginViewModel = LoginViewModel()
        let result = loginViewModel.configureLoginAlertTitle(error: AuthError.wrongPassword)
        
        XCTAssertEqual(result, "Incorrect Password")
    }
    
    func test_ConfigureLoginAlertTitle_unknown() {
        let loginViewModel = LoginViewModel()
        let result = loginViewModel.configureLoginAlertTitle(error: AuthError.unknown)
        
        XCTAssertEqual(result, "unknown error. please check your email/password input")
    }
    
    func test_ConfigureSignupAlertTitle_invalidEmail() {
        let loginViewModel = LoginViewModel()
        let result = loginViewModel.configureSignupAlertTitle(error: .invalidEmail)
        
        XCTAssertEqual(result, "Please input a valid email")
    }
    
    func test_ConfigureSignupAlertTitle_inUseEmail() {
        let loginViewModel = LoginViewModel()
        let result = loginViewModel.configureSignupAlertTitle(error: .inUseEmail)
        
        XCTAssertEqual(result, "Email is already in use")
    }
    
    func test_ConfigureSignupAlertTitle_weakPassword() {
        let loginViewModel = LoginViewModel()
        let result = loginViewModel.configureSignupAlertTitle(error: .weakPassword)
        
        XCTAssertEqual(result, "Password is too short. Must be more than 6 char")
    }
    
    func test_ConfigureSignupAlertTitle_unknown() {
        let loginViewModel = LoginViewModel()
        let result = loginViewModel.configureSignupAlertTitle(error: .unknown)
        
        XCTAssertEqual(result, "unknown error")
    }

}
