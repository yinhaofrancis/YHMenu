//
//  YHDropMenuController.swift
//  YHMenu
//
//  Created by YinHao on 16/1/11.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

public class YHDropMenuController: YHTMenuController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public override func setStartAndEnd()
    {
        self.startFrame = CGRect(x: 0, y:  -self.target.height, width: self.target.width, height: self.target.height)
        self.endFrame = self.target
    }
}
class dropInteractive:YHTInteractive {
    override func calcDelta(current: CGPoint, start: CGPoint) -> CGFloat {
        return (start.y - current.y) / self.frame.height
    }
}
