//
//  YHTAnimation.swift
//  YHMenu
//
//  Created by YinHao on 16/1/11.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

public class YHTAnimation: NSObject,UIViewControllerAnimatedTransitioning {
    public var time:NSTimeInterval = 0.1
    public var isPresent:Bool = true
    public var endframe:CGRect = CGRectZero
    public var startframe:CGRect = CGRectZero
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return time
    }
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let view = self.getView(transitionContext)
        let end = isPresent ? endframe : startframe
        UIView.animateWithDuration(time, delay: 0, options: [.AllowUserInteraction], animations: {() -> Void in
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

