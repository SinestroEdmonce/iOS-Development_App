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
        // Set data source and delegate
        self.mathContentTableView.dataSource = self
        self.mathContentTableView.delegate = self
        self.mathContentTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.mathContentTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.updateResourceData()
        // Do any additional setup after loading the view.
    }
    
    func updateResourceData() {
        let sender: NetworkInteract2Backend = NetworkInteract2Backend()
        sender.requestResourceListFromOneServerDatabase(sender.resourceDatabaseAddr, parameters: ["catalog": "test"], completeHandler: { (jsonArray, result) in
            if result {
                self.mathDataResults = MathDataStorage(jsonArray: jsonArray!)
                DispatchQueue.main.async {
                    self.mathContentTableView.reloadData()
                }
            }
            else {
                self.networkErrorWarnings()
            }
        })
    }
    
    func networkErrorWarnings() {
        let title = "网络请求超时！请刷新重试！"
        let alertController = UIAlertController(title: title, message: nil,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title:"好的", style: .cancel,
                                         handler:nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Sender an index named 'currentPageChanged'
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        mathCell.loadData2Cell(data: mathData!)
        
        return mathCell
    }
}

//MARK: - UITableViewDelegate
extension MathContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

