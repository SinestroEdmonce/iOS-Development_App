//
//  SourceShareViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class SourceShareViewController: UIViewController {
    @IBOutlet weak var sourceNameContent: UITextField!
    @IBOutlet weak var sourceIntro: UITextView!
    @IBOutlet weak var selectionTableView: UITableView!
    // Constraint used to auto resize the layout when the keyboard is called
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewOfSrcName: UIView!
    @IBOutlet weak var viewOfSrcIntro: UIView!
    
    // Number of selections
    var numOfRows: [String] = ["CATEGORY", "FILE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a reusable cell
        self.selectionTableView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellReuseIdentifier: "SelectionCell")
        
        // Set data source and delegate
        self.selectionTableView.delegate = self
        self.selectionTableView.dataSource = self
        // Set blank table view UI
        self.selectionTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Declare a tap gesture for hiding keyboard
        let hideTap4Name = UITapGestureRecognizer(target: self, action: #selector(self.tap4HideKeyboard(recognizer:)))
        hideTap4Name.numberOfTapsRequired = 1
        self.viewOfSrcName.isUserInteractionEnabled = true
        self.viewOfSrcName.addGestureRecognizer(hideTap4Name)
        
        // Declare a tap gesture for hiding keyboard
        let hideTap4Intro = UITapGestureRecognizer(target: self, action: #selector(self.tap4HideKeyboard(recognizer:)))
        hideTap4Intro.numberOfTapsRequired = 1
        self.viewOfSrcIntro.isUserInteractionEnabled = true
        self.viewOfSrcIntro.addGestureRecognizer(hideTap4Intro)

        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationName = Notification.Name(rawValue: "sharePageChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["current": 1])
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
}

extension SourceShareViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    // Deal with a selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectionTableView!.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "SelectResourceCategory", sender: nil)
        }
    }
    
    // Send data to the new view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

extension SourceShareViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numOfRows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectionCell = self.selectionTableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as! SelectionCell
        
        if indexPath.row == 0 {
            let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "Settings")!, name: "选择资源类别")
            selectionCell.loadData2Cell(data: selectionStaticData)
        }
        else {
            let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "Settings")!, name: "选择资源文件（上传文件）")
            selectionCell.loadData2Cell(data: selectionStaticData)
        }
        return selectionCell
    }
    
}

extension SourceShareViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Call back the keyboard
        textField.resignFirstResponder()
        // TODO
        return true
    }
}

extension SourceShareViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view?.isKind(of: SelectionCell.self) ?? false {
            return false
        }
        
        return true
    }
    
}

