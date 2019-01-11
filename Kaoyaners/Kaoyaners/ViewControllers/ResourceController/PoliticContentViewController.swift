//
//  PoliticContentViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/1.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import MJRefresh

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
        self.politicContentTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.updateResourceData()
        // 下拉刷新相关设置,使用闭包Block
        self.politicContentTableView!.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            // 重现生成数据
            self.updateResourceData(true, completeHander: { (result) in
                if result {
                    // 重现加载表格数据
                    DispatchQueue.main.async {
                        self.politicContentTableView.reloadData()
                    }
                }
                // 结束刷新
                self.politicContentTableView.mj_header.endRefreshing()
            })
        })
        
        self.politicContentTableView!.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            // 重现生成数据
            self.updateResourceData(false, completeHander: { (result) in
                if result {
                    // 重现加载表格数据
                    DispatchQueue.main.async {
                        self.politicContentTableView.reloadData()
                    }
                }
                // 结束刷新
                self.politicContentTableView.mj_footer.endRefreshing()
            })
        })
        
        // Do any additional setup after loading the view.
    }
    
    func updateResourceData(_ isInstead: Bool, completeHander: @escaping ((_ isSuccess: Bool)->() )) {
        let sender: NetworkInteract2Backend = NetworkInteract2Backend()
        sender.requestResourceListFromOneServerDatabase(sender.resourceDatabaseAddr, parameters: ["catalog": "test"], completeHandler: { (jsonArray, result) in
            if result {
                if isInstead {
                    self.politicDataResults = PoliticDataStorage(jsonArray: jsonArray!)
                }
                else{
                    self.politicDataResults!.append(jsonArray: jsonArray!)
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
                self.politicDataResults = PoliticDataStorage(jsonArray: jsonArray!)
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let politicCell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceCell
        politicCell.loadData2Cell(data: politicData!)
        
        return politicCell
    }
}

//MARK: - UITableViewDelegate
extension PoliticContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
