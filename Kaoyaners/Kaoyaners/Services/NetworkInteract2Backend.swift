//
//  NetworkInteract2Backend.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/7.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkInteract2Backend: NSObject {
    
    private let serverURL: String = "http://192.168.1.109:3000"
    
    // Mark: Usign streamData to upload one file
    func streamOneFileUpload(_ fileAtPath: String, targetAddr: String, parameters: [String]) {
        let fileManager = FileManager.default
        
        // Concatenate the strings to obtain the url
        var specificServerURL: String = String(self.serverURL) + targetAddr
        for param in parameters {
            specificServerURL += ("?" + param)
        }
        
        if (fileManager.fileExists(atPath: fileAtPath)) {
            let fileURL = URL(fileURLWithPath: fileAtPath)
            Alamofire.upload(fileURL, to: specificServerURL)
                .uploadProgress { progress in
                    print("当前进度: \(progress.fractionCompleted)")
                }
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value ?? "")")
            }
        }
    }
    
    // Mark: Usign streamData to upload multiple files to different urls
    func streamMultiFilesUpload2DifferentURLs(_ filesAtPath: [String], targetAddr: [String], parameters: [[String]]) {
        let fileManager = FileManager.default
        
        for index in 0..<filesAtPath.count {
            if (fileManager.fileExists(atPath: filesAtPath[index])) {
                let fileURL = URL(fileURLWithPath: filesAtPath[index])
                // Concatenate the strings to obtain the url
                var specificServerURL: String = String(self.serverURL) + targetAddr[index]
                if parameters.count > 0 {
                    for param in parameters[index] {
                        specificServerURL += ("?" + param)
                    }
                }
                
                Alamofire.upload(fileURL, to: specificServerURL)
                    .uploadProgress { progress in // main queue by default
                        print("当前文件序号: \(index)当前进度: \(progress.fractionCompleted)")
                    }
                    .responseJSON { response in
                        print("Success: \(response.result.isSuccess)")
                        print("Response String: \(response.result.value ?? "")")
                        
                }
            }
        }
    }
    
    // Mark: Usign streamData to upload multiple files to the same url
    func streamMultiFilesUpload2SameURL(_ filesAtPath: [String], targetAddr: String, parameters: [[String]]) {
        let fileManager = FileManager.default
        
        for index in 0..<filesAtPath.count {
            if (fileManager.fileExists(atPath: filesAtPath[index])) {
                let fileURL = URL(fileURLWithPath: filesAtPath[index])
                // Concatenate the strings to obtain the url
                var specificServerURL: String = String(self.serverURL) + targetAddr
                if parameters.count > 0 {
                    for param in parameters[index] {
                        specificServerURL += ("?" + param)
                    }
                }
                
                Alamofire.upload(fileURL, to: specificServerURL)
                    .uploadProgress { progress in // main queue by default
                        print("当前文件序号: \(index)当前进度: \(progress.fractionCompleted)")
                    }
                    .responseJSON { response in
                        print("Success: \(response.result.isSuccess)")
                        print("Response String: \(response.result.value ?? "")")
                        
                }
            }
        }
    }
    
    // Mark: Usign multipartFromData to upload one file
    func multipartOneFileUpload(_ fileAtPath: String, targetAddr: String, parameters: [String: String]) {
        let fileManager = FileManager.default
        // Concatenate the strings to obtain the url
        let specificServerURL: String = String(self.serverURL) + targetAddr
        
        if (fileManager.fileExists(atPath: fileAtPath)) {
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    for param in parameters {
                        multipartFormData.append(param.value.data(using: String.Encoding.utf8)!, withName: param.key)
                    }
                    multipartFormData.append(URL(fileURLWithPath: fileAtPath), withName: "files")
                    
            },
                to: specificServerURL,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            print("Success: \(response.result.isSuccess)")
                            print("Response String: \(response.result.value ?? "")")
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
            )
        }
    }
    
    // Mark: Usign multipartFromData to upload multiple files to the same url
    func multipartMultiFilesUpload2SameURL(_ filesAtPath: [String], targetAddr: String, parameters: [[String: String]]) {
        let fileManager = FileManager.default
        // Concatenate the strings to obtain the url
        let specificServerURL: String = String(self.serverURL) + targetAddr
        
        for index in 0..<filesAtPath.count {
            if (fileManager.fileExists(atPath: filesAtPath[index])) {
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        for param in parameters[index] {
                            multipartFormData.append(param.value.data(using: String.Encoding.utf8)!, withName: param.key)
                        }
                        multipartFormData.append(URL(fileURLWithPath: filesAtPath[index]), withName: "files")
                        
                },
                    to: specificServerURL,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                print("Success: \(response.result.isSuccess)")
                                print("Response String: \(response.result.value ?? "")")
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                }
                )
            }
        }
    }

    // Mark: Usign multipartFromData to upload multiple files to the same url
    func multipartMultiFilesUpload2DifferentURLs(_ filesAtPath: [String], targetAddr: [String], parameters: [[String: String]]) {
        let fileManager = FileManager.default
        
        for index in 0..<filesAtPath.count {
            if (fileManager.fileExists(atPath: filesAtPath[index])) {
                // Concatenate the strings to obtain the url
                let specificServerURL: String = String(self.serverURL) + targetAddr[index]
                
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        for param in parameters[index] {
                            multipartFormData.append(param.value.data(using: String.Encoding.utf8)!, withName: param.key)
                        }
                        multipartFormData.append(URL(fileURLWithPath: filesAtPath[index]), withName: "files")
                        
                },
                    to: specificServerURL,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                print("Success: \(response.result.isSuccess)")
                                print("Response String: \(response.result.value ?? "")")
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                }
                )
            }
        }
    }
    
    func requestDataFromOneServerDatabase(_ srcAddr: String, parameters: [String: String]) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + srcAddr
        
        Alamofire.request(specificServerDatabase, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let id = json[0]["id"].string {
                            print(id)
                        }
                    }
                case false:
                    print(response.result.error!)
                }
        }
    }
    
}
