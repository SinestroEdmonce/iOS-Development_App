//
//  SourceShareViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import SSZipArchive

class SourceShareViewController: UIViewController {
    @IBOutlet weak var sourceNameContent: UITextField!
    @IBOutlet weak var sourceIntro: UITextView!
    @IBOutlet weak var selectionTableView: UITableView!
    // Constraint used to auto resize the layout when the keyboard is called
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewOfSrcName: UIView!
    @IBOutlet weak var viewOfSrcIntro: UIView!
    // Variable to store the information
    @IBOutlet weak var srcName: UITextField!
    @IBOutlet weak var srcIntro: UITextView!
    
    // Number of selections
    var numOfRows: [String] = ["CATEGORY", "FILE", "FILENAME"]
    // Size of the word
    let textViewFont = UIFont.systemFont(ofSize: 15)
    
    // Files storage
    var filesInfo: [[String]] = []
    var photosInfo: [URL] = []
    let photosZip: String = "images_set.zip"
    let filesZip: String = "files_set.zip"
    
    // Placeholder for the text view
    let placeholder = NSMutableAttributedString(attributedString: NSAttributedString(string: "简单介绍一下你分享的资源吧..."))
    
    func isAble2Send() ->Bool {
        if let srcName = self.srcName.text {
            if srcName == "" {
                return false
            }
        }
        if let srcIntro = self.srcIntro.text {
            if srcIntro == "" || srcIntro == self.placeholder.string {
                return false
            }
        }
        if self.photosInfo.count == 0 && self.filesInfo.count == 0 {
            return false
        }
        return true
    }
    
    func packResourceInfo() -> [String: String]{
        if self.photosInfo.count != 0 {
            // Storage to initialize
            let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                               .userDomainMask, true)[0] as String
            let zipPath = "\(rootPath)/\(self.photosZip)"
            var imagesPath: [String] = []
            
            // Obtain all strings, which are transformed from urls
            for imageURL in self.photosInfo {
                imagesPath.append(imageURL.absoluteString)
            }
            
            // Zip all the photos
            SSZipArchive.createZipFile(atPath: zipPath, withFilesAtPaths: imagesPath)
            return self.generatePackage(self.photosZip, filePath: zipPath)
        }
        else {
            if self.filesInfo[0].count > 1 {
                let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                   .userDomainMask, true)[0] as String
                let zipPath = "\(rootPath)/\(self.filesZip)"
                
                // Zip all the photos
                SSZipArchive.createZipFile(atPath: zipPath, withFilesAtPaths: self.filesInfo[1])
                return self.generatePackage(self.filesZip, filePath: zipPath)
            }
            else {
                return self.generatePackage(self.filesInfo[0][0], filePath: self.filesInfo[1][0])
            }
        }
    }
    
    func generatePackage(_ fileName: String, filePath: String) -> [String: String]{
        var packDict: [String: String] = [:]
        let dataStorage: DataPersistenceService = DataPersistenceService()
        
        // Obtain the time stamp
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        packDict["owner"] = dataStorage.getCurrentUserId(key: dataStorage.userIdKey)
        packDict["catalog"] = "test"
        packDict["id"] = self.srcName.text! + "_" + fileName + "_" + dataStorage.getCurrentUserId(key: dataStorage.userIdKey) + "_" + "\(timeStamp)"
        packDict["introduction"] = self.srcIntro.text
        packDict["file_tag"] = self.srcName.text!
        packDict["file_path"] = filePath
        
        return packDict
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a reusable cell
        self.selectionTableView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellReuseIdentifier: "SelectionCell")
        
        // Set data source and delegate
        self.selectionTableView.delegate = self
        self.selectionTableView.dataSource = self
        // Set blank table view UI
        self.selectionTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Set the initialized value of text field
        self.srcName.adjustsFontSizeToFitWidth=true
        self.srcName.minimumFontSize=12
        self.srcName.borderStyle = UITextField.BorderStyle.roundedRect
        self.srcName.returnKeyType = UIReturnKeyType.done
        self.srcName.clearButtonMode = .whileEditing
        self.srcName.delegate = self
        
        // Set the text view attributes
        self.srcIntro.delegate = self
        self.placeholder.addAttribute(NSAttributedString.Key.font, value:
            self.textViewFont, range: NSMakeRange(0, self.placeholder.length))
        self.srcIntro.attributedText = placeholder
        self.srcIntro.textColor = UIColor.lightGray
        
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
        
        let notificationName: Notification.Name = Notification.Name(rawValue: "fileSelectedStatusChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(self.fileSelected(_:)), name: notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func fileSelected(_ notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        if (userInfo["type"] as! Int) == 0{
            self.filesInfo = userInfo["files"] as! [[String]]
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
        else {
            self.photosInfo = userInfo["files"] as! [URL]
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
        
    }
    
    func cleanCellContent() {
        self.filesInfo = []
        self.photosInfo = []
        
        DispatchQueue.main.async {
            self.selectionTableView.reloadData()
        }
    }
    
    // Insert text
    func insertString(_ text: String) {
        // Obtain all the text in the textview and transform them into mutable string
        let mutableStr = NSMutableAttributedString(attributedString: self.srcIntro.attributedText)
        // Get the cursor loction
        let selectedRange = self.srcIntro.selectedRange
        // Insert string
        let attStr = NSAttributedString(string: text)
        mutableStr.insert(attStr, at: selectedRange.location)
        
        // Set attributes of the mutable text
        mutableStr.addAttribute(NSAttributedString.Key.font, value: self.textViewFont,
                                range: NSMakeRange(0,mutableStr.length))
        // Record the cursor loaction
        let newSelectedRange = NSMakeRange(selectedRange.location + attStr.length, 0)
        
        // Reassign the textview
        self.srcIntro.attributedText = mutableStr
        // Restore the cursor location
        self.srcIntro.selectedRange = newSelectedRange
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
            self.scrollView.frame.size.height = self.view.frame.size.height - keyboardFrame.size.height + 50
        }
    }
    
    @objc func hideKeyboard(_ notification: Notification){
        UIView.animate(withDuration: 0.25) {
            self.scrollView.frame.size.height = self.view.frame.size.height
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.filesInfo = []
            self.photosInfo = []
            self.performSegue(withIdentifier: "SelectResourceCategory", sender: nil)
        }
        else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "SelectResourceFile", sender: nil)
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
            let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "-settings")!, name: "选择资源类别")
            selectionCell.loadData2Cell(data: selectionStaticData)
        }
        else if indexPath.row == 1 {
            let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "_settings")!, name: "选择资源文件（上传文件）")
            selectionCell.loadData2Cell(data: selectionStaticData)
        }
        else if indexPath.row == 2 {
            if self.filesInfo.count > 0 {
                var allFiles: String = ""
                for fileName in self.filesInfo[0] {
                    allFiles = allFiles + fileName + ", "
                }
                allFiles += "..."
                
                let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "_settings")!, name: allFiles)
                selectionCell.loadData2Cell(data: selectionStaticData)
                selectionCell.accessoryType = .none
                selectionCell.selectionTypeName.textColor = UIColor.lightGray
                selectionCell.selectionTypeImage.isHidden = true
            }
            else if self.photosInfo.count > 0 {
                let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "_settings")!, name: "图片将被压缩成Zip文档...")
                selectionCell.loadData2Cell(data: selectionStaticData)
                selectionCell.accessoryType = .none
                selectionCell.selectionTypeName.textColor = UIColor.lightGray
                selectionCell.selectionTypeImage.isHidden = true
            }
            else {
                let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "_settings")!, name: "已选择的文件...")
                selectionCell.selectionTypeImage.isHidden = true
                selectionCell.loadData2Cell(data: selectionStaticData)
                selectionCell.accessoryType = .none
                selectionCell.selectionTypeName.textColor = UIColor.lightGray
            }
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

extension SourceShareViewController: UITextViewDelegate {
    // Self-design placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        let mutableStr = NSMutableAttributedString(attributedString: textView.attributedText)
        if mutableStr.length < 1 {
            textView.attributedText = self.placeholder
            textView.textColor = UIColor.lightGray
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let attrStr = NSAttributedString(attributedString: textView.attributedText)
        if attrStr.string == "简单介绍一下你分享的资源吧..." {
            textView.attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: ""))
            textView.textColor = UIColor.darkText
        }
    }
    
}




