//
//   PictureViewController.swift
//   Kaoyaners
//
//   Created by sinestro on 2019/1/8.
//   Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import Photos

// 相簿列表项
struct ImageAlbumItem {
    // 相簿名称
    var title:String?
    // 相簿内的资源
    var fetchResult: PHFetchResult<PHAsset>
}

// 相簿列表页控制器
class PictureViewController: UIViewController {
    // 显示相簿列表项的表格
    @IBOutlet weak var tableView: UITableView!
    
    // 相簿列表项集合
    var items:[ImageAlbumItem] = []
    
    // 每次最多可选择的照片数量
    var maxSelected:Int = Int.max
    
    // 照片选择完毕后的回调
    var completeHandler:((_ assets:[PHAsset])->())?
    
    // 从xib或者storyboard加载完毕就会调用
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 申请权限
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {
                return
            }
            
            // 列出所有系统的智能相册
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                      subtype: .albumRegular,
                                                                      options: smartOptions)
            self.convertCollection(collection: smartAlbums)
            
            // 列出所有用户创建的相册
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections
                as! PHFetchResult<PHAssetCollection>)
            
            // 相册按包含的照片数量排序（降序）
            self.items.sort { (item1, item2) -> Bool in
                return item1.fetchResult.count > item2.fetchResult.count
            }
            
            // 异步加载表格数据,需要在主线程中调用reloadData() 方法
            DispatchQueue.main.async{
                self.tableView?.reloadData()
            }
        })
    }
    
    // 页面加载完毕
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // 设置表格相关样式属性
        self.tableView.rowHeight = 60
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationName = Notification.Name(rawValue: "fileSelectionPageChanged")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["current": 2])
    }
    
    // 转化处理获取到的相簿
    private func convertCollection(collection:PHFetchResult<PHAssetCollection>){
        for index in 0..<collection.count{
            // 获取出当前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            let collectionUnit = collection[index]
            let assetsFetchResult = PHAsset.fetchAssets(in: collectionUnit , options: resultsOptions)
            // 没有图片的空相簿不显示
            if assetsFetchResult.count > 0 {
                let title = titleOfAlbumForChinse(title: collectionUnit.localizedTitle)
                items.append(ImageAlbumItem(title: title,
                                              fetchResult: assetsFetchResult))
            }
        }
    }
    
    // 由于系统返回的相册集名称为英文，我们需要转换为中文
    private func titleOfAlbumForChinse(title:String?) -> String? {
        if title == "Slo-mo" {
            return "慢动作"
        } else if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "个人收藏"
        } else if title == "Recently Deleted" {
            return "最近删除"
        } else if title == "Videos" {
            return "视频"
        } else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "屏幕快照"
        } else if title == "Camera Roll" {
            return "相机胶卷"
        }
        return title
    }
    
    // 页面跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 如果是跳转到展示相簿缩略图页面
        if segue.identifier == "ShowImages"{
            // 获取照片展示控制器
            guard let imageCollectionVC = segue.destination
                as? ImageCollectionViewController,
                let cell = sender as? ImagePickerCell else{
                    return
            }
            // 设置回调函数
            imageCollectionVC.completeHandler = completeHandler
            // 设置标题
            imageCollectionVC.title = cell.titleLabel.text
            // 设置最多可选图片数量
            imageCollectionVC.maxSelected = self.maxSelected
            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
            
            // 获取选中的相簿信息
            let fetchResult = self.items[indexPath.row].fetchResult
            // 传递相簿内的图片资源
            imageCollectionVC.assetsFetchResults = fetchResult
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// 相簿列表页控制器UITableViewDelegate,UITableViewDataSource协议方法的实现
extension PictureViewController: UITableViewDelegate,UITableViewDataSource{
    // 设置单元格内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            // 同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePickerCell", for: indexPath) as! ImagePickerCell
            let item = self.items[indexPath.row]
            cell.titleLabel.text = "\(item.title ?? "") "
            cell.countLabel.text = "（\(item.fetchResult.count)）"
            cell.accessoryType = .disclosureIndicator
            return cell
    }
    
    // 表格单元格数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // 表格单元格选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "ShowImages", sender: tableView.cellForRow(at: indexPath) )
    }
}

extension UIViewController {
    // ImagePicker提供给外部调用的接口，同于显示图片选择页面
    func createImagePicker(maxSelected:Int = Int.max,
                              completeHandler:((_ assets:[PHAsset])->())?)
        -> PictureViewController?{
            // 获取图片选择视图控制器
            if let picVC = storyboard?.instantiateViewController(withIdentifier: "PictureVCID") as? PictureViewController{
                // 设置选择完毕后的回调
                picVC.completeHandler = completeHandler
                // 设置图片最多选择的数量
                picVC.maxSelected = maxSelected
                return picVC
            }
            return nil
    }
}
