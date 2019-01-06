//
//  SettingsViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    // All table view cell
    @IBOutlet weak var modifyCode: UITableViewCell!
    @IBOutlet weak var modifyAvatar: UITableViewCell!
    
    @IBOutlet weak var forwardSettings: UITableViewCell!
    @IBOutlet weak var secretSettings: UITableViewCell!
    @IBOutlet weak var skimFavSettings: UITableViewCell!
    
    @IBOutlet weak var aboutApp: UITableViewCell!
    @IBOutlet weak var joinUs: UITableViewCell!
    
    var accountSection: [UITableViewCell] = []
    var favSettingSection: [UITableViewCell] = []
    var aboutUsSection: [UITableViewCell] = []
    var sectionController: [[UITableViewCell]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add all cells into sections
        self.accountSection.append(self.modifyCode)
        self.accountSection.append(self.modifyAvatar)
        
        self.favSettingSection.append(self.forwardSettings)
        self.favSettingSection.append(self.secretSettings)
        self.favSettingSection.append(self.skimFavSettings)
        
        self.aboutUsSection.append(self.aboutApp)
        self.aboutUsSection.append(self.joinUs)
        
        self.sectionController.append(contentsOf: [self.accountSection, self.favSettingSection, self.aboutUsSection])
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 3
        }
        else {
            return 2
        }
    }

    @IBAction func backClicked(_ sender: Any) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
}
