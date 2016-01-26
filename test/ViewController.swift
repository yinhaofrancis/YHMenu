//
//  ViewController.swift
//  test
//
//  Created by YinHao on 15/10/29.
//  Copyright © 2015年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit
import YHMenu
class ViewController: UIViewController {

    var controller:UIViewController?
    let inteactive = YHTPresentInteractive()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var image: UIImageView!
    @IBAction func switchs(sender: UISwitch) {
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    let value = sender.on ? M_PI : 0.0
                    self.image.transform = CGAffineTransformMakeRotation(CGFloat(value))

                    }, completion: { (_) -> Void in

                })
        
    }

    @IBAction func pop(sender: AnyObject) {
//        self.presentViewController(self.controller!, animated: true, completion: nil)
    }
}