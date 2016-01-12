//
//  YHPopoverAnimation.swift
//  YHMenu
//
//  Created by YinHao on 16/1/12.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

class YHPopoverAnimation: YHTAnimation {
    override func animation(view: UIView, transitionContext: UIViewControllerContextTransitioning, startValue: NSValue, endValue: NSValue) {
        view.transform = startValue.CGAffineTransformValue()
        if !self.isPresent
        {
            UIView.animateWithDuration(self.time, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                view.transform = endValue.CGAffineTransformValue()
                }) { (_) -> Void in
                    self.animationComplete(transitionContext)
            }
        }else{
            UIView.animateWithDuration(self.time, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                view.transform = endValue.CGAffineTransformValue()
                }) { (_) -> Void in
                    self.animationComplete(transitionContext)
            }
        }
    }
}
