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
    public var end:NSValue = NSValue()
    public var start:NSValue = NSValue()
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return time
    }
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let view = self.getView(transitionContext)
        let startvalue = !isPresent ? end : start
        let endValue = isPresent ? end : start
        
        animation(view!, transitionContext: transitionContext,startValue: startvalue,endValue: endValue)
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
    public func animation(view:UIView,transitionContext: UIViewControllerContextTransitioning,startValue:NSValue,endValue:NSValue)
    {
        view.frame = startValue.CGRectValue()
        UIView.animateWithDuration(time, delay: 0, options: [.AllowUserInteraction], animations: {() -> Void in
            view.frame = endValue.CGRectValue()
            }) { (_) -> Void in
                self.animationComplete(transitionContext)
                
        }

    }
}

