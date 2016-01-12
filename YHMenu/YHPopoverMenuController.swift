//
//  popoverMenuController.swift
//  YHMenu
//
//  Created by YinHao on 16/1/12.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

public class YHPopoverMenuController: YHTMenuController {
    
    public override func setStartAndEnd() {
        self.startFrame = CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.8)
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func buildAnimation() -> YHTAnimation {
        let o = YHPopoverAnimation()
        o.time = self.time
        o.isPresent = true
        o.start = NSValue(CGAffineTransform: CGAffineTransformMakeScale(0.001, 0.001))
        o.end = NSValue(CGAffineTransform: CGAffineTransformMakeScale(1, 1))
        return o
    }
}
