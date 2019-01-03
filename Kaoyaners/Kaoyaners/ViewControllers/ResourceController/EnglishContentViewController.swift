//
//  EnglishContentViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/1.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class EnglishContentViewController: UIViewController {
    @IBOutlet weak var englishContentTableView: UITableView!
    // A variable used to store the data from the 'english' category
    var englishDataResults: EnglishDataStorage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register a reusable cell
        self.englishContentTableView.register(UINib(nibName: "ResourceCell", bundle: nil), forCellReuseIdentifier: "ResourceCell")
        // Set data source and delegate
        self.englishContentTableView.dataSource = self
        self.englishContentTableView.delegate = self
        self.englishContentTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        var data = [NSDictionary]()
        data.append(["images": "?","category": "?","subject": "?","owner": "?","srcname": "?","srcintro": "?","revcounter": "1"])
        data.append(["images": "?","category": "?","subject": "?","owner": "?","srcname": "?","srcintro": "?","revcounter": "1"])
        
        self.englishDataResults = EnglishDataStorage(dicts: data)
        self.englishContentTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Sender an index named 'currentPageChanged'
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 1)
    }
}

extension EnglishContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = self.englishDataResults {
            return results.englishDataResults.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let englishData = self.englishDataResults?.englishDataResults[indexPath.row]
        let defaultData = ResourceDataModel(imageURL: "?",resourceCategory: "?",subjectName: "?",ownerName: "?",resourceName: "?",resourceIntro: "?",reviewCounter: "?")
        
        let englishCell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceCell
        englishCell.loadData2Cell(data: englishData ?? defaultData)
        
        return englishCell
    }
}

//MARK: - UITableViewDelegate
extension EnglishContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
