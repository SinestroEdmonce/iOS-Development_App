//
//  MyProfileViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import SDWebImage
class MyProfileViewController: UITableViewController {
    
    @IBOutlet weak var avatarButton4Login: UIButton!
    @IBOutlet weak var avatarBackgroundImage: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    // Obtain the user data
    let userDataUpdate: DataPersistenceService = DataPersistenceService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUserInfo()
        
        // Set circle button
        self.avatarButton4Login.layer.cornerRadius = self.avatarButton4Login.frame.size.width/2
        self.avatarButton4Login.clipsToBounds = true
        
        let notificationName: Notification.Name = Notification.Name(rawValue: "avatarBeenChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(self.avatarUpdate(_:)), name: notificationName, object: nil)
        
        let notifyName: Notification.Name = Notification.Name(rawValue: "userBeenChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(self.userUpdate(_:)), name: notifyName, object: nil)
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // Modify user
    @objc func userUpdate(_ notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let userId = userInfo["user"] as! String
        
        self.accountName.text = userId
        let sender: NetworkInteract2Backend = NetworkInteract2Backend()
        sender.requestUserAvatar(sender.requestAvatarAddr, parameters: ["id": userId], completeHandler: { (avatarURL, result) in
            if result {
                // Temporarily storage
                let tempImageView: UIImageView = UIImageView(image: UIImage(named: self.userDataUpdate.getAvatarImage(key: self.userDataUpdate.avatarImageKey)))
                tempImageView.isHidden = true
                tempImageView.sd_setImage(with: avatarURL, completed: { (image, error, whereFrom, url) in
                    self.avatarButton4Login.setBackgroundImage(image!, for: .normal)
                    self.avatarButton4Login.setTitle("", for: .normal)
                })
            }
            
            self.avatarButton4Login.setTitle("", for: .normal)
        })
    }
    
    // Modify the avatar
    @objc func avatarUpdate(_ notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let avatarNew = userInfo["avatar"] as! UIImage
        
        // Update avatar
        self.avatarButton4Login.setBackgroundImage(avatarNew, for: .normal)
        self.avatarButton4Login.setTitle("", for: .normal)
    }
    
    // Update user info
    func updateUserInfo() {
        if self.userDataUpdate.isDefaultAccount() {
            self.avatarButton4Login.setBackgroundImage(UIImage(named: self.userDataUpdate.getAvatarImage(key: self.userDataUpdate.avatarImageKey)), for: .normal)
            self.avatarButton4Login.setTitle("注册/登录", for: .normal)
            // Set default button and label
            self.avatarButton4Login.setTitleColor(UIColor.darkGray, for: .normal)
            self.avatarButton4Login.setTitleColor(UIColor.darkText, for: .highlighted)
            
            self.accountName.text = self.userDataUpdate.getCurrentUserId(key: self.userDataUpdate.userIdKey)
        }
        else {
            if self.userDataUpdate.isDefaultAvatar() {
                self.avatarButton4Login.setBackgroundImage(UIImage(named: self.userDataUpdate.getAvatarImage(key: self.userDataUpdate.avatarImageKey)), for: .normal)
                self.avatarButton4Login.setTitle("", for: .normal)
                
                self.accountName.text = self.userDataUpdate.getCurrentUserId(key: self.userDataUpdate.userIdKey)
            }
            else {
                // Temporarily storage
                let tempImageView: UIImageView = UIImageView(image: UIImage(named: self.userDataUpdate.getAvatarImage(key: self.userDataUpdate.avatarImageKey)))
                tempImageView.isHidden = true
                tempImageView.sd_setImage(with: URL(string: self.userDataUpdate.getAvatarImage(key: self.userDataUpdate.avatarImageKey)),
                                          completed: { (image, error, whereFrom, url) in
                    self.avatarButton4Login.setBackgroundImage(image!, for: .normal)
                    self.avatarButton4Login.setTitle("", for: .normal)
                })
                
                self.accountName.text = self.userDataUpdate.getCurrentUserId(key: self.userDataUpdate.userIdKey)
            }
        }
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
            self.userDataUpdate.saveDefault()
            self.avatarButton4Login.setBackgroundImage(UIImage(named: self.userDataUpdate.getAvatarImage(key: self.userDataUpdate.avatarImageKey)), for: .normal)
            self.avatarButton4Login.setTitle("注册/登录", for: .normal)
            // Set default button and label
            self.avatarButton4Login.setTitleColor(UIColor.darkGray, for: .normal)
            self.avatarButton4Login.setTitleColor(UIColor.darkText, for: .highlighted)
            
            self.accountName.text = self.userDataUpdate.getCurrentUserId(key: self.userDataUpdate.userIdKey)
        }
    }
    
    @IBAction func avatarButtonClicked(_ sender: Any) {
        let userData: DataPersistenceService = DataPersistenceService()
        if userData.isDefaultAccount() {
            self.performSegue(withIdentifier: "Jump2RegisterLogin", sender: nil)
        }
        else {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
