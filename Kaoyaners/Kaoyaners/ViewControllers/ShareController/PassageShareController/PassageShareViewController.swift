//
//  PassageShareViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

//插入的图片附件的尺寸样式
enum ImageAttachmentMode {
    case `default`      // Not resize
    case fitTextLine    // Fit text line height
    case fitTextView    // Fit text view
}

class PassageShareViewController: UIViewController {
    @IBOutlet weak var passageContent: UITextView!
    @IBOutlet weak var selectionTableView: UITableView!
    // Constraint used to auto resize the layout when the keyboard is called
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    
    // Number of selections
    var numOfRows: [String] = ["CIRCLES", "WHERE"]
    // Size of the word
    let textViewFont = UIFont.systemFont(ofSize: 15)
    // Placeholder for the text view
    let placeholder = NSMutableAttributedString(attributedString: NSAttributedString(string: "想说什么就说吧..."))
    
    // Attributes of the controller
    var currentInsertMode: ImageAttachmentMode = .default
    var text2Insert: String = String("")
    
    // Image attachment dictionary and attributes
    var imageAttachmentDict: [UIImage: String] = [:]
    var currentImageNum: Int = 0
    var currentImageAttachmentNum: Int = 0
    var imageModeDict: [UIImage: String] = [:]
    
    // Prepare for sending to the server
    func packArticleInfo() -> [[String]]{
        let attributedStr = self.contentTextView.attributedText
        let textString = attributedStr?.getPlainString(self.imageModeDict)
        let imagePaths = attributedStr?.getImageAttachment(self.imageAttachmentDict)
        
        var allStrings: [[String]] = []
        allStrings.append([textString!])
        allStrings.append(imagePaths!)
        
        return allStrings
    }
    
    // Insert text
    func insertString(_ text: String) {
        // Obtain all the text in the textview and transform them into mutable string
        let mutableStr = NSMutableAttributedString(attributedString: self.contentTextView.attributedText)
        // Get the cursor loction
        let selectedRange = self.contentTextView.selectedRange
        // Insert string
        let attStr = NSAttributedString(string: text)
        mutableStr.insert(attStr, at: selectedRange.location)
        
        // Set attributes of the mutable text
        mutableStr.addAttribute(NSAttributedString.Key.font, value: self.textViewFont,
                                range: NSMakeRange(0,mutableStr.length))
        // Record the cursor loaction
        let newSelectedRange = NSMakeRange(selectedRange.location + attStr.length, 0)
        
        // Reassign the textview
        self.contentTextView.attributedText = mutableStr
        // Restore the cursor location
        self.contentTextView.selectedRange = newSelectedRange
    }
    
    // Insert Picture
    func insertPicture(_ image:UIImage, mode:ImageAttachmentMode = .default){
        // Obtain all the text in the textview and transform them into mutable string
        let mutableStr = NSMutableAttributedString(attributedString: self.contentTextView.attributedText)
        
        // Create attachment for pictures
        let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
        var imgAttachmentString: NSAttributedString
        imgAttachment.image = image
        
        // Set the Pictures display style
        if mode == .fitTextLine {
            // Same size as text line
            imgAttachment.bounds = CGRect(x: 0, y: -4, width: self.contentTextView.font!.lineHeight, height: self.contentTextView.font!.lineHeight)
        } else if mode == .fitTextView {
            // Same size as text view
            let imageWidth = self.contentTextView.frame.width - 10
            let imageHeight = image.size.height/image.size.width*imageWidth
            imgAttachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        }
        
        imgAttachmentString = NSAttributedString(attachment: imgAttachment)
        
        // Get the cursor loction
        let selectedRange = self.contentTextView.selectedRange
        // Insert text
        mutableStr.insert(imgAttachmentString, at: selectedRange.location)
        // Set attributes of mutable text
        mutableStr.addAttribute(NSAttributedString.Key.font, value: self.textViewFont,
                                range: NSMakeRange(0,mutableStr.length))
        // Record the cursor loaction
        let newSelectedRange = NSMakeRange(selectedRange.location+1, 0)
        
        
        // Reassign the textview
        self.contentTextView.attributedText = mutableStr
        // Restore the cursor location
        self.contentTextView.selectedRange = newSelectedRange
        // Keep visible
        self.contentTextView.scrollRangeToVisible(newSelectedRange)
    }
    
    // Default mode | Fit text line | Fit text view
    func pic2BeInserted() {
        self.fromAlbum()
    }
    
    // Insert text string
    func text2BeInserted(_ text: String) {
        self.insertString(text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentTextView.isSelectable = true
        // Register a reusable cell
        self.selectionTableView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellReuseIdentifier: "SelectionCell")
        
        // Set data source and delegate
        self.selectionTableView.delegate = self
        self.selectionTableView.dataSource = self
        
        // Set the texe view attributes
        self.contentTextView.layer.borderWidth = 1
        self.contentTextView.delegate = self
        self.placeholder.addAttribute(NSAttributedString.Key.font, value:
            self.textViewFont, range: NSMakeRange(0, self.placeholder.length))
        self.contentTextView.attributedText = placeholder
        self.contentTextView.textColor = UIColor.lightGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.selectionTableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationName = Notification.Name(rawValue: "sharePageChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["current": 0])
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
    
    // Bottom alert will be popped to remind picture-inserting mode
    func selectImageAttachmentMode() {
        let alertController = UIAlertController(title: "选择图片插入形式", message: "选择方式", preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title:"默认(大小不变)", style: .default, handler: {
            (action) -> Void in
            self.currentInsertMode = .default
            self.pic2BeInserted()
        })
        let fitViewAction = UIAlertAction(title:"使尺寸适应文本框", style: .default, handler: {
            (action) -> Void in
            self.currentInsertMode = .fitTextView
            self.pic2BeInserted()
        })
        let fitLineAction = UIAlertAction(title:"使尺寸适应行高", style: .default, handler: {
            (action) -> Void in
            self.currentInsertMode = .fitTextLine
            self.pic2BeInserted()
        })
        let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler: {
            (action) -> Void in
            self.passageContent.resignFirstResponder()
        })
        
        // Add options
        alertController.addAction(defaultAction)
        alertController.addAction(fitViewAction)
        alertController.addAction(fitLineAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Select photos from the album and insert the chosen picture
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
    
    @IBAction func imageInsertClicked(_ sender: Any) {
        // Select image attachment mode
            self.selectImageAttachmentMode()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension PassageShareViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    // Deal with a selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectionTableView!.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "SelectCircle2Tag", sender: nil)
        }
    }
    
    // Send data to the new view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

extension PassageShareViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numOfRows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectionCell = self.selectionTableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as! SelectionCell
        
        if indexPath.row == 0 {
            let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "Settings")!, name: "选择圈子")
            selectionCell.loadData2Cell(data: selectionStaticData)
        }
        else {
            let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "Settings")!, name: "你在哪里？")
            selectionCell.loadData2Cell(data: selectionStaticData)
        }
        return selectionCell
    }
    
}

extension PassageShareViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view?.isKind(of: SelectionCell.self) ?? false {
            return false
        }
        
        return true
    }
}


extension PassageShareViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Obtain the original pictures
        let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        // Insert into current text view
        self.insertPicture(pickedImage, mode: self.currentInsertMode)

        // Save the selected picture into the fileManager
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        // The storage path of the image temporary file
        let filePath = "\(rootPath)/picked_image" + "\(self.currentImageNum)" + ".jpg"
        let imageData = pickedImage.jpegData(compressionQuality: 1.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)

        // Upload the picture
        if (fileManager.fileExists(atPath: filePath)){
            // Store the image path
            self.imageAttachmentDict[pickedImage] = filePath
            self.imageModeDict[pickedImage] = "\(self.currentInsertMode)"
            self.currentImageNum += 1
        }
        
        // Exit the image controller
        picker.dismiss(animated: true, completion:nil)
    }

}

extension PassageShareViewController: UITextViewDelegate {
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
        if attrStr.string == "想说什么就说吧..." {
            textView.attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: ""))
            textView.textColor = UIColor.darkText
        }
    }

}

// Extend NSAttributedString to obtain the plain String
extension NSAttributedString {
    func getPlainString(_ imageModeDict: [UIImage: String]) -> String{
        // Variables intialized
        let plainString = NSMutableString(string: self.string)
        let ranges =  NSMakeRange(0, self.length)
        var base = 0
        
        self.enumerateAttribute(NSAttributedString.Key.attachment, in:ranges, options: .longestEffectiveRangeNotRequired)
        { (value, range, error) -> Void in
            if (value != nil) {
                if value is NSTextAttachment {
                    let makeRange = NSMakeRange(range.location+base, range.length)
                    let image = (value as! NSTextAttachment).image
                    let placeholderString: String = "@[img:" + imageModeDict[image!]! + "]"
                    
                    plainString.replaceCharacters(in: makeRange, with: placeholderString)
                    base += placeholderString.count-1
                }
            }
        }
        return plainString as String
    }
    
    func getImageAttachment(_ imageDict: [UIImage: String]) -> [String]{
        // Variables intialized
        var imagePaths: [String] = []
        let ranges =  NSMakeRange(0, self.length)
        
        self.enumerateAttribute(NSAttributedString.Key.attachment, in:ranges, options: .longestEffectiveRangeNotRequired)
        { (value, range, error) -> Void in
            if (value != nil) {
                if value is NSTextAttachment {
                    if let image = (value as! NSTextAttachment).image {
                        imagePaths.append(imageDict[image]!)
                    }
                }
            }
        }
        return imagePaths
    }
}

