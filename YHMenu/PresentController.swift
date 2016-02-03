//
//  PresentController.swift
//  operator
//
//  Created by YinHao on 16/2/1.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

public class BasePresentController: UIPresentationController {
    override public func presentationTransitionWillBegin() {
        self.containerView?.addSubview(self.presentedView()!)
        self.presentedView()?.frame = self.containerView!.bounds
        self.presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
            
            }, completion: { (context) -> Void in
                
        })
    }
    override public func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
            
            }, completion: { (context) -> Void in
                
        })
    }
}
public class animationController:NSObject,UIViewControllerTransitioningDelegate{
    var consultView:UIView?
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return BasePresentController(presentedViewController: presented, presentingViewController: presenting)
    }
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = animationTransition(View: dismissed.view)
        animation.isPresent = false
        animation.consultView =  self.consultView
        return animation
    }
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = animationTransition(View: presented.view)
        animation.consultView = self.consultView
        animation.isPresent = true
        return animation
    }
}
public class animationTransition:NSObject,UIViewControllerAnimatedTransitioning {
    var _view:UIView
    var during:NSTimeInterval = 0.5
    weak var consultView:UIView?
    var isPresent = false
    public init(View:UIView) {
        _view = View
        super.init()
    }
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return during
    }
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresent{
            self._view.transform = makeStartTransform()
            UIView.animateWithDuration(during, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: [.CurveEaseOut], animations: { () -> Void in
                self._view.transform = CGAffineTransformIdentity
                }) { (_) -> Void in
                    transitionContext.completeTransition(true)
            }
        }else{
            UIView.animateWithDuration(during * 0.6, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
                self._view.transform = self.makeStartTransform()
                }, completion: { (_) -> Void in
                    transitionContext.completeTransition(true)
            })
        }
    }
    func makeStartTransform()->CGAffineTransform{
        let scale = CGAffineTransformMakeScale(self.consultView!.frame.width / UIScreen.mainScreen().bounds.width, self.consultView!.frame.height / UIScreen.mainScreen().bounds.height)
        let translate = CGAffineTransformMakeTranslation(-(UIScreen.mainScreen().bounds.midX - self.consultView!.frame.midX), self.consultView!.frame.midY - UIScreen.mainScreen().bounds.midY)
        return CGAffineTransformConcat(scale, translate)
    }
}
public class presentSegue:UIStoryboardSegue {
    public static var PresentAnimation:animationController = animationController()
    override public func perform() {
        self.sourceViewController.presentViewController(self.destinationViewController, animated: true, completion: nil)
    }
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        destination.transitioningDelegate = presentSegue.PresentAnimation
        destination.modalPresentationStyle = .Custom
    }
}
