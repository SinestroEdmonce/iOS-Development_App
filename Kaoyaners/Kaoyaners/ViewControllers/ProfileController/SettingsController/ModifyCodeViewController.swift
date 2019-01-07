//
//  ModifyCodeViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/7.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class ModifyCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
