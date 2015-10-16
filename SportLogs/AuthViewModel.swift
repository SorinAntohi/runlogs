//
//  LoginViewModel.swift
//  SportLogs
//
//  Created by Sorin Antohi on 13/10/15.
//  Copyright © 2015 Sorin Antohi. All rights reserved.
//

import Foundation
import UIKit

enum ViewMode
{
  case Login
  case Register
  case ResetPassword
}

enum InputError: ErrorType {
  case InvalidEmail
  case InvalidUsernameOrPassword
}

class AuthViewModel {
  
  var viewMode:ViewMode = ViewMode.Login
  
  func usernamePlaceholder() -> NSAttributedString?
  {
    let usernamePlaceholder = LocalizedStrings().stringForKey("usernamePlaceholder", comment: "")
    return NSAttributedString(string:usernamePlaceholder!, attributes:[NSForegroundColorAttributeName:UIColor.lightGrayColor()])
  }
  
  func passwordPlaceholder() -> NSAttributedString?
  {
    let passwordPlaceholder = LocalizedStrings().stringForKey("passwordPlaceholder", comment: "")
    return NSAttributedString(string:passwordPlaceholder!, attributes:[NSForegroundColorAttributeName:UIColor.lightGrayColor()])
  }
  
  func backgroundMoviePath() -> NSString?
  {
    return NSBundle.mainBundle().pathForResource("intro", ofType:"mp4")
  }
  
  func usernameReturnKeyType() -> UIReturnKeyType
  {
    if(viewMode == ViewMode.ResetPassword)
    {
      return UIReturnKeyType.Go;
    }
    else
    {
      return UIReturnKeyType.Next;
    }
  }
  
  func viewModeButtonTitle() -> String?
  {
    if(viewMode == ViewMode.Login)
    {
     return LocalizedStrings().stringForKey("signup", comment: "")
    }
    else
    {
      return LocalizedStrings().stringForKey("login", comment: "")
    }
  }
  
  func resetPasswordButtonTitle() -> String?
  {
    if(viewMode != ViewMode.ResetPassword)
    {
      return LocalizedStrings().stringForKey("resetPassword", comment: "")
    }
    else
    {
      return LocalizedStrings().stringForKey("rememberedPassword", comment: "")
    }
  }
  
  func isInRegisterViewMode(title:String) -> Bool
  {
    return title == LocalizedStrings().stringForKey("login", comment: "")
  }
  
  func termsButtonTitle() -> String?
  {
    return LocalizedStrings().stringForKey("terms", comment: "")
    
  }
  
  func invalidCredentialsErrorMessage() -> String?
  {
    return LocalizedStrings().stringForKey("invalidUsernameOrPasswordErrorMessage", comment: "")
  }
  
  func genericErrorTitle() -> String?
  {
    return LocalizedStrings().stringForKey("genericErrorTitle", comment: "")
  }
  
  func genericErrorMessage() -> String?
  {
    return LocalizedStrings().stringForKey("genericErrorMessage", comment: "")
  }
  
  func invalidEmailErrorMessage() -> String?
  {
    return LocalizedStrings().stringForKey("invalidEmailErrorMessage", comment: "")
  }
  
  func switchToRecoverPasswordViewMode()
  {
    viewMode = ViewMode.ResetPassword
  }
  
  func switchToLoginViewMode()
  {
    viewMode = ViewMode.Login
  }
  
  func switchToRegisterViewMode()
  {
    viewMode = ViewMode.Register
  }
  
  func submitForm(username:String?, password: String?) throws
  {
    if viewMode == ViewMode.ResetPassword
    {
      if let email = username where removeWhiteSpacesFromString(email).characters.count > 0
      {
        let resetPasswordService = ResetPasswordService()
        resetPasswordService.resetPasswordForEmail(email)
      }
      else
      {
        throw InputError.InvalidEmail
      }
    }
    else if viewMode == ViewMode.Login
    {
      if let user = username, pass = password where removeWhiteSpacesFromString(user).characters.count > 0 && removeWhiteSpacesFromString(pass).characters.count > 0
      {
        let loginService = LoginService()
        loginService.loginUser(user,password: pass)
      }
      else
      {
        throw InputError.InvalidUsernameOrPassword
      }
    }
    else
    {
      if let user = username, pass = password where removeWhiteSpacesFromString(user).characters.count > 0 && removeWhiteSpacesFromString(pass).characters.count > 0
      {
        let registerService = RegisterService()
        registerService.registerUser(user,password:pass)
      }
      else
      {
        throw InputError.InvalidUsernameOrPassword
      }
    }
  }
  
  func removeWhiteSpacesFromString(value:String) -> String
  {
    return value.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
  }
}
