//
//  BlacklistViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class BlacklistViewController: UIViewController {
    // Variable used to show the detail cells for people in a given user's blacklist
    @IBOutlet weak var blacklistContentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blacklistContentTableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
