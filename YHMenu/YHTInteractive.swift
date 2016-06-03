//
//  YHTInteractive.swift
//  YHMenu
//
//  Created by YinHao on 16/1/11.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

public class YHTInteractive: UIPercentDrivenInteractiveTransition {
    public var active = false
    public var start = CGPointZero
    public var shouldFinish = false
    weak public var fromVC:UIViewController?
    public var frame = CGRectZero
    required override public init() {
        super.init()
    }
    public func hookViewController(vc:UIViewController)
    {
        self.fromVC = vc
        self.fromVC!.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(YHTInteractive.location(_:))))
    }
    func location(pan:UIPanGestureRecognizer){
        switch(pan.state)
        {
        case .Began:
            active = true
            fromVC?.dismissViewControllerAnimated(true, completion: nil)
            self.start = pan.locationInView(fromVC?.view.window)
        case .Changed:
            
            let current = pan.locationInView(fromVC?.view.window)
            let delta = calcDelta(current, start: start)
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
    public func calcDelta(current:CGPoint,start:CGPoint)->CGFloat
    {
        return CGFloat(-current.x + start.x) / frame.width
    }
}

