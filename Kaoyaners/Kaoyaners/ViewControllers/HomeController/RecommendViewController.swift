//
//  RecommendViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/3.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import MJRefresh

class RecommendViewController: UIViewController {
    @IBOutlet weak var contentTableView: UITableView!
    var recmdArticleResults:RecmdArticleDataStorage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register a reusable cell
        self.contentTableView.register(UINib(nibName: "CircleContentCell", bundle: nil), forCellReuseIdentifier: "ArticleContentCell")
        // Set data source and delegate
        self.contentTableView.dataSource = self
        self.contentTableView.delegate = self
        self.contentTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.contentTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.updateArticlesData()
        
        // 下拉刷新相关设置,使用闭包Block
        self.contentTableView!.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            // 重现生成数据
            self.updateArticlesData(true, completeHander: { (result) in
                if result {
                    // 重现加载表格数据
                    DispatchQueue.main.async {
                        self.contentTableView.reloadData()
                    }
                }
                // 结束刷新
                self.contentTableView.mj_header.endRefreshing()
            })
        })
        
        self.contentTableView!.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            // 重现生成数据
            self.updateArticlesData(false, completeHander: { (result) in
                if result {
                    // 重现加载表格数据
                    DispatchQueue.main.async {
                        self.contentTableView.reloadData()
                    }
                }
                // 结束刷新
                self.contentTableView.mj_footer.endRefreshing()
            })
        })
        
        // Do any additional setup after loading the view.
    }
    
    func updateArticlesData(_ isInstead: Bool, completeHander: @escaping ((_ isSuccess: Bool)->() )) {
        let sender: NetworkInteract2Backend = NetworkInteract2Backend()
        sender.requestArticleListDataFromOneServerDatabase(sender.articleDatabaseAddr, parameters: ["number": "\(AppSettings().maxArticlesInList)"], completeHandler: { (jsonArray, result) in
            if result {
                if isInstead {
                    self.recmdArticleResults = RecmdArticleDataStorage(jsonArray: jsonArray!)
                }
                else {
                    self.recmdArticleResults!.append(jsonArray: jsonArray!)
                }
                completeHander(true)
            }
            else {
                self.networkErrorWarnings()
                completeHander(false)
            }
        })
    }
    
    func updateArticlesData() {
        let sender: NetworkInteract2Backend = NetworkInteract2Backend()
        sender.requestArticleListDataFromOneServerDatabase(sender.articleDatabaseAddr, parameters: ["number": "\(AppSettings().maxArticlesInList)"], completeHandler: { (jsonArray, result) in
            if result {
                self.recmdArticleResults = RecmdArticleDataStorage(jsonArray: jsonArray!)
                DispatchQueue.main.async {
                    self.contentTableView.reloadData()
                }
            }
            else {
                self.networkErrorWarnings()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationName = Notification.Name(rawValue: "homePageChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["current": 0])
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RecommendViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = self.recmdArticleResults {
            return results.recmdArticleDataResults.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recmdArticleData = self.recmdArticleResults?.recmdArticleDataResults[indexPath.row]
        
        let recmdArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleContentCell", for: indexPath) as! CircleContentCell
        recmdArticleCell.loadData2Cell(data: recmdArticleData!)
        
        return recmdArticleCell
    }
}

//MARK: - UITableViewDelegate
extension RecommendViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
