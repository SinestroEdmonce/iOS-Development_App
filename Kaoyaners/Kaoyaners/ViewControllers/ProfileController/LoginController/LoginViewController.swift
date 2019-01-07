//
//  LoginViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var remindView: UIView!
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    var textFieldList: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Store all the textfields and set delegate
        self.textFieldList.append(contentsOf: [self.userId, self.userPassword])
        for textfield in self.textFieldList {
            textfield.adjustsFontSizeToFitWidth=true
            textfield.minimumFontSize=12
            textfield.borderStyle = UITextField.BorderStyle.roundedRect
            textfield.returnKeyType = UIReturnKeyType.done
            textfield.delegate = self
        }
        self.userPassword.isSecureTextEntry = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationName = Notification.Name(rawValue: "loginPageChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["current": 1])
    }

    @IBAction func loginClicked(_ sender: Any) {
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Call back the keyboard
        textField.resignFirstResponder()
        // TODO
        return true
    }
}

