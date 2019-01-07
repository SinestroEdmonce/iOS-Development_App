//
//  SkimFavViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class SkimFavViewController: UITableViewController {
    // Section tag
    var sectionTag: [String] = ["FIRSTSHOW", "SAVEDATAFLOW", "AUTOPLAY"]
    // Store the prefering settings
    var preferrence: [String: Bool] = [:]
    
    @IBOutlet weak var firstshowSwitch: UISwitch!
    @IBOutlet weak var savedataflowSwitch: UISwitch!
    @IBOutlet weak var autoplaySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
        else {
            return 1
        }
    }

    @IBAction func backClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
