//
//  indicateSegue.swift
//  processView
//
//  Created by YinHao on 16/1/29.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

public class indicateSegue: UIStoryboardSegue {
    let Controller:indicateController = indicateController()
    override public func perform() {
        self.sourceViewController.presentViewController(self.destinationViewController, animated: true, completion: nil)
    }
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        destinationViewController.modalPresentationStyle = .Custom
        destination.transitioningDelegate = self.Controller
    }
}
class indicatePresent:UIPresentationController{
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(self.presentedView()!)
        self.presentedView()?.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        self.presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
            
            }, completion: nil)
    }
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
            
            }, completion: nil)
    }
}
class indicateAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    var view:UIView
    var present = true
    var during = 0.3
    init(presented: UIViewController) {
        view = presented.view
        super.init()
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return during
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if present{
            view.transform = CGAffineTransformMakeScale(0.01, 0.01)
            UIView.animateWithDuration(during , delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
                self.view.transform = CGAffineTransformMakeScale(1, 1)
                }, completion: { (_) -> Void in
                    self.animationComplete(transitionContext)
            })

        }else{
            UIView.animateWithDuration(during * 0.5, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                self.view.transform = CGAffineTransformScale(self.view.transform, 0.01, 0.01)
                }, completion: { (_) -> Void in
                    self.animationComplete(transitionContext)
            })
        }
    }
    func animationComplete(transitionContext: UIViewControllerContextTransitioning){
        let value = !transitionContext.transitionWasCancelled()
        transitionContext.completeTransition(value)
    }
    
}
public class indicateController:NSObject,UIViewControllerTransitioningDelegate{
    private weak var dismissController:UIViewController?
    private var timer:NSTimer?
    public var timeOut:NSTimeInterval = 10
    var isTimeOut = false
    func willDismiss(){
        isTimeOut = true
        let alert = UIAlertController(title: "警告", message: "等待超时", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: { (_) -> Void in
            self.realDismiss()
        }))
        self.dismissController?.presentViewController(alert, animated: true, completion: nil)
    }
    private func realDismiss(){
        dismissController?.dismissViewControllerAnimated(true, completion: nil)
        timer?.invalidate()
        timer = nil
    }
    public func dismiss(){
        if !isTimeOut{
            self.realDismiss()
        }
    }
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        self.dismissController = presented
        timer = NSTimer.scheduledTimerWithTimeInterval(self.timeOut, target: self, selector: #selector(indicateController.willDismiss), userInfo: nil, repeats: false)
        return indicatePresent(presentedViewController: presented, presentingViewController: presenting)
    }
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return indicateAnimation(presented: presented)
    }
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = indicateAnimation(presented: dismissed)
        animation.present = false
        return animation
    }
}
