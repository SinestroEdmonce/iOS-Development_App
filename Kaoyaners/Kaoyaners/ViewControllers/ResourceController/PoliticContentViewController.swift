//
//  PoliticContentViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/1.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class PoliticContentViewController: UIViewController {
    @IBOutlet weak var politicContentTableView: UITableView!
    
    // A variable used to store the data from the 'politic' category
    var politicDataResults: PoliticDataStorage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register a reusable cell
        self.politicContentTableView.register(UINib(nibName: "ResourceCell", bundle: nil), forCellReuseIdentifier: "ResourceCell")
        // Set data source and delegate
        self.politicContentTableView.dataSource = self
        self.politicContentTableView.delegate = self
        self.politicContentTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        var data = [NSDictionary]()
        data.append(["images": "?","category": "?","subject": "?","owner": "?","srcname": "?","srcintro": "?","revcounter": "1"])
        data.append(["images": "?","category": "?","subject": "?","owner": "?","srcname": "?","srcintro": "?","revcounter": "1"])
        
        self.politicDataResults = PoliticDataStorage(dicts: data)
        self.politicContentTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Sender an index named 'currentPageChanged'
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 2)
    }
}

extension PoliticContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = self.politicDataResults {
            return results.politicDataResults.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let politicData = self.politicDataResults?.politicDataResults[indexPath.row]
        let defaultData = ResourceDataModel(imageURL: "?",resourceCategory: "?",subjectName: "?",ownerName: "?",resourceName: "?",resourceIntro: "?",reviewCounter: "?")
        
        let politicCell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceCell
        politicCell.loadData2Cell(data: politicData ?? defaultData)
        
        return politicCell
    }
}

//MARK: - UITableViewDelegate
extension PoliticContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
