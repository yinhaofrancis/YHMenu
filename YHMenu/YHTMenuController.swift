//
//  YHTMenuController.swift
//  YHMenu
//
//  Created by YinHao on 15/10/29.
//  Copyright © 2015年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit
func convertRect(rect:CGRect,base:CGRect) -> CGRect
{
    var result = rect
    result.origin.x = rect.origin.x > 2 ? rect.origin.x : rect.origin.x * base.width
    result.origin.y = rect.origin.y > 2 ? rect.origin.y : rect.origin.y * base.height
    result.size.width = rect.width > 1 ? rect.width : rect.width * base.width
    result.size.height = rect.height > 1 ? rect.height : rect.height * base.height
    return result
}
public class YHTMenuController: UIViewController,UIViewControllerTransitioningDelegate {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
    }
   lazy public var transAnimation:YHTAnimation = {
        let animation = YHTAnimation()
        animation.isPresent = false
        animation.time = self.time
        animation.endframe = self.endFrame
        animation.startframe = self.startFrame
        return animation
    }()
    @IBInspectable public var isLeft:Bool = true
    @IBInspectable public var size:CGSize = CGSizeZero
    var interdismiss = YHTInteractive()
    weak var interpresent:YHTPresentInteractive?
    var startFrame:CGRect = CGRectZero{
        didSet{
            self.startFrame = convertRect(self.startFrame, base: UIScreen.mainScreen().bounds)
        }
    }
    var endFrame:CGRect = CGRectZero{
        didSet{
            self.endFrame = convertRect(self.endFrame, base: UIScreen.mainScreen().bounds)
        }
    }
    @IBInspectable public var maskColor:UIColor = UIColor.clearColor()
    @IBInspectable public var time:Double = 0.5
    override public func viewDidLoad() {
        super.viewDidLoad()
        interdismiss.hookViewController(self)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transAnimation.isPresent = false
        return self.transAnimation
    }
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transAnimation.isPresent = true
        return self.transAnimation
    }
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        if isLeft{
            self.startFrame = CGRectMake(-self.size.width, 0, self.size.width, self.size.height)
            self.endFrame = CGRectMake(0, 0, self.size.width, self.size.height)
        }else{
            self.startFrame = CGRectMake(1, 0, self.size.width, self.size.height)
            self.endFrame = CGRectMake(1 - self.size.width, 0, self.size.width, self.size.height)
        }
        interpresent?.frame = self.endFrame
        let present = YHTPresentController(presentedViewController: presented, presentingViewController: presenting)
        present.maskColor = self.maskColor
        present.startFrame = self.startFrame
        return present
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
        interdismiss.isleft = self.isLeft

        interdismiss.frame = self.endFrame
        return interdismiss.active ? interdismiss : nil
    }
}
public class YHTPresentController: UIPresentationController {
    let maskView:UIView = UIView()
    public var maskColor:UIColor = UIColor.clearColor()
    public var startFrame:CGRect = CGRectZero
    override public func presentationTransitionWillBegin() {
        config()
        presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext) -> Void in
                self.maskView.alpha = 1
            }, completion: nil)
    }
    override public func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext) -> Void in
            self.maskView.alpha = 0
            }, completion: nil)
    }
    private func config()
    {
        maskView.backgroundColor = self.maskColor
        maskView.alpha = 0
        maskView.frame = self.containerView!.bounds
        maskView.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        maskView.addSubview(effectView)
        effectView.frame = maskView.bounds
        effectView.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        self.containerView?.addSubview(maskView)
        self.containerView?.addSubview(self.presentedView()!)
        presentedView()?.frame = self.startFrame
        self.maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "back"))
        self.presentedView()?.layer.shadowColor = UIColor.blackColor().CGColor
        self.presentedView()?.layer.shadowOpacity = 0.8
        self.presentedView()?.layer.shadowRadius = 4
    }
    func back()
    {
        self.presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    override public func frameOfPresentedViewInContainerView() -> CGRect {
        return convertRect(startFrame, base: self.containerView!.frame)
    }
}
public class YHTAnimation: NSObject,UIViewControllerAnimatedTransitioning {
    public var time:NSTimeInterval = 0
    public var isPresent:Bool = true
    public var endframe:CGRect = CGRectZero
    public var startframe:CGRect = CGRectZero
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return time
    }
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let view = self.getView(transitionContext)
        let end = isPresent ? endframe : startframe
        UIView.animateWithDuration(time, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {() -> Void in
            view?.frame = end
            }) { (_) -> Void in
                self.animationComplete(transitionContext)
        }
    }
    func getView(transitionContext: UIViewControllerContextTransitioning) -> UIView?
    {
        let key = isPresent ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey
        let controller = transitionContext.viewControllerForKey(key)
        return controller?.view
    }
    func animationComplete(transitionContext: UIViewControllerContextTransitioning)
    {
        let value = !transitionContext.transitionWasCancelled()
        transitionContext.completeTransition(value)
    }
}
public class YHTInteractive: UIPercentDrivenInteractiveTransition {
    public var active = false
    public var start = CGPointZero
    public var isleft = true
    public var shouldFinish = false
    weak public var fromVC:UIViewController?
    public var frame = CGRectZero
    public func hookViewController(vc:UIViewController)
    {
        self.fromVC = vc
        self.fromVC!.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "location:"))
    }
    func location(pan:UIPanGestureRecognizer){
        switch(pan.state)
        {
        case .Began:
            active = true
            fromVC?.dismissViewControllerAnimated(true, completion: nil)
            self.start = pan.locationInView(fromVC?.view.window)
        case .Changed:
            let op:CGFloat = isleft ? -1.0 : 1.0
            let current = pan.locationInView(fromVC?.view.window)
            let delta = CGFloat(op * (current.x - start.x)) / frame.width
            shouldFinish = delta > 0.5 ? true : false
            self.updateInteractiveTransition(delta)
        case .Ended ,.Cancelled:
            active = false
            if shouldFinish{
                self.finishInteractiveTransition()
            }
            else
            {
                self.cancelInteractiveTransition()
            }
            break
        default:
            break
        }
    }
}
public class YHTPresentInteractive: UIPercentDrivenInteractiveTransition {
    public var active = false
    public var start = CGPointZero
    public var isleft = true
    public var shouldFinish = false
    weak public var fromVC:UIViewController?
    weak public var toVC:UIViewController?
    public var frame = CGRectZero
    public var PresentID:String = "panMenu"
    public func hookViewController(vc:UIViewController,fromID:String)
    {
        self.fromVC = vc
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: "location:")
        gesture.edges = isleft ? UIRectEdge.Left : UIRectEdge.Right
        self.fromVC!.view.addGestureRecognizer(gesture)
        PresentID = fromID
        
    }
    func location(pan:UIPanGestureRecognizer){
        switch(pan.state)
        {
        case .Began:
            active = true
            toVC = fromVC?.storyboard?.instantiateViewControllerWithIdentifier(self.PresentID)
            toVC?.setValue(self, forKey: "interpresent")
            self.frame = (toVC as! YHTMenuController).endFrame
            fromVC?.presentViewController(toVC!, animated: true, completion: nil)
            self.start = pan.locationInView(fromVC?.view.window)
        case .Changed:
            let op:CGFloat = isleft ? 1.0 : -1.0
            let current = pan.locationInView(fromVC?.view.window)
            var delta = CGFloat(op * (current.x - start.x)) / frame.width
            delta = delta > 1 ? 1 : delta
            shouldFinish = delta > 0.5 ? true : false
            self.updateInteractiveTransition(delta)
        case .Ended ,.Cancelled:
            active = false
            if shouldFinish{
                self.finishInteractiveTransition()
            }
            else
            {
                self.cancelInteractiveTransition()
            }
            break
        default:
            break
        }
    }
}
