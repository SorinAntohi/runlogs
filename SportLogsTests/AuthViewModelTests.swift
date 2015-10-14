//
//  LoginViewModelTests.swift
//  SportLogs
//
//  Created by Sorin Antohi on 13/10/15.
//  Copyright © 2015 Sorin Antohi. All rights reserved.
//

import XCTest

class AuthViewModelTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testThatUsernamePlaceholderHasCorrectEnglishValue()
  {
    let nsDefault = NSUserDefaults.standardUserDefaults()
    nsDefault.setObject(["en"], forKey: "AppleLanguages")
    nsDefault.synchronize()
    
    let authViewModel = AuthViewModel()
    let usernamePlaceholder = authViewModel.usernamePlaceholder()!
    
    XCTAssert(usernamePlaceholder.string == "email", "Incorrect username placeholder value!")
  }
  
  func testThatUsernamePlaceholderHasCorrectRomanianValue()
  {
    let nsDefault = NSUserDefaults.standardUserDefaults()
    nsDefault.setObject(["ro"], forKey: "AppleLanguages")
    nsDefault.synchronize()
    
    let authViewModel = AuthViewModel()
    let usernamePlaceholder = authViewModel.usernamePlaceholder()!
    
    XCTAssert(usernamePlaceholder.string == "email", "Incorrect username placeholder value!")
  }
  
  func testThatPasswordPlaceholderHasCorrectEnglishValue()
  {
    let nsDefault = NSUserDefaults.standardUserDefaults()
    nsDefault.setObject(["en"], forKey: "AppleLanguages")
    nsDefault.synchronize()
    
    let authViewModel = AuthViewModel()
    let passwordPlaceholder = authViewModel.passwordPlaceholder()!
    
    XCTAssert(passwordPlaceholder.string == "password", "Incorrect password placeholder value!");
  }
  
  func testThatPasswordPlaceholderHasCoorectRomanianValue()
  {
    let nsDefault = NSUserDefaults.standardUserDefaults()
    nsDefault.setObject(["ro"], forKey: "AppleLanguages")
    nsDefault.synchronize()
    
    let authViewModel = AuthViewModel()
    let passwordPlaceholder = authViewModel.passwordPlaceholder()!
    
    XCTAssert(passwordPlaceholder.string == "parola", "Incorrect password placeholder value!");
  }
}
