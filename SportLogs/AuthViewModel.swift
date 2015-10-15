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
  case RecoverPassword
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
    if(viewMode == ViewMode.RecoverPassword)
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
  
  func recoverPasswordButtonTitle() -> String?
  {
    if(viewMode != ViewMode.RecoverPassword)
    {
      return LocalizedStrings().stringForKey("recoverPassword", comment: "")
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
  
  func switchToRecoverPasswordViewMode()
  {
    viewMode = ViewMode.RecoverPassword
  }
  
  func switchToLoginViewMode()
  {
    viewMode = ViewMode.Login
  }
  
  func switchToRegisterViewMode()
  {
    viewMode = ViewMode.Register
  }
  
  func submitForm(username:String?, password: String?)
  {
    if viewMode == ViewMode.RecoverPassword
    {
      //TODO
      //request password reset
    }
    else
    {
      if viewMode == ViewMode.Login
      {
        //TODO
        //login current user
      }
      else
      {
        //TODO
        //register current user
      }
    }
  }
}
