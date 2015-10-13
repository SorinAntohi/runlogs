//
//  LoginViewModel.swift
//  SportLogs
//
//  Created by Sorin Antohi on 13/10/15.
//  Copyright © 2015 Sorin Antohi. All rights reserved.
//

import Foundation
import UIKit

class LoginViewModel {
  
  func UsernamePlaceholder() -> NSAttributedString?
  {
    let usernamePlaceholder = LocalizedStrings().stringForKey("usernamePlaceholder", comment: "")
    return NSAttributedString(string:usernamePlaceholder!, attributes:[NSForegroundColorAttributeName:UIColor.lightGrayColor()])
  }
  
  func PasswordPlaceholder() -> NSAttributedString?
  {
    let passwordPlaceholder = LocalizedStrings().stringForKey("passwordPlaceholder", comment: "")
    return NSAttributedString(string:passwordPlaceholder!, attributes:[NSForegroundColorAttributeName:UIColor.lightGrayColor()])
  }
  
  func BackgroundMoviePath() -> NSString?
  {
    return NSBundle.mainBundle().pathForResource("intro", ofType:"mp4")
  }
}
