//
//  MajorContentViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/1.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import MJRefresh

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
        self.majorContentTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.majorContentTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.updateResourceData()
        
        // 下拉刷新相关设置,使用闭包Block
        self.majorContentTableView!.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            // 重现生成数据
            self.updateResourceData(true, completeHander: { (result) in
                if result {
                    // 重现加载表格数据
                    DispatchQueue.main.async {
                        self.majorContentTableView.reloadData()
                    }
                }
                // 结束刷新
                self.majorContentTableView.mj_header.endRefreshing()
            })
        })
        
        self.majorContentTableView!.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            // 重现生成数据
            self.updateResourceData(false, completeHander: { (result) in
                if result {
                    // 重现加载表格数据
                    DispatchQueue.main.async {
                        self.majorContentTableView.reloadData()
                    }
                }
                // 结束刷新
                self.majorContentTableView.mj_footer.endRefreshing()
            })
        })
        
        // Do any additional setup after loading the view.
    }
    
    func updateResourceData(_ isInstead: Bool, completeHander: @escaping ((_ isSuccess: Bool)->() )) {
        let sender: NetworkInteract2Backend = NetworkInteract2Backend()
        sender.requestResourceListFromOneServerDatabase(sender.resourceDatabaseAddr, parameters: ["catalog": "test"], completeHandler: { (jsonArray, result) in
            if result {
                if isInstead {
                    self.majorDataResults = MajorDataStorage(jsonArray: jsonArray!)
                }
                else{
                    self.majorDataResults!.append(jsonArray: jsonArray!)
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
                self.majorDataResults = MajorDataStorage(jsonArray: jsonArray!)
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        majorCell.loadData2Cell(data: majorData!)
        
        return majorCell
    }
}

//MARK: - UITableViewDelegate
extension MajorContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
