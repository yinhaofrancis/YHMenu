//
//  YHMenuDelegate.swift
//  YHMenu
//
//  Created by YinHao on 16/1/26.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

public class YHMenuDelegate: NSObject,UIViewControllerTransitioningDelegate {
    @IBOutlet public weak var viewController:UIViewController!
    public static var bundleName:String = "YHMenu"
    @IBInspectable public var target:CGRect = CGRectZero
    @IBInspectable public var alpha:CGFloat = 0.3
    @IBInspectable public var maskColor:UIColor = UIColor.clearColor()
    @IBInspectable public var time:Double = 0.5
    var interdismiss:YHTInteractive?
    @IBInspectable public var interdismissClass:String = "\(YHMenuDelegate.bundleName).\(YHTInteractive.self)"
    weak var interpresent:YHTPresentInteractive?
    @IBInspectable public var presentClass:String = "\(YHMenuDelegate.bundleName).\(YHTPresentController.self)"
    
    lazy public var transAnimation:YHTAnimation = {
        return self.buildAnimation()
    }()
    public var startFrame:CGRect = CGRectZero{
        didSet{
            self.startFrame = convertRect(self.startFrame, base: UIScreen.mainScreen().bounds)
        }
    }
    public var endFrame:CGRect = CGRectZero{
        didSet{
            self.endFrame = convertRect(self.endFrame, base: UIScreen.mainScreen().bounds)
        }
    }
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transAnimation.isPresent = false
        return self.transAnimation
    }
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transAnimation.isPresent = true
        return self.transAnimation
    }
    public func setStartAndEnd()
    {
        self.startFrame = CGRectMake(-self.target.width, 0, self.target.width, self.target.height)
        self.endFrame = CGRectMake(0, 0, self.target.width, self.target.height)
    }
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        self.setStartAndEnd()
        interpresent?.frame = self.endFrame
        let present = (NSClassFromString(self.presentClass) as! YHTPresentController.Type).init(presentedViewController: presented, presentingViewController: presenting)
        present.maskColor = self.maskColor
        present.startFrame = self.startFrame
        present.alpha = self.alpha
        self.hookViewController()
        return present
    }
    public func buildAnimation()->YHTAnimation
    {
        let animation = YHTAnimation()
        animation.isPresent = false
        animation.time = self.time
        animation.end =   NSValue(CGRect: self.endFrame)
        animation.start = NSValue(CGRect: self.startFrame)
        return animation
    }
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interpresent == nil
        {
            return interpresent
        }
        else
        {
            return interpresent!.active ? interpresent : nil
        }
    }
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interdismiss!.frame = self.endFrame
        return interdismiss!.active ? interdismiss : nil
    }
    public func hookViewController()
    {
        self.interdismiss = (NSClassFromString(self.interdismissClass) as! YHTInteractive.Type).init()
        interdismiss!.hookViewController(self.viewController)
    }
}
extension UIViewController
{
    @IBOutlet var trans:YHMenuDelegate?{
        set{
            self.transitioningDelegate = newValue
            self.modalPresentationStyle = .Custom
        }
        get{
            return nil
        }
    }
}
