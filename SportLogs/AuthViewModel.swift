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
}

enum RecoverPasswordViewMode
{
  case RecoverPassword
  case RememberedPassword
}

class AuthViewModel {
  
  var viewMode:ViewMode = ViewMode.Login
  var recoverPasswordViewMode:RecoverPasswordViewMode = RecoverPasswordViewMode.RecoverPassword
  
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
    if(recoverPasswordViewMode == RecoverPasswordViewMode.RememberedPassword)
    {
      return UIReturnKeyType.Go;
    }
    else
    {
      return UIReturnKeyType.Next;
    }
  }
  
  func switchViewModeTitle() -> String?
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
  
  func recoverPasswordTitle() -> String?
  {
    if(recoverPasswordViewMode == RecoverPasswordViewMode.RecoverPassword)
    {
      return LocalizedStrings().stringForKey("recoverPassword", comment: "")
    }
    else
    {
      return LocalizedStrings().stringForKey("rememberedPassword", comment: "")
    }
  }
  
  func termsTitle() -> String?
  {
    return LocalizedStrings().stringForKey("terms", comment: "")
    
  }
  
  func switchViewMode()
  {
    if(viewMode == ViewMode.Login)
    {
      viewMode = ViewMode.Register
    }
    else
    {
      viewMode = ViewMode.Login
    }
  }
  
  func switchRecoverPasswordMode()
  {
    if(recoverPasswordViewMode == RecoverPasswordViewMode.RecoverPassword)
    {
      recoverPasswordViewMode = RecoverPasswordViewMode.RememberedPassword
    }
    else
    {
      recoverPasswordViewMode = RecoverPasswordViewMode.RecoverPassword
    }
  }
  
  func submitForm(username:String?, password: String?)
  {
    if recoverPasswordViewMode == RecoverPasswordViewMode.RememberedPassword
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
