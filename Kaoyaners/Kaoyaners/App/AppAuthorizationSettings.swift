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
import SKPhotoBrowser

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
    
    // Mark: Obtain the authorization for album
    func photoEnable() -> Bool {
        // Obtain the situation of the authorization
        func photoResult() {
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized) {
                print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Album", "ACCEPT"]))
                saveAlbumAuthorization(value: "1")
            }
            else if (status == .restricted || status == .denied) {
                print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Album", "REJECT"]))
                saveAlbumAuthorization(value: "0")
                
                DispatchQueue.main.async {
                    self.OpenSettingsURL4Users()
                }
                let newStatus = PHPhotoLibrary.authorizationStatus()
                if newStatus == .authorized {
                    saveAlbumAuthorization(value: "1")
                }
            }
            else if (status == .notDetermined) {
                PHPhotoLibrary.requestAuthorization({ (firstStatus) in
                    let isTrue = (firstStatus == .authorized)
                    if isTrue {
                        print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Album", "ACCEPT"]))
                        saveAlbumAuthorization(value: "1")
                    }
                    else {
                        print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Album", "REJECT"]))
                        saveAlbumAuthorization(value: "0")
                        
                        DispatchQueue.main.async {
                            self.OpenSettingsURL4Users()
                        }
                        let newStatus = PHPhotoLibrary.authorizationStatus()
                        if newStatus == .authorized {
                            saveAlbumAuthorization(value: "1")
                        }
                    }
                })
            }
        }
        
        // Data persistence
        func saveAlbumAuthorization(value: String) {
            let dataPersistence: DataPersistenceService = DataPersistenceService()
            dataPersistence.savePhotoAuthorization(value)
        }
        
        photoResult()
        let userDefaults = UserDefaults.standard
        let result = (userDefaults.object(forKey: "photoEnables") as! String) == "1"
        return result
    }
    
    // MARK: Obtain the authorization for camera
    func cameraEnable() -> Bool {
        func cameraResult() {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            if (authStatus == .authorized) {
                print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Album", "ACCEPT"]))
                saveCameraAuthorization(value: "1")
            }
            else if (authStatus == .denied || authStatus == .restricted) {
                print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Album", "REJECT"]))
                saveCameraAuthorization(value: "0")
                
                DispatchQueue.main.async {
                    self.OpenSettingsURL4Users()
                }
                let newStatus = PHPhotoLibrary.authorizationStatus()
                if newStatus == .authorized {
                    saveCameraAuthorization(value: "1")
                }
            }
            else if (authStatus == .notDetermined) {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
                    if statusFirst {
                        print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Album", "ACCEPT"]))
                        saveCameraAuthorization(value: "1")
                    } else {
                        print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Album", "REJECT"]))
                        saveCameraAuthorization(value: "0")
                        
                        DispatchQueue.main.async {
                            self.OpenSettingsURL4Users()
                        }
                        let newStatus = PHPhotoLibrary.authorizationStatus()
                        if newStatus == .authorized {
                            saveCameraAuthorization(value: "1")
                        }
                    }
                })
            }
        }
        
        func saveCameraAuthorization(value: String) {
            let dataPersistence: DataPersistenceService = DataPersistenceService()
            dataPersistence.saveCameraAuthorization(value)
        }
        
        cameraResult()
        let userDefaults = UserDefaults.standard
        let result = (userDefaults.object(forKey: "cameraEnables") as! String) == "1"
        return result
    }
    
    func OpenSettingsURL4Users() {
        let settingUrl = URL(string: UIApplication.openSettingsURLString)
        let alertController = UIAlertController(title: "访问受限", message: "点击“设置”，允许访问权限", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
        let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
            (action) -> Void in
            if  UIApplication.shared.canOpenURL(settingUrl!) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(settingUrl!, options: [:],completionHandler: {(success) in })
                } else {
                    UIApplication.shared.openURL(settingUrl!)
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    static func openPhotoBrowser(from viewController: UIViewController, src: String) {
        let photo = SKPhoto.photoWithImageURL(src)
        photo.shouldCachePhotoURLImage = true

        let browser = SKPhotoBrowser(photos: [photo])
        browser.initializePageIndex(0)
        viewController.present(browser, animated: true, completion: nil)
    }

}
