//
//  ServicesErrors.swift
//  RunLogs
//
//  Created by Sorin Antohi on 20/10/15.
//  Copyright © 2015 Sorin Antohi. All rights reserved.
//

import Foundation

enum ServiceError: ErrorType
{
  case NoInternet
  case ServerError

  case UsernameTaken
  case PasswordTooShort

  case InvalidUsernameOrPassword
  case InvalidEmail
}
