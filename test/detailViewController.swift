//
//  detailViewController.swift
//  YHMenu
//
//  Created by YinHao on 16/1/12.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit
import YHMenu
class detailViewController: YHPopoverMenuController {
    var scale:CGFloat = 0
    var pic:UIImage?
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = pic
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func buildAnimation() -> YHTAnimation {
        let o = YHPopoverAnimation()
        o.time = self.time
        o.isPresent = true
        o.start = NSValue(CGAffineTransform:  CGAffineTransformIdentity)
        o.end = NSValue(CGAffineTransform: CGAffineTransformTranslate(CGAffineTransformMakeScale(scale, scale), 0, -110))
        return o
    }
}
