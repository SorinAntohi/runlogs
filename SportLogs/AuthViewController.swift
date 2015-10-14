//
//  ViewController.swift
//  SportLogs
//
//  Created by Sorin Antohi on 12/10/15.
//  Copyright © 2015 Sorin Antohi. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class AuthViewController: UIViewController {
  
  var viewModel:AuthViewModel?
  var avPlayerLayer:AVPlayerLayer?
  var avPlayer:AVPlayer?
  var canDismissKeyboard:Bool = false
  
  @IBOutlet weak var formView: UIView!
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var bottomStackConstraint: NSLayoutConstraint!
  @IBOutlet weak var inputsStackCenterConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var passwordStackView: UIView!
  @IBOutlet weak var switchViewMode: UIButton!
  @IBOutlet weak var recoverPassword: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    viewModel = AuthViewModel()
    
    hideNavigationBar()
    setupInputs()
    setupMoviePlayer(formView.layer)
    setupBlurEfectUnderView(formView)
    
    switchViewMode.setTitle(viewModel?.switchViewModeTitle(), forState: UIControlState.Normal)
    recoverPassword.setTitle(viewModel?.recoverPasswordTitle(), forState: UIControlState.Normal)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  @IBAction func onSwitchViewMode(sender: AnyObject)
  {
    viewModel?.switchViewMode()
    
    switchViewMode.setTitle(viewModel?.switchViewModeTitle(), forState: UIControlState.Normal)
    
    switchRecoverPasswordVisibility()
    
    if(viewModel?.viewMode == ViewMode.Register && viewModel?.recoverPasswordViewMode == RecoverPasswordViewMode.RememberedPassword)
    {
      switchRecoverPasswordMode()
      switchPasswordVisibility()
    }
  }
  
  @IBAction func recoverPassword(sender: AnyObject)
  {
    switchRecoverPasswordMode()
    switchPasswordVisibility()
  }
  
  @IBAction func formViewTapped(sender: AnyObject)
  {
    if(username.isFirstResponder())
    {
      canDismissKeyboard = true;
      username.resignFirstResponder()
      
    }
    else if(password.isFirstResponder())
    {
      canDismissKeyboard = true;
      password.resignFirstResponder()
    }
  }
  
  func hideNavigationBar()
  {
    self.navigationController?.navigationBarHidden = true
  }

  func setupInputs()
  {
    username.attributedPlaceholder = viewModel?.usernamePlaceholder();
    password.attributedPlaceholder = viewModel?.passwordPlaceholder();
  }
  
  func setupMoviePlayer(layer:CALayer?)
  {
    
    avPlayer = AVPlayer(URL: NSURL.fileURLWithPath(viewModel?.backgroundMoviePath() as! String))
    
    avPlayerLayer = AVPlayerLayer.init()
    avPlayerLayer?.frame = self.view.bounds
    avPlayerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerReachedEndOfFile:", name:AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer?.currentItem)
    
    avPlayerLayer?.player = avPlayer
    self.view.layer.insertSublayer(avPlayerLayer!, below: layer!)
    avPlayer?.play()
  }

  func setupBlurEfectUnderView(view:UIView?)
  {
    if !UIAccessibilityIsReduceTransparencyEnabled()
    {
      self.view.backgroundColor = UIColor.clearColor()
    
      let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
    
      blurEffectView.frame = self.view.bounds
      blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    
      self.view.insertSubview(blurEffectView, belowSubview:view!)
    }
  }
  
  func moviePlayerReachedEndOfFile(notification: NSNotification)
  {
      let currentVideo = notification.object as! AVPlayerItem
      currentVideo.seekToTime(CMTimeMake(0, 1))
      avPlayer?.play()
  }
  
  func keyboardNotification(notification: NSNotification)
  {
    if let userInfo = notification.userInfo
    {
      let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
      let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
      
      let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
      let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
      
      let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
      if(self.inputsStackCenterConstraint.constant == 0.0)
      {
        self.inputsStackCenterConstraint.constant = (endFrame?.height)! * -0.5
        self.bottomStackConstraint.constant = endFrame?.size.height ?? 0.0
      }
      else
      {
        if(canDismissKeyboard == true)
        {
          self.inputsStackCenterConstraint.constant = 0.0
          self.bottomStackConstraint.constant = 0.0
          canDismissKeyboard = false;
        }
      }
      
      UIView.animateWithDuration(duration,
        delay: NSTimeInterval(0),
        options: animationCurve,
        animations: { self.view.layoutIfNeeded() },
        completion: nil)
    }
  }
  
  func switchRecoverPasswordMode()
  {
    viewModel?.switchRecoverPasswordMode()
    recoverPassword.setTitle(viewModel?.recoverPasswordTitle(), forState: UIControlState.Normal)
  }
  
  func switchRecoverPasswordVisibility()
  {
    UIView.transitionWithView(passwordStackView,
      duration: 0.4,
      options: UIViewAnimationOptions.TransitionCrossDissolve,
      animations: { () -> Void in
        self.recoverPassword.alpha = self.viewModel?.viewMode == ViewMode.Register ? 0.0 : 1.0
        self.recoverPassword.hidden = self.viewModel?.viewMode == ViewMode.Register
      },
      completion:nil)
  }
  
  func switchPasswordVisibility()
  {
    UIView.transitionWithView(passwordStackView,
      duration: 0.4,
      options: UIViewAnimationOptions.TransitionCrossDissolve,
      animations: { () -> Void in
        self.passwordStackView.alpha = self.viewModel?.recoverPasswordViewMode == RecoverPasswordViewMode.RememberedPassword ? 0.0 : 1.0
        self.passwordStackView.hidden = self.viewModel?.recoverPasswordViewMode == RecoverPasswordViewMode.RememberedPassword
      },
      completion:nil)
  }
}

