//
//  YHTMenuController.swift
//  YHMenu
//
//  Created by YinHao on 15/10/29.
//  Copyright © 2015年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit
let kYHTPresentControllerPresentComplete = "YHTPresentControllerPresentComplete"
func convertRect(rect:CGRect,base:CGRect) -> CGRect
{
    var result = rect
    result.origin.x = rect.origin.x > 2 || rect.origin.x < -2 ? rect.origin.x : rect.origin.x * base.width
    result.origin.y = rect.origin.y > 2 || rect.origin.y < -2 ? rect.origin.y : rect.origin.y * base.height
    result.size.width = rect.width > 1 || rect.width < -1 ? rect.width : rect.width * base.width
    result.size.height = rect.height > 1 || rect.height < -1 ? rect.height : rect.height * base.height
    return result
}
public class YHTMenuController:UIViewController,UIViewControllerTransitioningDelegate
{
    public static var bundleName:String = "YHMenu"
    @IBInspectable public var target:CGRect = CGRectZero
    @IBInspectable public var alpha:CGFloat = 0.3
    @IBInspectable public var maskColor:UIColor = UIColor.clearColor()
    @IBInspectable public var time:Double = 0.5
    var interdismiss:YHTInteractive?
    @IBInspectable public var interdismissClass:String = "\(YHTMenuController.bundleName).\(YHTInteractive.self)"
    weak var interpresent:YHTPresentInteractive?
    @IBInspectable public var presentClass:String = "\(YHTMenuController.bundleName).\(YHTPresentController.self)"

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
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.interdismiss = (NSClassFromString(self.interdismissClass) as! YHTInteractive.Type).init()
        interdismiss!.hookViewController(self)
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
}
