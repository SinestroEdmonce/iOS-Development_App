//
//  LoginRegisterViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {
    // Variable used to describe UIPageVC
    var pageVC: UIPageViewController!
    
    // Four categories of resource
    var registerVC: RegisterViewController!
    var loginVC: LoginViewController!
    // View data array used to store the four view controllers
    var contentController = [UIViewController]()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
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
        self.registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterVCID") as? RegisterViewController
        self.loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVCID") as? LoginViewController
        
        // Set data source delegate of pageViewController the current controller
        self.pageVC.dataSource = self
        // Manually provide a page for pageViewController
        self.pageVC.setViewControllers([self.registerVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        // Add views into the view data array
        self.contentController.append(self.registerVC)
        self.contentController.append(self.loginVC)
        
        // Add slider image
        self.sliderImageView = UIImageView(frame: CGRect(x: 0, y: -1, width: self.view.frame.width/2, height: 5.0))
        self.sliderImageView.image = UIImage(named: "AvatarBackground")
        self.sliderView.addSubview(sliderImageView)
        
        // Accept the notification to tell whether the page been changed
        let notificationName = Notification.Name(rawValue: "loginPageChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(loginCurrentPageChanged(notification:)), name: notificationName, object: nil)
        
        // Declare a tap gesture for hiding keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(self.tap4HideKeyboard(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(hideTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
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
    
    // Methods to response the notification
    @objc func loginCurrentPageChanged(notification: Notification){
        let userInfo = notification.userInfo as! [String: AnyObject]
        let curPage = userInfo["current"] as! Int
        self.currentPage = curPage
    }
    
    // Change the current page to another one
    @IBAction func changeCurrentPage(_ sender: Any) {
        self.currentPage = (sender as! UIButton).tag - 600
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginRegisterViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: RegisterViewController.self){
            return self.loginVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: LoginViewController.self){
            return self.registerVC
        }
        return nil
    }
    
}
