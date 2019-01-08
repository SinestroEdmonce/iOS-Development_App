//
//  DocumentViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/8.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationName = Notification.Name(rawValue: "fileSelectionPageChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["current": 0])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
