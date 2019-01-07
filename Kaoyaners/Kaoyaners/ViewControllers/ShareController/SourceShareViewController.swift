//
//  SourceShareViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class SourceShareViewController: UIViewController {
    @IBOutlet weak var sourceNameContent: UITextField!
    @IBOutlet weak var sourceIntro: UITextView!
    @IBOutlet weak var selectionTableView: UITableView!
    // Constraint used to auto resize the layout when the keyboard is called
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    // Number of selections
    var numOfRows: [String] = ["CATEGORY", "FILE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a reusable cell
        self.selectionTableView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellReuseIdentifier: "SelectionCell")
        
        // Set data source and delegate
        self.selectionTableView.delegate = self
        self.selectionTableView.dataSource = self
        // Set blank table view UI
        self.selectionTableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationName = Notification.Name(rawValue: "sharePageChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["current": 1])
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
            self.performSegue(withIdentifier: "SelectResourceCategory", sender: nil)
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
            let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "Settings")!, name: "选择资源类别")
            selectionCell.loadData2Cell(data: selectionStaticData)
        }
        else {
            let selectionStaticData = ShareSelectionStaticDataModel(image: UIImage(named: "Settings")!, name: "选择资源文件（上传文件）")
            selectionCell.loadData2Cell(data: selectionStaticData)
        }
        return selectionCell
    }
    
}

