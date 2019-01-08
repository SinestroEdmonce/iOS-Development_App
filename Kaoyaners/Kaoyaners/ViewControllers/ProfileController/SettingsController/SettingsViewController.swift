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
    
    // Deal with a selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            let settingUrl = NSURL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(settingUrl as URL, options: [:], completionHandler: {(success) in print("Open \(settingUrl): \(success)")})
            }
            else {
                let success = UIApplication.shared.openURL(settingUrl as URL)
                print("Open \(settingUrl): \(success)")
            }
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            if AppAuthorizationSettings.isAlbumEnabled == true {
                self.fromAlbum()
            }
            else {
                let authorization: AppAuthorizationSettings = AppAuthorizationSettings()
                let enableRes = authorization.photoEnable()
                if enableRes {
                    self.fromAlbum()
                }
            }
        }
    }
    
    // Send data to the new view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Select photos from the album
    func fromAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }
        else {
            print(String(format: "[taskName] %@, [info] %@", arguments: ["Open Album", "FAILED"]))
        }
    }
    
    
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Obtain the original pictures
        let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // Save the selected picture into the fileManager
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpg"
        let imageData = pickedImage.jpegData(compressionQuality: 1.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        
        // Upload the picture
        //let sender: NetworkInteract2Backend = NetworkInteract2Backend()
        //sender.multipartOneFileUpload(filePath, targetAddr: "/resources", parameters: ["id": "admin#y_m_d#5124", "catalog": "avatar", "owner": "admin", "introduction": "avatar", "file_tag": "pic"])
        
        // Exit the image controller
        picker.dismiss(animated: true, completion:nil)
    }
}
