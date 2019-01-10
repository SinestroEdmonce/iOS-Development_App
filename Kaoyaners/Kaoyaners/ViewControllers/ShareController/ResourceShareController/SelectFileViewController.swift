//
//  SelectFileViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/7.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import Photos

class SelectFileViewController: UIViewController {
    // Variable used to describe UIPageVC
    var pageVC: UIPageViewController!
    
    // Four categories of resource
    var documentVC: DocumentViewController!
    var albumVC: PictureViewController!
    var musicVC: MusicViewController!
    var othersVC: OthersViewController!
    // View data array used to store the four view controllers
    var contentController = [UIViewController]()
    
    // Slider view used as a reminder to reflect actions
    @IBOutlet weak var sliderView: UIView!
    var sliderImageView: UIImageView!
    // App settings
    let appSettings: AppSettings = AppSettings()
    
    // Variables used to help change the pages
    var lastPage = 0
    var currentPage: Int = 0 {
        // Attributes observation
        didSet {
            // According to the current page, obtain the offset
            // A tiny motion animation
            let pageOffset = (self.view.frame.width/4)*CGFloat(self.currentPage)
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.sliderImageView.frame.origin = CGPoint(x: pageOffset, y: -1)
            }
            
            // According to the relationship between the current page and last page, change the page view
            if currentPage > lastPage {
                switch currentPage {
                case 1: // Pictures selected
                    self.albumVC = self.createImagePicker(maxSelected: self.appSettings.maxPicturesUpload, completeHandler: { (assets) in
                        // Handle results
                        self.phasset2Path(assets)
                        
                    })
                default: break
                }
                self.pageVC.setViewControllers([self.contentController[self.currentPage]], direction: .forward, animated: true, completion: nil)
            }
            else {
                switch currentPage {
                case 1: // Pictures selected
                    self.albumVC = self.createImagePicker(maxSelected: self.appSettings.maxPicturesUpload, completeHandler: { (assets) in
                        // Handle results
                        self.phasset2Path(assets)
                        
                    })
                default:break
                }
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
        self.documentVC = self.createDocumentPicker(maxSelected: self.appSettings.maxFilesUpload, completeHandler: nil)
        self.albumVC = self.createImagePicker(maxSelected: self.appSettings.maxPicturesUpload, completeHandler: { (assets) in
            // Handle results
            self.phasset2Path(assets)
            
        })
        self.musicVC = storyboard?.instantiateViewController(withIdentifier: "MusicVCID") as? MusicViewController
        self.othersVC = self.createOthersPicker(maxSelected: self.appSettings.maxFilesUpload, completeHandler: nil)
        
        // Set data source delegate of pageViewController the current controller
        self.pageVC.dataSource = self
        // Manually provide a page for pageViewController
        self.pageVC.setViewControllers([self.documentVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        // Add views into the view data array
        self.contentController.append(self.documentVC)
        self.contentController.append(self.albumVC)
        self.contentController.append(self.musicVC)
        self.contentController.append(self.othersVC)
        
        // Add slider image
        self.sliderImageView = UIImageView(frame: CGRect(x: 0, y: -1, width: self.view.frame.width/4, height: 3.0))
        self.sliderImageView.image = UIImage(named: "AvatarBackground")
        self.sliderView.addSubview(sliderImageView)
        
        // Accept the notification to tell whether the page been changed
        let notificationName = Notification.Name(rawValue: "fileSelectionPageChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(self.fileSelectionCurrentPageChanged(notification:)), name: notificationName, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    // Methods to response the notification
    @objc func fileSelectionCurrentPageChanged(notification: Notification){
        let userInfo = notification.userInfo as! [String: AnyObject]
        let curPage = userInfo["current"] as! Int
        self.currentPage = curPage
    }
    
    // Change the current page to another one
    @IBAction func changeCurrentPage(_ sender: Any) {
        self.currentPage = (sender as! UIButton).tag - 700
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        switch self.currentPage {
        case 0:
            var fileInfo: [[String]] = []
            var fileNames: [String] = []
            var filePaths: [String] = []
            if (self.documentVC.tableView.indexPathsForSelectedRows?.count ?? 0) > 0{
                for indexPath in self.documentVC.tableView.indexPathsForSelectedRows! {
                    fileNames.append(self.documentVC.items[indexPath.row].fileName!)
                    filePaths.append(self.documentVC.items[indexPath.row].filePath!)
                }
            }
            fileInfo.append(fileNames)
            fileInfo.append(filePaths)
            let notificationName = Notification.Name(rawValue: "fileSelectedStatusChanged")
            NotificationCenter.default.post(name: notificationName, object: self,
                                            userInfo: ["files": fileInfo, "type": 0])
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        case 3:
            var fileInfo: [[String]] = []
            var fileNames: [String] = []
            var filePaths: [String] = []
            print("\(self.othersVC.tableView.indexPathsForSelectedRows)")
            if (self.othersVC.tableView.indexPathsForSelectedRows?.count ?? 0) > 0{
                for indexPath in self.othersVC.tableView.indexPathsForSelectedRows! {
                    fileNames.append(self.othersVC.items[indexPath.row].fileName!)
                    filePaths.append(self.othersVC.items[indexPath.row].filePath!)
                }
            }
            fileInfo.append(fileNames)
            fileInfo.append(filePaths)
            let notificationName = Notification.Name(rawValue: "fileSelectedStatusChanged")
            NotificationCenter.default.post(name: notificationName, object: self,
                                            userInfo: ["files": fileInfo, "type": 0])
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        default: break
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    // Give back address
    func phasset2Path(_ assets: [PHAsset]) {
        
        var assetPath: [URL] = []
        for asset in assets {
                if asset.mediaType == .image {
                PHCachingImageManager().requestImage(for: asset as PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options:nil, resultHandler: { (image, info) in
                    let imageURL = ((info! as NSDictionary).object(forKey:"PHImageFileURLKey") as! URL)
                    assetPath.append(imageURL)
                    
                })

            }
            else if asset.mediaType == .video {
                    PHCachingImageManager().requestAVAsset(forVideo: asset as PHAsset, options:nil, resultHandler: { (asset, audioMix, info) in
                        let strArr = ((info! as NSDictionary).object(forKey:"PHImageFileSandboxExtensionTokenKey") as! NSString).components(separatedBy:";")
                        let videoPath = strArr.last!
                        assetPath.append(URL(fileURLWithPath: videoPath))
                    })
            }
        }
        let notificationName = Notification.Name(rawValue: "fileSelectedStatusChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["files": assetPath, "type": 1])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SelectFileViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: DocumentViewController.self) {
            self.albumVC = self.createImagePicker(maxSelected: self.appSettings.maxPicturesUpload, completeHandler: { (assets) in
                // Handle results
                self.phasset2Path(assets)
                
            })
            return self.albumVC
        }
        if viewController.isKind(of: PictureViewController.self){
            return self.musicVC
        }
        if viewController.isKind(of: MusicViewController.self){
            return self.othersVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: PictureViewController.self){
            return self.documentVC
        }
        if viewController.isKind(of: MusicViewController.self){
            self.albumVC = self.createImagePicker(maxSelected: self.appSettings.maxPicturesUpload, completeHandler: { (assets) in
                // Handle results
                self.phasset2Path(assets)
                
            })
            return self.albumVC
        }
        if viewController.isKind(of: OthersViewController.self){
            return self.musicVC
        }
        return nil
    }
    
}


