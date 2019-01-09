//
//  MyProfileViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class MyProfileViewController: UITableViewController {
    
    @IBOutlet weak var avatarButton4Login: UIButton!
    @IBOutlet weak var avatarBackgroundImage: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set circle button
        self.avatarButton4Login.layer.cornerRadius = self.avatarButton4Login.frame.size.width/2
        self.avatarButton4Login.clipsToBounds = true
        
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
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 2 &&
            indexPath.row == 0 {
            let userData: DataPersistenceService = DataPersistenceService()
            userData.saveDefault()
            self.avatarButton4Login.setBackgroundImage(UIImage(named: userData.getAvatarImage(key: userData.avatarImageKey)), for: .normal)
            self.avatarButton4Login.setTitle("注册/登录", for: .normal)
            // Set default button and label
            self.avatarButton4Login.setTitleColor(UIColor.darkGray, for: .normal)
            self.avatarButton4Login.setTitleColor(UIColor.darkText, for: .highlighted)
            
            self.accountName.text = DataPersistenceService().getCurrentUserId(key: DataPersistenceService().userIdKey)
        }
    }
    
    @IBAction func avatarButtonClicked(_ sender: Any) {
        let userData: DataPersistenceService = DataPersistenceService()
        if userData.isDefaultAccount() {
            self.performSegue(withIdentifier: "Jump2RegisterLogin", sender: nil)
        }
        //TODO
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
