//
//  AppDelegate.swift
//  Kaoyaners
//
//  Created by sinestro on 2018/12/23.
//  Copyright © 2018 cn.nju. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.judgeAuthorizationStatus()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Kaoyaners")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Mark: Judge authorization status
    func judgeAuthorizationStatus() {
        // MARK: When App finished launching, ask the authorization for camera
        let cameraAuthStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if (cameraAuthStatus == .notDetermined || cameraAuthStatus == .denied || cameraAuthStatus == .restricted) {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
                if statusFirst {
                    print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Camera", "ACCEPT"]))
                }
                else {
                    DispatchQueue.main.async {
                        self.OpenSettingsURL4Users()
                    }
                    print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Camera", "REJECT"]))
                }
            })
        }
        
        // MARK: When App finished launching, ask the authorization for album
        let photoAuthStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if (photoAuthStatus == .notDetermined || photoAuthStatus == .denied || photoAuthStatus == .restricted) {
            PHPhotoLibrary.requestAuthorization({ (firstStatus) in
                let result = (firstStatus == .authorized)
                if result {
                    print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Album", "ACCEPT"]))
                }
                else {
                    DispatchQueue.main.async {
                        self.OpenSettingsURL4Users()
                    }
                    print(String(format: "[taskName] %@, [info] %@", arguments: ["Authorize Album", "REJECT"]))
                }
            })
        }
    }
    
    // Mark: Open Settings
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

}

