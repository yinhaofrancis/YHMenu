//
//  YHTSegue.swift
//  YHMenu
//
//  Created by YinHao on 16/1/12.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//
//
//import UIKit
//
//public class YHTSegue: UIStoryboardSegue {
//    @IBInspectable public var target:CGRect = CGRectZero
//    @IBInspectable public var alpha:CGFloat = 0.3
//    @IBInspectable public var maskColor:UIColor = UIColor.clearColor()
//    @IBInspectable public var time:Double = 0.5
//    
//    @IBInspectable public var interdismissClass:String = "\(YHTMenuController.bundleName).\(YHTInteractive.self)"
//    @IBInspectable public var presentClass:String = "\(YHTMenuController.bundleName).\(YHTPresentController.self)"
//    public override func perform()
//    {
//        print(self.destinationViewController)
//        self.sourceViewController.presentViewController(self.destinationViewController, animated: true, completion: nil)
//    }
//    public func setData()
//    {
//        
//    }
//}
