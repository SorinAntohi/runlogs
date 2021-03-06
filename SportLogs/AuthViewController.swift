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
import TSMessages

class AuthViewController: UIViewController, UITextFieldDelegate, AuthViewModelDelegate {
  
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
  @IBOutlet weak var switchViewModeButton: UIButton!
  @IBOutlet weak var resetPasswordButton: UIButton!
  @IBOutlet weak var termsButton: UIButton!
  @IBOutlet weak var currentStateLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.navigationItem.hidesBackButton = true
    
    // Do any additional setup after loading the view, typically from a nib.
    viewModel = AuthViewModel()
    viewModel?.delegate = self;
    
    setupInputs()
    setupMoviePlayer(formView.layer)
    setupBlurEfectUnderView(formView)
    
    switchViewModeButton.setTitle(viewModel?.viewModeButtonTitle(), forState: UIControlState.Normal)
    resetPasswordButton.setTitle(viewModel?.resetPasswordButtonTitle(), forState: UIControlState.Normal)
    termsButton.setTitle(viewModel?.termsButtonTitle(), forState: UIControlState.Normal)
    switchTermsButtonVisibility()
    currentStateLabel.text = viewModel?.currentModeTitle()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool) {
    hideNavigationBar()
  }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer?.play()
    }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  //IBActions
  @IBAction func onSwitchViewMode(sender: UIButton)
  {
    if(viewModel?.isInRegisterViewMode((sender.titleLabel?.text)!) == true)
    {
      viewModel?.switchToLoginViewMode()
    }
    else
    {
      viewModel?.switchToRegisterViewMode()
      updateResetPasswordButtonTitle()
    }
    
    switchViewModeButton.setTitle(viewModel?.viewModeButtonTitle(), forState: UIControlState.Normal)
    switchRecoverPasswordButtonVisibility()
    switchPasswordVisibility()
    switchTermsButtonVisibility()
    currentStateLabel.text = viewModel?.currentModeTitle()
  }
  
  @IBAction func onTerms(sender: AnyObject)
  {
    self.formViewTapped(self)
    self.performSegueWithIdentifier("TermsSegue", sender: self)
  }
  
  @IBAction func recoverPassword(sender: AnyObject)
  {
    if viewModel?.viewMode == ViewMode.ResetPassword
    {
      viewModel?.switchToLoginViewMode()
    }
    else
    {
      viewModel?.switchToRecoverPasswordViewMode()
    }
    
    formViewTapped(self.view)
    switchUIElementsState()
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
  
  //MoviePlayer methods
  func setupMoviePlayer(layer:CALayer?)
  {
    avPlayer = AVPlayer(URL: NSURL.fileURLWithPath(viewModel?.backgroundMoviePath() as! String))
    
    avPlayerLayer = AVPlayerLayer.init()
    avPlayerLayer?.frame = self.view.bounds
    avPlayerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerReachedEndOfFile:", name:AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer?.currentItem)
    
    avPlayerLayer?.player = avPlayer
    self.view.layer.insertSublayer(avPlayerLayer!, below: layer!)
  }
  
  func moviePlayerReachedEndOfFile(notification: NSNotification)
  {
    let currentVideo = notification.object as! AVPlayerItem
    currentVideo.seekToTime(CMTimeMake(0, 1))
    avPlayer?.play()
  }

  //General UI setup
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
  
  func hideNavigationBar()
  {
    self.navigationController?.navigationBarHidden = true
  }
  
  func setupInputs()
  {
    username.attributedPlaceholder = viewModel?.usernamePlaceholder();
    password.attributedPlaceholder = viewModel?.passwordPlaceholder();
  }
  
  func switchUIElementsState()
  {
    updateResetPasswordButtonTitle()
    switchPasswordVisibility()
    username.returnKeyType = viewModel!.usernameReturnKeyType()
  }
  
  //Notifications
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
  
  //Actions
  func updateResetPasswordButtonTitle()
  {
    resetPasswordButton.setTitle(viewModel?.resetPasswordButtonTitle(), forState: UIControlState.Normal)
  }
  
  func switchRecoverPasswordButtonVisibility()
  {
    UIView.transitionWithView(passwordStackView,
      duration: 0.4,
      options: UIViewAnimationOptions.CurveLinear,
      animations: { () -> Void in
        self.resetPasswordButton.alpha = self.viewModel?.viewMode == ViewMode.Register ? 0.0 : 1.0
        self.resetPasswordButton.hidden = self.viewModel?.viewMode == ViewMode.Register
      },
      completion:nil)
  }
  
  func switchPasswordVisibility()
  {
    UIView.transitionWithView(passwordStackView,
      duration: 0.4,
      options: UIViewAnimationOptions.TransitionCrossDissolve,
      animations: { () -> Void in
        self.passwordStackView.alpha = self.viewModel?.viewMode == ViewMode.ResetPassword ? 0.0 : 1.0
        self.passwordStackView.hidden = self.viewModel?.viewMode == ViewMode.ResetPassword
      },
      completion:nil)
  }
  
  func switchTermsButtonVisibility()
  {
    UIView.transitionWithView(termsButton,
      duration: 0.4,
      options: UIViewAnimationOptions.CurveLinear,
      animations: { () -> Void in
        self.termsButton.alpha = self.viewModel?.viewMode == ViewMode.Login ? 0.0 : 1.0
      },
      completion:nil)
  }
 
  //TextFieldDelegate methods
  func textFieldShouldReturn(textField: UITextField) -> Bool
  {
    if textField == username && self.passwordStackView.hidden == false
    {
      password.becomeFirstResponder()
    }
    else
    {
      formViewTapped(self.view)
      
      do
      {
        try viewModel?.submitForm(username.text, password:password.text)
      }
      catch let error as InputError
      {
        if error == InputError.InvalidUsernameOrPassword
        { 
          presentErrorMessage((viewModel?.genericErrorTitle())!, message: (viewModel?.invalidCredentialsErrorMessage())!)
        }
        else if error == InputError.InvalidEmail
        {
          presentErrorMessage((viewModel?.genericErrorTitle())!, message: (viewModel?.invalidEmailErrorMessage())!)
        }
        
        username.becomeFirstResponder()
      }
      catch
      {
        presentErrorMessage((viewModel?.genericErrorTitle())!, message: (viewModel?.genericErrorMessage())!)
      }
    }
    
    return false;
  }
  
  func presentSuccessMessage(title:String, message:String)
  {
    TSMessage.showNotificationWithTitle(title, subtitle: message, type: TSMessageNotificationType.Success)
  }
  
  //AuthViewModelDelegate methods
  func presentErrorMessage(title:String, message:String)
  {
    TSMessage.showNotificationWithTitle(title, subtitle: message, type: TSMessageNotificationType.Error)
  }
  
  func didRegisterSuccessfully()
  {
    self.performSegueWithIdentifier("DashboardSegue", sender: self)
  }
  
  func didLoginSuccessfully()
  {
    self.performSegueWithIdentifier("DashboardSegue", sender: self)
  }
  
  func didRecoverPasswordSuccessfully()
  {
    switchUIElementsState()
    presentSuccessMessage((viewModel?.genericSuccessTitle())!, message:(viewModel?.recoverPasswordSuccessMessage())!);
  }
}

