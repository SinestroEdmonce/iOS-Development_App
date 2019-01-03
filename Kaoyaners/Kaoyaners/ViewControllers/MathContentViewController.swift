//
//  MathViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/1.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class MathContentViewController: UIViewController {
    @IBOutlet weak var mathContentTableView: UITableView!
    // A variable used to store the data from the 'math' category
    var mathDataResults: MathDataStorage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a reusable cell
        self.mathContentTableView.register(UINib(nibName: "ResourceCell", bundle: nil), forCellReuseIdentifier: "ResourceCell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Sender an index named 'currentPageChanged'
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 0)
    }

}

extension MathContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = self.mathDataResults {
            return results.mathDataResults.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mathData = self.mathDataResults?.mathDataResults[indexPath.row]

        let mathCell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceCell
        // TODO: Load data
        
        return mathCell
    }
    
}
