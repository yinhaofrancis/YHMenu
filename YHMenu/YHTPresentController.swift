//
//  YHTPresentController.swift
//  YHMenu
//
//  Created by YinHao on 16/1/11.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

public class YHTPresentController: UIPresentationController {
    let maskView:UIView = UIView()
    public var maskColor:UIColor? = nil
    public var startFrame:CGRect = CGRectZero
    public var alpha:CGFloat = 0.3
    required override public init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    override public func presentationTransitionWillBegin() {
        self.config()
        if alpha == 0
        {
            return
        }
        self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext) -> Void in
            self.maskView.alpha = self.alpha
            }, completion: {(_) in
                NSNotificationCenter.defaultCenter().postNotificationName(kYHTPresentControllerPresentComplete, object: nil)
        })
    }
    override public func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext) -> Void in
            self.maskView.alpha = 0
            }, completion: nil)
    }
    private func config()
    {
        self.presentedView()?.frame = self.startFrame
        self.maskView.alpha = 0
        self.presentedView()?.layer.shadowColor = UIColor.blackColor().CGColor
        self.presentedView()?.layer.shadowOpacity = 0.8
        self.presentedView()?.layer.shadowRadius = 4
        self.maskView.backgroundColor = self.maskColor
        self.maskView.frame = self.containerView!.bounds
        self.maskView.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        self.maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "back"))
        self.containerView?.addSubview(maskView)
        self.containerView?.addSubview(self.presentedView()!)
    }
    func back()
    {
        self.presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    override public func frameOfPresentedViewInContainerView() -> CGRect {
        return convertRect(startFrame, base: self.containerView!.frame)
    }
}

