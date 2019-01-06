//
//  AppAuthorizationSettings.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SafariServices
//import SKPhotoBrowser

class AppAuthorizationSettings: NSObject {
    
    static var isCameraEnabled: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return status != .restricted && status != .denied
    }
    
    static var isAlbumEnabled: Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        return status != .restricted && status != .denied
    }
    
    static func openWebBrowser(from viewController: UIViewController, URL: URL) {
        let browser = SFSafariViewController(url: URL)
        viewController.present(browser, animated: true, completion: nil)
    }
    
    // Obtain the authorization for album
    func photoEnable() -> Bool {
        // Obtain the situation of the authorization
        func photoResult() {
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized) {
                saveAlbumAuthorization(value: "1")
            }
            else if (status == .restricted || status == .denied) {
                let alertV = UIAlertView.init(title: "提示", message: "请去-> [设置 - 隐私 - 相册] 打开访问开关", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "确定")
                alertV.show()
                saveAlbumAuthorization(value: "0")
            }
            else if (status == .notDetermined) {
                PHPhotoLibrary.requestAuthorization({ (firstStatus) in
                    let isTrue = (firstStatus == .authorized)
                    if isTrue {
                        saveAlbumAuthorization(value: "1")
                    }
                    else {
                        saveAlbumAuthorization(value: "0")
                    }
                })
            }
        }
        
        // Data persistence
        func saveAlbumAuthorization(value: String) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(value, forKey: "photoEnables")
        }
        
        let userDefaults = UserDefaults.standard
        let result = (userDefaults.object(forKey: "photoEnables") as! String) == "1"
        return result
    }
    
//
//    static func openPhotoBrowser(from viewController: UIViewController, src: String) {
//        let photo = SKPhoto.photoWithImageURL(src)
//        photo.shouldCachePhotoURLImage = true
//
//        let browser = SKPhotoBrowser(photos: [photo])
//        browser.initializePageIndex(0)
//        viewController.present(browser, animated: true, completion: nil)
//    }

}
