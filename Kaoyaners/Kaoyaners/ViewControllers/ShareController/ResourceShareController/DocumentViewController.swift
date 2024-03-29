//
//  DocumentViewController.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/8.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

struct FileItem {
    // 文件名
    var fileName: String?
    // 文件类型
    var fileType: String?
    // 文件大小
    var fileSize: String?
    // 文件修改或创建时间
    var fileTime: String?
    // 文件地址
    var filePath: String?
}

class DocumentViewController: UIViewController {
    // 每次最多可选择的文件数量
    var maxSelected:Int = Int.max
    
    // 文件选择完毕后的回调
    var completeHandler:((_ files:[String])->())?
    
    // 文件项
    var items:[FileItem] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    // 从xib或者storyboard加载完毕就会调用
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.items = self.obtainDocuments()
        
        // 异步加载表格数据,需要在主线程中调用reloadData() 方法
        DispatchQueue.main.async{
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // 设置表格相关样式属性
        self.tableView.rowHeight = 80
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // 允许多选
        self.tableView.allowsMultipleSelection = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationName = Notification.Name(rawValue: "fileSelectionPageChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["current": 0])
    }
    
    // 获取已选择个数
    func selectedCount() -> Int {
        return self.tableView.indexPathsForSelectedRows?.count ?? 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func transformFileSizeValue(_ fileSize: String) -> String {
        var convertedValue = NSString(string: fileSize).doubleValue
        var multipleyFactor: Int = 0
        let metric: [String] = ["bytes","kb","mb", "gb", "tb", "pb", "eb", "zb", "yb", "inf"]
        
        while (convertedValue > 1024) {
            convertedValue /= 1024
            multipleyFactor += 1
        }
        
        return String(String(format: "%.2f", convertedValue)+metric[multipleyFactor])
    }
    
    private func obtainDocuments() -> [FileItem] {
        // 获取用户文档目录路径
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url4Doc = urlForDocument[0] as URL
        
        var files: [FileItem] = []
        
        let contentsOfPath = try? manager.contentsOfDirectory(atPath: url4Doc.path)
        if contentsOfPath?.count ?? -1 > 0 {
            for path in contentsOfPath! {
                let docPath = manager.urls(for: .documentDirectory, in:.userDomainMask)[0] as URL
                
                let file = docPath.appendingPathComponent(path)
                
                let attributes = try? manager.attributesOfItem(atPath: file.path)
                
                var document: FileItem = FileItem()
                document.fileName = path.components(separatedBy: "/")[path.components(separatedBy: "/").count-1]
                document.fileType = path.components(separatedBy: ".")[path.components(separatedBy: ".").count-1]
                document.fileTime = String("\(attributes![FileAttributeKey.creationDate]!)").components(separatedBy: "+")[0]
                document.fileSize = String("\(attributes![FileAttributeKey.size]!)")
                document.fileSize = self.transformFileSizeValue(document.fileSize ?? "0")
                document.filePath = file.path
                
                //TODO
                if AppSettings().isDocument(document.fileType!) {
                    files.append(document)
                }
            }
        }
        return files
    }
    
}

// 文件列表页控制器UITableViewDelegate,UITableViewDataSource协议方法的实现
extension DocumentViewController: UITableViewDelegate,UITableViewDataSource{
    // 设置单元格内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            // 同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentPickerCell", for: indexPath) as! DocumentPickerCell
            let item = self.items[indexPath.row]
            cell.fileName.text = "\(item.fileName ?? "")"
            cell.fileSize.text = "\(item.fileSize ?? "")"
            cell.fileTime.text = "\(item.fileTime ?? "")"
            //TODO
            cell.fileTypeImage.image = UIImage(named: AppSettings().suffixBack2Image((item.fileType ?? "...")))
            
            return cell
    }
    
    // 表格单元格数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // 表格单元格选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let cell = self.tableView.cellForRow(at: indexPath)
            as? DocumentPickerCell{
            // 获取选中的数量
            let count = self.selectedCount()
            // 如果选择的个数大于最大选择数
            if count > self.maxSelected {
                // 设置为不选中状态
                self.tableView.deselectRow(at: indexPath, animated: false)
                // 弹出提示
                let title = "最多只能选择\(self.maxSelected)个文档"
                let alertController = UIAlertController(title: title, message: nil,
                                                            preferredStyle: .alert)
                    
                let cancelAction = UIAlertAction(title:"好的", style: .cancel,
                                                     handler:nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
                // 如果不超过最大选择数
            else{
                cell.isSelected = true
                cell.playAnimate()
            }
        }
    }
    
    // 单元格未选中
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath){
                cell.isSelected = false
        }
    }
    
}

extension UIViewController {
    // ImagePicker提供给外部调用的接口，同于显示图片选择页面
    func createDocumentPicker(maxSelected:Int = Int.max,
                           completeHandler:((_ files:[String])->())?)
        -> DocumentViewController?{
            // 获取文件选择视图控制器
            if let docVC = storyboard?.instantiateViewController(withIdentifier: "DocumentVCID") as? DocumentViewController{
                // 设置选择完毕后的回调
                docVC.completeHandler = completeHandler
                // 设置文件最多选择的数量
                docVC.maxSelected = maxSelected
                return docVC
            }
            return nil
    }
}
