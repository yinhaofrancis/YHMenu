//
//  menuViewController.swift
//  YHMenu
//
//  Created by YinHao on 15/10/29.
//  Copyright © 2015年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

class menuViewController: YHTMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let ani = animation()
        ani.isPresent = false
        ani.time = self.time
        startFrame = self.startFrame
        endFrame = self.endFrame
        let transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        ani.startTransform = transform
        ani.endTransform = transform
        return ani
    }
    override func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let ani = animation()
        ani.isPresent = true
        ani.time = self.time
        ani.startframe = self.startFrame
        ani.endframe = self.endFrame
        let transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        let transforms = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
        ani.startTransform = transforms
        ani.endTransform = transform
        return ani
    }
}
class animation:YHTAnimation {
    var startTransform = CGAffineTransformIdentity
    var endTransform = CGAffineTransformIdentity
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let end = isPresent ? endTransform : startTransform
        let endf:CGFloat = isPresent ? 1 : 0
        let view = self.getView(transitionContext)
        view?.frame = endframe
        UIView.animateWithDuration(self.time, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                view?.transform = end
                view?.alpha = endf
            }) { (_) -> Void in
                 self.animationComplete(transitionContext)
        }
    }
    
}
