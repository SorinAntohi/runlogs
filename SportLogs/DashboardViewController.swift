//
//  DashboardViewController.swift
//  RunLogs
//
//  Created by Sorin Antohi on 20/10/15.
//  Copyright © 2015 Sorin Antohi. All rights reserved.
//

import Foundation

class DashboardViewController : UIViewController
{  
  override func viewDidLoad()
  {
    self.navigationItem.hidesBackButton = true
    self.title = "Dashboard"
    self.tabBarController?.customizableViewControllers = nil;
  }
}