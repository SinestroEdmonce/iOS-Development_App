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
        self.pageVC = self.children.first as? UIPageViewController
        // According to Storyboard ID to initialize the variables
        self.mathContentVC = storyboard?.instantiateViewController(withIdentifier: "MathContentVCID") as? MathContentViewController
        self.englishContentVC = storyboard?.instantiateViewController(withIdentifier: "EnglishContentVCID") as? EnglishContentViewController
        self.politicContentVC = storyboard?.instantiateViewController(withIdentifier: "PoliticContentVCID") as? PoliticContentViewController
        self.majorContentVC = storyboard?.instantiateViewController(withIdentifier: "MajorContentVCID") as? MajorContentViewController
        

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ResourceViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: MathContentViewController){
            return self.englishContentVC
        }
        else if 
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    
}
