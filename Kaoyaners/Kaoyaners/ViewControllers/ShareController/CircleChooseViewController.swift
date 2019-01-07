//
//  CircleChooseViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class CircleChooseViewController: UIViewController {
    // Variable used to describe UIPageVC
    var pageVC: UIPageViewController!
    
    // Four categories of resource
    var favSearchVC: FavCircleSearchViewController!
    var otherSearchVC: OtherCircleSearchViewController!
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
        self.favSearchVC = storyboard?.instantiateViewController(withIdentifier: "FavCircleSearchVCID") as? FavCircleSearchViewController
        self.otherSearchVC = storyboard?.instantiateViewController(withIdentifier: "OtherCircleSearchVCID") as? OtherCircleSearchViewController
        
        // Set data source delegate of pageViewController the current controller
        self.pageVC.dataSource = self
        // Manually provide a page for pageViewController
        self.pageVC.setViewControllers([self.favSearchVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        // Add views into the view data array
        self.contentController.append(self.favSearchVC)
        self.contentController.append(self.otherSearchVC)
        
        // Add slider image
        self.sliderImageView = UIImageView(frame: CGRect(x: 0, y: -1, width: self.view.frame.width/2, height: 3.0))
        self.sliderImageView.image = UIImage(named: "AvatarBackground")
        self.sliderView.addSubview(sliderImageView)
        
        // Accept the notification to tell whether the page been changed
        let notificationName = Notification.Name(rawValue: "circleChoosePageChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(circleChooseCurrentPageChanged(notification:)), name: notificationName, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    // Methods to response the notification
    @objc func circleChooseCurrentPageChanged(notification: Notification){
        let userInfo = notification.userInfo as! [String: AnyObject]
        let curPage = userInfo["current"] as! Int
        self.currentPage = curPage
    }
    
    // Change the current page to another one
    @IBAction func changeCurrentPage(_ sender: Any) {
        self.currentPage = (sender as! UIButton).tag - 500
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension CircleChooseViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: FavCircleSearchViewController.self){
            return self.otherSearchVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: OtherCircleSearchViewController.self){
            return self.favSearchVC
        }
        return nil
    }
    
}


