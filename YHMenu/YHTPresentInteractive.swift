//
//  YHTPresentInteractive.swift
//  YHMenu
//
//  Created by YinHao on 16/1/11.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

public class YHTPresentInteractive: YHTInteractive{
    weak public var toVC:UIViewController?
    public var PresentID:String = "panMenu"
    public func hookViewController(vc:UIViewController,fromID:String)
    {
        self.fromVC = vc
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: "location:")
        gesture.edges = UIRectEdge.Left 
        self.fromVC!.view.addGestureRecognizer(gesture)
        PresentID = fromID
        
    }
    override func location(pan:UIPanGestureRecognizer){
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
            
            let current = pan.locationInView(fromVC?.view.window)
            var delta = self.calcDelta(current, start: start)
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
    public override func calcDelta(current: CGPoint, start: CGPoint) -> CGFloat {
        return CGFloat((current.x - start.x)) / frame.width
    }
}
