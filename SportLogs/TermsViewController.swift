//
//  TermsViewController.swift
//  RunLogs
//
//  Created by Sorin Antohi on 21/10/15.
//  Copyright © 2015 Sorin Antohi. All rights reserved.
//

import Foundation

class TermsViewController:UIViewController
{
  
  @IBOutlet weak var navBar: UINavigationBar!
  @IBOutlet weak var navItem: UINavigationItem!
  
  override func viewDidLoad()
  {
    self.navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action:"rightButtonItemPress:")
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }
  
  func rightButtonItemPress(sender: UIBarButtonItem)
  {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}