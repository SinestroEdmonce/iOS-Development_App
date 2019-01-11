//
//  EnglishContentViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/1.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import MJRefresh

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
        self.englishContentTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.updateResourceData()
        
        // 下拉刷新相关设置,使用闭包Block
        self.englishContentTableView!.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            // 重现生成数据
            self.updateResourceData(true, completeHander: { (result) in
                if result {
                    // 重现加载表格数据
                    DispatchQueue.main.async {
                        self.englishContentTableView.reloadData()
                    }
                }
                // 结束刷新
                self.englishContentTableView.mj_header.endRefreshing()
            })
        })
        
        self.englishContentTableView!.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            // 重现生成数据
            self.updateResourceData(false, completeHander: { (result) in
                if result {
                    // 重现加载表格数据
                    DispatchQueue.main.async {
                        self.englishContentTableView.reloadData()
                    }
                }
                // 结束刷新
                self.englishContentTableView.mj_footer.endRefreshing()
            })
        })
        
        // Do any additional setup after loading the view.
    }
    
    func updateResourceData(_ isInstead: Bool, completeHander: @escaping ((_ isSuccess: Bool)->() )) {
        let sender: NetworkInteract2Backend = NetworkInteract2Backend()
        sender.requestResourceListFromOneServerDatabase(sender.resourceDatabaseAddr, parameters: ["catalog": "test"], completeHandler: { (jsonArray, result) in
            if result {
                if isInstead {
                    self.englishDataResults = EnglishDataStorage(jsonArray: jsonArray!)
                }
                else{
                    self.englishDataResults!.append(jsonArray: jsonArray!)
                }
                completeHander(true)
            }
            else {
                self.networkErrorWarnings()
                completeHander(false)
            }
        })
    }
    
    func updateResourceData() {
        let sender: NetworkInteract2Backend = NetworkInteract2Backend()
        sender.requestResourceListFromOneServerDatabase(sender.resourceDatabaseAddr, parameters: ["catalog": "test"], completeHandler: { (jsonArray, result) in
            if result {
                self.englishDataResults = EnglishDataStorage(jsonArray: jsonArray!)
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let englishCell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceCell
        englishCell.loadData2Cell(data: englishData!)
        
        return englishCell
    }
}

//MARK: - UITableViewDelegate
extension EnglishContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
