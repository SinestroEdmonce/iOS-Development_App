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


        // Do any additional setup after loading the view.
    }

}

extension ResourceViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
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
