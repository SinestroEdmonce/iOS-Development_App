//
//  PassageShareViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class PassageShareViewController: UIViewController {
    @IBOutlet weak var passageContent: UITextView!
    @IBOutlet weak var selectionTableView: UITableView!
    
    // Number of selections
    var numOfRows: [String] = ["CIRCLES", "WHERE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a reusable cell
        self.selectionTableView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellReuseIdentifier: "SelectionCell")
        
        // Set data source and delegate
        self.selectionTableView.delegate = self
        self.selectionTableView.dataSource = self
        
        self.selectionTableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationName = Notification.Name(rawValue: "sharePageChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["current": 0])
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
