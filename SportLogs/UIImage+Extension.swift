//
//  UIColor+Extension.swift
//  RunLogs
//
//  Created by Sorin Antohi on 21/10/15.
//  Copyright © 2015 Sorin Antohi. All rights reserved.
//

import Foundation

extension UIImage
{
  class func imageFromColor(color: UIColor, frame: CGRect) -> UIImage
  {
    UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
    color.setFill()
    UIRectFill(frame)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}