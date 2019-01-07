//
//  ResourceViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/1.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class ResourceViewController: UIViewController {
    // Variable used to describe UIPageVC
    var pageVC: UIPageViewController!
    
    // Four categories of resource
    var mathContentVC: MathContentViewController!
    var englishContentVC: EnglishContentViewController!
    var politicContentVC: PoliticContentViewController!
    var majorContentVC: MajorContentViewController!
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
            let pageOffset = (self.view.frame.width/4.0)*CGFloat(self.currentPage)
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
        self.mathContentVC = storyboard?.instantiateViewController(withIdentifier: "MathContentVCID") as? MathContentViewController
        self.englishContentVC = storyboard?.instantiateViewController(withIdentifier: "EnglishContentVCID") as? EnglishContentViewController
        self.politicContentVC = storyboard?.instantiateViewController(withIdentifier: "PoliticContentVCID") as? PoliticContentViewController
        self.majorContentVC = storyboard?.instantiateViewController(withIdentifier: "MajorContentVCID") as? MajorContentViewController
        
        // Set data source delegate of pageViewController the current controller
        self.pageVC.dataSource = self
        // Manually provide a page for pageViewController
        self.pageVC.setViewControllers([self.mathContentVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        // Add views into the view data array
        self.contentController.append(self.mathContentVC)
        self.contentController.append(self.englishContentVC)
        self.contentController.append(self.politicContentVC)
        self.contentController.append(self.majorContentVC)
        
        // Add slider image
        self.sliderImageView = UIImageView(frame: CGRect(x: 0, y: -1, width: self.view.frame.width / 4.0, height: 3.0))
        self.sliderImageView.image = UIImage(named: "AvatarBackground")
        self.sliderView.addSubview(sliderImageView)
        
        // Accept the notification to tell whether the page been changed
        NotificationCenter.default.addObserver(self, selector: #selector(currentPageChanged(notification:)), name: NSNotification.Name(rawValue: "currentPageChanged"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    // Methods to response the notification
    @objc func currentPageChanged(notification: NSNotification) {
        self.currentPage = notification.object as! Int
    }
    
    // Change the current page to another one
    @IBAction func changeCurrentPage(_ sender: Any) {
        self.currentPage = (sender as! UIButton).tag - 100
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ResourceViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: MathContentViewController.self){
            return self.englishContentVC
        }
        else if viewController.isKind(of: EnglishContentViewController.self){
            return self.politicContentVC
        }
        else if viewController.isKind(of: PoliticContentViewController.self){
            return self.majorContentVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: EnglishContentViewController.self){
            return self.mathContentVC
        }
        else if viewController.isKind(of: PoliticContentViewController.self){
            return self.englishContentVC
        }
        else if viewController.isKind(of: MajorContentViewController.self){
            return self.politicContentVC
        }
        return nil
    }
    
}
