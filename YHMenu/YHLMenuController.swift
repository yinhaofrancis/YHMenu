//
//  YHLMenuController.swift
//  YHMenu
//
//  Created by YinHao on 16/1/11.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

public class YHLMenuController: YHTMenuController {
    @IBInspectable public var isLeft:Bool = true
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public override func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let present = super.presentationControllerForPresentedViewController(presented, presentingViewController: presenting, sourceViewController: source)
        return present
    }
}
