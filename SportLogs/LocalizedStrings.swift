//
//  StringsService.swift
//  SportLogs
//
//  Created by Sorin Antohi on 13/10/15.
//  Copyright © 2015 Sorin Antohi. All rights reserved.
//

import UIKit

class LocalizedStrings {

  func stringForKey(key:String, comment:String) -> String?
  {
    let preferredLanguage = NSLocale.preferredLanguages().first!.componentsSeparatedByString("-").first!
    return stringForKey(key, comment: comment, language:preferredLanguage)
  }
  
  func stringForKey(key:String, comment:String, language:String, tableName:String="Main") -> String?
  {
    let bundle = bundleForLanguage(language)!
    let localizedString = NSLocalizedString(key, tableName:tableName, bundle:bundle, comment:comment)
    return localizedString;
  }
  
  private func bundleForLanguage(language:String) -> NSBundle?
  {
    let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj")
    if(path != nil)
    {
      return NSBundle(path: path!)
    }
    else
    {
      return NSBundle(path: NSBundle.mainBundle().pathForResource(language, ofType: "lproj")!)
    }
  }
}
