//
//  processView.swift
//  nsob
//
//  Created by YinHao on 16/1/27.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit
@IBDesignable
public class processView: UIView {
    @IBInspectable var animation:Bool = true{
        didSet{
            if animation{
                let pro = CABasicAnimation(keyPath: "process")
                pro.fromValue = 0
                pro.toValue = 1
                pro.duration = 0.2
                pro.repeatCount = Float.infinity
                self.layer.addAnimation(pro, forKey: "pro")
            }else{
                self.layer.removeAnimationForKey("pro")
            }
        }
    }
    override public func didMoveToWindow() {
        self.layer.contentsScale = UIScreen.mainScreen().scale
        self.layer.display()
        let pro = CABasicAnimation(keyPath: "process")
        pro.fromValue = 0
        pro.toValue = 1
        pro.duration = 2
        pro.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        pro.repeatCount = Float.infinity
        self.layer.addAnimation(pro, forKey: "pro")
    }
    public override class func layerClass() -> AnyClass {
        return processLayer.self
    }
    override public func intrinsicContentSize() -> CGSize {
        return CGSize(width: 37,height: 37)
    }
}
class processLayer:CALayer {
    var process:CGFloat = 0.5
    var color:UIColor = UIColor.redColor()
    
    override func drawInContext(ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        drawView(self.bounds, color: color, process: process)
        UIGraphicsPopContext()
    }

    func drawView(frame: CGRect, color: UIColor, process: CGFloat) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        
        //// Variable Declarations
        let slow: CGFloat = process > 0.5 ? 90 - (process - 0.5) * 2 * 270 : 90
        let faster: CGFloat = process < 0.5 ? 90 - process * 2 * 270 : -180
        let angle: CGFloat = -450 * process
        
        //// Oval Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.50772 * frame.width, frame.minY + 0.49228 * frame.height)
        CGContextRotateCTM(context, -angle * CGFloat(M_PI) / 180)
        
        let ovalRect = CGRectMake(-18, -18, 36, 36)
        let ovalPath = UIBezierPath()
        ovalPath.addArcWithCenter(CGPointMake(ovalRect.midX, ovalRect.midY), radius: ovalRect.width / 2, startAngle: -slow * CGFloat(M_PI)/180, endAngle: -faster * CGFloat(M_PI)/180, clockwise: true)
        
        color.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()
        
        CGContextRestoreGState(context)


    }
    override class func needsDisplayForKey(key: String) -> Bool{
        if key == "process"{
            return true
        }
        return super.needsDisplayForKey(key)
    }
}
