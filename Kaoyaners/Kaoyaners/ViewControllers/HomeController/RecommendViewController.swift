//
//  RecommendViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/3.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

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
        
        self.updateArticlesData()
        self.contentTableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationName = Notification.Name(rawValue: "homePageChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["current": 0])
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
