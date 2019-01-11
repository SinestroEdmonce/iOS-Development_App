//
//  ShareViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    // Variable used to describe UIPageVC
    var pageVC: UIPageViewController!
    
    // Four categories of resource
    var passageShareVC: PassageShareViewController!
    var sourceShareVC: SourceShareViewController!
    // View data array used to store the four view controllers
    var contentController = [UIViewController]()
    // View that contain every subview
    @IBOutlet var contentView: UIView!
    // Slider view used as a reminder to reflect actions
    @IBOutlet weak var sliderView: UIView!
    var sliderImageView: UIImageView!
    @IBOutlet weak var button4Send: UIButton!
    
    // Variables used to help change the pages
    var lastPage = 0
    var currentPage: Int = 0 {
        // Attributes observation
        didSet {
            // According to the current page, obtain the offset
            // A tiny motion animation
            let pageOffset = (self.view.frame.width/2)*CGFloat(self.currentPage)
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.sliderImageView.frame.origin = CGPoint(x: pageOffset, y: -1)
            }
            
            // According to the relationship between the current page and last page, change the page view
            if currentPage > lastPage {
                self.pageVC.setViewControllers([self.contentController[self.currentPage]], direction: .forward, animated: true, completion: nil)
            }
            else {
                self.pageVC.setViewControllers([self.contentController[self.currentPage]], direction: .reverse, animated: true, completion: nil)
            }
            
            self.lastPage = self.currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Obtain the page view controller
        for childVC in self.children {
            if childVC.isKind(of: UIPageViewController.self){
                self.pageVC = childVC as? UIPageViewController
                break
            }
        }
        
        // According to Storyboard ID to initialize the variables
        self.passageShareVC = storyboard?.instantiateViewController(withIdentifier: "PassageShareVCID") as? PassageShareViewController
        self.sourceShareVC = storyboard?.instantiateViewController(withIdentifier: "SourceShareVCID") as? SourceShareViewController
        
        // Set data source delegate of pageViewController the current controller
        self.pageVC.dataSource = self
        // Manually provide a page for pageViewController
        self.pageVC.setViewControllers([self.passageShareVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        // Add views into the view data array
        self.contentController.append(self.passageShareVC)
        self.contentController.append(self.sourceShareVC)
        
        // Add slider image
        self.sliderImageView = UIImageView(frame: CGRect(x: 0, y: -1, width: self.view.frame.width/2, height: 3.0))
        self.sliderImageView.image = UIImage(named: "_slider")
        self.sliderView.addSubview(sliderImageView)
        
        // Accept the notification to tell whether the page been changed
        let notificationName = Notification.Name(rawValue: "sharePageChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(shareCurrentPageChanged(notification:)), name: notificationName, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    // Methods to response the notification
    @objc func shareCurrentPageChanged(notification: Notification){
        let userInfo = notification.userInfo as! [String: AnyObject]
        let curPage = userInfo["current"] as! Int
        self.currentPage = curPage
    }
    
    // Change the current page to another one
    @IBAction func changeCurrentPage(_ sender: Any) {
        self.currentPage = (sender as! UIButton).tag - 400
    }
    
    @IBAction func sendClicked(_ sender: Any) {
        if self.currentPage == 0 {
            if self.passageShareVC.isAble2Send() {
                let articleContent = self.passageShareVC.packArticleInfo()
                let textPackage = self.generateArticlePackage(articleContent[0][0])
                let imagePackage = self.generateImagePackage(articleContent[1].count, articleId: textPackage["article_id"]!)
                
                let sender: NetworkInteract2Backend = NetworkInteract2Backend()
                sender.multipartArticleUpload(targetAddr: sender.postArticlesAddr, parameters: textPackage, completeHandler: { (result) in
                    if result {
                        if imagePackage.count > 0 {
                            sender.multipartMultiFilesUpload2SameURL(articleContent[1], targetAddr: sender.uploadImageInArticleAddr, parameters: imagePackage, completeHandler: { (result) in
                                self.judgeUploadSituation(result)
                            })
                        }
                        else {
                            self.judgeUploadSituation(result)
                        }
                        self.passageShareVC.contentTextView.resignFirstResponder()
                    }
                    else {
                        self.judgeUploadSituation(result)
                    }
                    
                })
            }
            else {
                self.isNotAble2Send()
            }
        }
        else {
            if self.sourceShareVC.isAble2Send(){
                let resourcePackage = self.sourceShareVC.packResourceInfo()
                
                let sender: NetworkInteract2Backend = NetworkInteract2Backend()
                sender.multipartOneFileUpload(resourcePackage["file_path"]!, targetAddr: sender.postResourcesAddr, parameters: resourcePackage, completeHandler: { (result) in
                    self.judgeUploadSituation(result)
                    
                    self.sourceShareVC.srcIntro.resignFirstResponder()
                    self.sourceShareVC.srcName.resignFirstResponder()
                    
                    self.sourceShareVC.cleanCellContent()
                })
            }
            else {
                self.isNotAble2Send()
            }
        }
    }
    
    func isNotAble2Send() {
        let title = "请将内容补充完整: 名称、介绍和文件都需要填写！"
        let alertController = UIAlertController(title: title, message: nil,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title:"好的", style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func judgeUploadSituation(_ isSuccess: Bool) {
        if isSuccess {
            let title = "发布成功！"
            let alertController = UIAlertController(title: title, message: nil,
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title:"好的", style: .cancel,
                                             handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            if self.currentPage == 0 {
                self.passageShareVC.contentTextView.text = ""
            }
            else {
                self.sourceShareVC.srcIntro.text = ""
                self.sourceShareVC.srcName.text = ""
            }
        }
        else {
            let title = "网络请求超时！请重试！"
            let alertController = UIAlertController(title: title, message: nil,
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title:"好的", style: .cancel,
                                             handler:nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Generate the package of article information
    func generateArticlePackage(_ text: String) -> [String: String] {
        var packDict: [String: String] = [:]
        let dataStorage: DataPersistenceService = DataPersistenceService()
        
        // Obtain the time stamp
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        packDict["id"] = dataStorage.getCurrentUserId(key: dataStorage.userIdKey)
        packDict["article_id"] = "id" + "_" + dataStorage.getCurrentUserId(key: dataStorage.userIdKey) + "_" + "\(timeStamp)"
        packDict["name"] = "name" + "_" + dataStorage.getCurrentUserId(key: dataStorage.userIdKey) + "_" + "\(timeStamp)"
        packDict["content"] = text
        packDict["circle"] = "test"
        
        return packDict
    }
    
    // Generate the package of article information
    func generateImagePackage(_ imageAmount: Int, articleId: String) -> [[String: String]] {
        var packDict: [[String: String]] = []
        
        for _ in 0..<imageAmount{
            packDict.append(["id": articleId])
        }
        
        return packDict
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShareViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: PassageShareViewController.self){
            return self.sourceShareVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: SourceShareViewController.self){
            return self.passageShareVC
        }
        return nil
    }
    
}
