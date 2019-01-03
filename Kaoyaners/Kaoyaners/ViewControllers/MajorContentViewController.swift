//
//  MajorContentViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/1.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class MajorContentViewController: UIViewController {
    @IBOutlet weak var majorContentTableView: UITableView!
    // A variable used to store the data from the 'major' category
    var majorDataResults: MajorDataStorage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register a reusable cell
        self.majorContentTableView.register(UINib(nibName: "ResourceCell", bundle: nil), forCellReuseIdentifier: "ResourceCell")
        // Do any additional setup after loading the view.
    }
    
}

extension MajorContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = self.majorDataResults {
            return results.majorDataResults.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let majorData = self.majorDataResults?.majorDataResults[indexPath.row]
        
        let majorCell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceCell
        // TODO: Load data
        
        return majorCell
    }
    
}
