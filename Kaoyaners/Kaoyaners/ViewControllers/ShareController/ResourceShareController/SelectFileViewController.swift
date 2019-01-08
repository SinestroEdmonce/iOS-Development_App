//
//  SelectFileViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/7.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

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
                case 0: // Documents selected
                    self.documentVC = self.createDocumentPicker(maxSelected: 1, completeHandler: { (files) in
                        // Handle results
                        print("共选择了\(files.count)个文件，分别如下：")
                        for file in files {
                            print(file)
                        }
                        
                    })
                case 1: // Pictures selected
                    self.albumVC = self.createImagePicker(maxSelected: 3, completeHandler: { (assets) in
                        // Handle results
                        print("共选择了\(assets.count)张图片，分别如下：")
                        for asset in assets {
                            print(asset)
                        }
                        
                    })
                case 3:
                    self.othersVC = self.createOthersPicker(maxSelected: 1, completeHandler: { (files) in
                        // Handle results
                        print("共选择了\(files.count)个文件，分别如下：")
                        for file in files {
                            print(file)
                        }
                        
                    })
                default:
                    break
                }
                self.pageVC.setViewControllers([self.contentController[self.currentPage]], direction: .forward, animated: true, completion: nil)
            }
            else {
                switch currentPage {
                case 0: // Documents selected
                    self.documentVC = self.createDocumentPicker(maxSelected: 1, completeHandler: { (files) in
                        // Handle results
                        print("共选择了\(files.count)个文件，分别如下：")
                        for file in files {
                            print(file)
                        }
                        
                    })
                case 1: // Pictures selected
                    self.albumVC = self.createImagePicker(maxSelected: 3, completeHandler: { (assets) in
                        // Handle results
                        print("共选择了\(assets.count)张图片，分别如下：")
                        for asset in assets {
                            print(asset)
                        }
                        
                    })
                case 3:
                    self.othersVC = self.createOthersPicker(maxSelected: 1, completeHandler: { (files) in
                        // Handle results
                        print("共选择了\(files.count)个文件，分别如下：")
                        for file in files {
                            print(file)
                        }
                        
                    })
                default:
                    break
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
        self.documentVC = self.createDocumentPicker(maxSelected: 1, completeHandler: { (files) in
            // Handle results
            print("共选择了\(files.count)个文件，分别如下：")
            for file in files {
                print(file)
            }
            
        })
        self.albumVC = self.createImagePicker(maxSelected: 3, completeHandler: { (assets) in
            // Handle results
            print("共选择了\(assets.count)张图片，分别如下：")
            for asset in assets {
                print(asset)
            }
            
        })
        self.musicVC = storyboard?.instantiateViewController(withIdentifier: "MusicVCID") as? MusicViewController
        self.othersVC = self.createOthersPicker(maxSelected: 1, completeHandler: { (files) in
            // Handle results
            print("共选择了\(files.count)个文件，分别如下：")
            for file in files {
                print(file)
            }
            
        })
        
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
            self.albumVC = self.createImagePicker(maxSelected: 3, completeHandler: { (assets) in
                // Handle results
                print("共选择了\(assets.count)张图片，分别如下：")
                for asset in assets {
                    print(asset)
                }
                
            })
            return self.albumVC
        }
        if viewController.isKind(of: PictureViewController.self){
            return self.musicVC
        }
        if viewController.isKind(of: MusicViewController.self){
            self.othersVC = self.createOthersPicker(maxSelected: 1, completeHandler: { (files) in
                // Handle results
                print("共选择了\(files.count)个文件，分别如下：")
                for file in files {
                    print(file)
                }
                
            })
            return self.othersVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: PictureViewController.self){
            self.documentVC = self.createDocumentPicker(maxSelected: 1, completeHandler: { (files) in
                // Handle results
                print("共选择了\(files.count)个文件，分别如下：")
                for file in files {
                    print(file)
                }
                
            })
            return self.documentVC
        }
        if viewController.isKind(of: MusicViewController.self){
            self.albumVC = self.createImagePicker(maxSelected: 3, completeHandler: { (assets) in
                // Handle results
                print("共选择了\(assets.count)张图片，分别如下：")
                for asset in assets {
                    print(asset)
                }
                
            })
            return self.albumVC
        }
        if viewController.isKind(of: OthersViewController.self){
            return self.musicVC
        }
        return nil
    }
    
}

