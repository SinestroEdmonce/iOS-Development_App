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
        // Set data source and delegate
        self.majorContentTableView.dataSource = self
        self.majorContentTableView.delegate = self
        
        var data = [NSDictionary]()
        data.append(["images": "?","category": "?","subject": "?","owner": "?","srcname": "?","srcintro": "?","revcounter": "1"])
        data.append(["images": "?","category": "?","subject": "?","owner": "?","srcname": "?","srcintro": "?","revcounter": "1"])
        
        self.majorDataResults = MajorDataStorage(dicts: data)
        self.majorContentTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Sender an index named 'currentPageChanged'
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 3)
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
        let defaultData = ResourceDataModel(imageURL: "?",resourceCategory: "?",subjectName: "?",ownerName: "?",resourceName: "?",resourceIntro: "?",reviewCounter: "?")
        
        let majorCell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceCell
        majorCell.loadData2Cell(data: majorData ?? defaultData)
        
        return majorCell
    }
}

//MARK: - UITableViewDelegate
extension MajorContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
