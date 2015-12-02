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
class YHTMenuController: UIViewController,UIViewControllerTransitioningDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
    }
    lazy var transAnimation:YHTAnimation = {
        let animation = YHTAnimation()
        animation.isPresent = false
        animation.time = self.time
        animation.endframe = self.endFrame
        animation.startframe = self.startFrame
        return animation
    }()
    @IBInspectable var isLeft:Bool = true
    @IBInspectable var size:CGSize = CGSizeZero
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
    @IBInspectable var maskColor:UIColor = UIColor.clearColor()
    @IBInspectable var time:Double = 0.5
    override func viewDidLoad() {
        super.viewDidLoad()
        interdismiss.hookViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transAnimation.isPresent = false
        return self.transAnimation
    }
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transAnimation.isPresent = true
        return self.transAnimation
    }
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
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
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interpresent == nil
        {
            return interpresent
        }
        else
        {
            return interpresent!.active ? interpresent : nil
        }
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interdismiss.isleft = self.isLeft

        interdismiss.frame = self.endFrame
        return interdismiss.active ? interdismiss : nil
    }
}
class YHTPresentController: UIPresentationController {
    let maskView:UIView = UIView()
    var maskColor:UIColor = UIColor.clearColor()
    var startFrame:CGRect = CGRectZero
    override func presentationTransitionWillBegin() {
        config()
        presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext) -> Void in
                self.maskView.alpha = 1
            }, completion: nil)
    }
    override func dismissalTransitionWillBegin() {
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
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return convertRect(startFrame, base: self.containerView!.frame)
    }
}
class YHTAnimation: NSObject,UIViewControllerAnimatedTransitioning {
    var time:NSTimeInterval = 0
    var isPresent:Bool = true
    var endframe:CGRect = CGRectZero
    var startframe:CGRect = CGRectZero
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return time
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
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
class YHTInteractive: UIPercentDrivenInteractiveTransition {
    var active = false
    var start = CGPointZero
    var isleft = true
    var shouldFinish = false
    weak var fromVC:UIViewController?
    var frame = CGRectZero
    func hookViewController(vc:UIViewController)
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
class YHTPresentInteractive: UIPercentDrivenInteractiveTransition {
    var active = false
    var start = CGPointZero
    var isleft = true
    var shouldFinish = false
    weak var fromVC:UIViewController?
    weak var toVC:UIViewController?
    var frame = CGRectZero
    var PresentID:String = "panMenu"
    func hookViewController(vc:UIViewController,fromID:String)
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
