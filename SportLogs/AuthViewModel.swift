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

protocol AuthViewModelDelegate
{
  func didRegisterSuccessfully()
  func didLoginSuccessfully()
  func didRecoverPasswordSuccessfully()
  func presentErrorMessage(title:String, message:String)
}

class AuthViewModel {
  
  var delegate:AuthViewModelDelegate?
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
  
  func genericSuccessTitle() -> String?
  {
    return LocalizedStrings().stringForKey("genericSuccessTitle", comment: "")
  }
  
  func recoverPasswordSuccessMessage() -> String?
  {
    return LocalizedStrings().stringForKey("recoverPasswordSuccessMessage", comment: "")
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
        do
        {
          let resetPasswordService = ResetPasswordService()
          try resetPasswordService.resetPasswordForEmail(email)
          if let del = self.delegate
          {
            switchToLoginViewMode()
            del.didRecoverPasswordSuccessfully()
          }
        }
        catch let error as ServiceError
        {
          if error == ServiceError.NoInternet
          {
            delegate?.presentErrorMessage("", message: "")
          }
          else if error == ServiceError.InvalidEmail
          {
            delegate?.presentErrorMessage("", message: "")
          }
          else if error == ServiceError.ServerError
          {
            delegate?.presentErrorMessage("", message: "")
          }
        }
        catch
        {
        }
      }
      else
      {
        throw InputError.InvalidEmail
      }
    }
    else if viewMode == ViewMode.Login
    {
      if let user = username, pass = password where removeWhiteSpacesFromString(user).characters.count > 0 &&
                                                    removeWhiteSpacesFromString(pass).characters.count > 0
      {
        do
        {
          let loginService = LoginService()
          try loginService.loginUser(user, password:pass)
          if let del = self.delegate
          {
            del.didLoginSuccessfully()
          }
        }
        
        catch let error as ServiceError
        {
          if error == ServiceError.NoInternet
          {
            delegate?.presentErrorMessage("", message: "")
          }
          else if error == ServiceError.InvalidUsernameOrPassword
          {
            delegate?.presentErrorMessage("", message: "")
          }
          else if error == ServiceError.ServerError
          {
            delegate?.presentErrorMessage("", message: "")
          }
        }
        catch
        {
        }
      }
      else
      {
        throw InputError.InvalidUsernameOrPassword
      }
    }
    else
    {
      if let user = username, pass = password where removeWhiteSpacesFromString(user).characters.count > 0 &&
                                                    removeWhiteSpacesFromString(pass).characters.count > 0
      {
        do
        {
          let registerService = RegisterService()
          try registerService.registerUser(user, password:pass)
          
          if let del = self.delegate
          {
            del.didRegisterSuccessfully()
          }
        }
        catch let error as ServiceError
        {
          if error == ServiceError.NoInternet
          {
            delegate?.presentErrorMessage("", message: "")
          }
          else if error == ServiceError.UsernameTaken
          {
            delegate?.presentErrorMessage("", message: "")
          }
          else if error == ServiceError.PasswordTooShort
          {
            delegate?.presentErrorMessage("", message: "")
          }
          else if error == ServiceError.ServerError
          {
            delegate?.presentErrorMessage("", message: "")
          }
        }
        catch
        {
        }
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
