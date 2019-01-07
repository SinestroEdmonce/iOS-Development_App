//
//  ModifyCodeViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/7.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class ModifyCodeViewController: UIViewController {
    @IBOutlet weak var inputOldCode: UITextField!
    @IBOutlet weak var reinputNewCode: UITextField!
    @IBOutlet weak var inputNewCode: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    // Varaible used to store the three textfields
    var textFieldList: [UITextField] = []
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Store all the textfields and set delegate
        self.textFieldList.append(contentsOf: [self.inputOldCode, self.inputNewCode, self.reinputNewCode])
        for textfield in self.textFieldList {
            textfield.adjustsFontSizeToFitWidth=true
            textfield.minimumFontSize=12
            textfield.borderStyle = UITextField.BorderStyle.roundedRect
            textfield.returnKeyType = UIReturnKeyType.done
            textfield.isSecureTextEntry = true
            textfield.delegate = self
        }
    
        // Declare a tap gesture for hiding keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(self.tap4HideKeyboard(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(hideTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func tap4HideKeyboard(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func showKeyboard(_ notification: Notification){
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.25) {
            self.scrollView.frame.size.height = self.view.frame.size.height - keyboardFrame.size.height
        }
    }
    
    @objc func hideKeyboard(_ notification: Notification){
        UIView.animate(withDuration: 0.25) {
            self.scrollView.frame.size.height = self.view.frame.size.height
        }
    }
    
    @IBAction func endEditingClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendClicked(_ sender: Any) {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ModifyCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Call back the keyboard
        textField.resignFirstResponder()
        // TODO
        return true
    }
}
