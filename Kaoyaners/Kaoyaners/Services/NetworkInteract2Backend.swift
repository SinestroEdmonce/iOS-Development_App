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
    // Unchangable server address
    private let serverURL: String = "http://192.168.150.128:3000"
    // Changable database address
    var resourceDatabaseAddr: String = "/resources"
    var articleDatabaseAddr: String = "/articles"
    var userDatabaseAddr: String = "/users"
    var postArticlesAddr: String = "/users/post_article"
    var uploadImageInArticleAddr: String = "/users/upload_img"
    var postResourcesAddr: String = "/users/resources"
    var uploadAvatarAddr: String = "/users/upload_head"
    var requestAvatarAddr: String = "/users/head"
    
    // Other address
    var otherDatabaseAddr: [String: String] = [:]
    
    // Mark: Some functions that can modify the target address or source address
    func modifyResourceDatabaseAddr(_ newAddr: String) {
        self.resourceDatabaseAddr = newAddr
    }
    
    func modifyRequestAvatarAddr(_ newAddr: String) {
        self.requestAvatarAddr = newAddr
    }
    
    func modifyUploadAvatarAddr(_ newAddr: String) {
        self.uploadAvatarAddr = newAddr
    }
    
    func modifyUploadImageInArticleAddr(_ newAddr: String) {
        self.uploadImageInArticleAddr = newAddr
    }
    
    func modifyPoatResouceAddr(_ newAddr: String) {
        self.postResourcesAddr = newAddr
    }
    
    func modifyPostArticleAddr(_ newAddr: String) {
        self.postArticlesAddr = newAddr
    }
    
    func modifyArtilceDatabaseAddr(_ newAddr: String) {
        self.articleDatabaseAddr = newAddr
    }
    
    func modifyUserDatabaseAddr(_ newAddr: String) {
        self.userDatabaseAddr = newAddr
    }
    
    func modifyOtherDatabaseAddr(_ addrName: String, newAddr: String) {
        self.otherDatabaseAddr[addrName] = newAddr
    }
    
    func redefineOtherDatabaseAddr(_ otherAddrs: [String: String]) {
        self.otherDatabaseAddr = otherAddrs
    }
    
    func addOtherDatabaseAddr(_ otherAddrs: [String: String]) {
        self.otherDatabaseAddr.merge(otherAddrs, uniquingKeysWith: {(oldVal, newVal) in newVal})
    }
    
    // Mark: Using streamData to upload one file
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
    
    // Mark: Using streamData to upload multiple files to different urls
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
    
    // Mark: Using streamData to upload multiple files to the same url
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
    
    // Mark: Using multipartFromData to upload one file
    func multipartOneFileUpload(_ fileAtPath: String, targetAddr: String, parameters: [String: String], completeHandler: @escaping ((_ isSuccess: Bool)->())) {
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
                            switch response.result.isSuccess {
                            case true:
                                completeHandler(true)
                            case false:
                                completeHandler(false)
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
            )
        }
    }
    
    // Mark: Using multipartFromData to upload multiple files to the same url
    func multipartMultiFilesUpload2SameURL(_ filesAtPath: [String], targetAddr: String, parameters: [[String: String]],  completeHandler: @escaping ((_ isSuccess: Bool)->())) {
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
                                switch response.result.isSuccess {
                                case true:
                                    if index == filesAtPath.count-1 {
                                        completeHandler(true)
                                    }
                                case false:
                                    completeHandler(false)
                                }
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

    // Mark: Request resource list from one server database
    func requestResourceListFromOneServerDatabase(_ srcAddr: String, parameters: [String: String], completeHandler: @escaping ((_ subJsonArray: [JSON]?, _ isSuccess: Bool)->())) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + srcAddr
        
        Alamofire.request(specificServerDatabase, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        let json = JSON(value)
                        var jsonArray: [JSON] = []
                        
                        for (index,subJson):(String, JSON) in json {
                            if index == "value" {
                                jsonArray.append(subJson)
                            }
                        }
                        completeHandler(jsonArray, true)
                    }
                    else {
                        completeHandler(nil, false)
                    }
                case false:
                    completeHandler(nil, false)
                }
        }
    }
    
    // Mark: Request resource list from multiple server databases
    func requestResourceListFromMultiServerDatabases(_ srcAddr: [String], parameters: [[String: String]], completeHandler: @escaping ((_ subJsonArray: [JSON]?, _ isSuccess: Bool)->())) {
        
        var subJsonArray: [JSON] = []
        for index in 0..<srcAddr.count {
            // Concatenate the strings to obtain the url
            let specificServerDatabase: String = String(self.serverURL) + srcAddr[index]
            
            Alamofire.request(specificServerDatabase, parameters: parameters[index])
                .responseJSON { response in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value {
                            let json = JSON(value)
                            for (index, subJson):(String, JSON) in json {
                                if index == "value" {
                                    subJsonArray.append(subJson)
                                }
                            }
                            if index == srcAddr.count-1 {
                                completeHandler(subJsonArray, true)
                                return
                            }
                        }
                        else {
                            completeHandler(nil, false)
                        }
                    case false:
                        print(response.result.error!)
                        completeHandler(nil, false)
                    }
            }
        }
    }
    
    // Mark: Request resource detail from one server database
    func requestResourceDetailFromOneServerDatabase(_ srcAddr: String, parameters: [String: String]) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + srcAddr
        
        Alamofire.request(specificServerDatabase, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (index,subJson):(String, JSON) in json {
                            print("\(index)：\(subJson)")
                        }
                    }
                case false:
                    print(response.result.error!)
                }
        }
    }
    
    // Mark: Request resource detail from multiple server databases
    func requestResourceDetailFromMultiServerDatabases(_ srcAddr: [String], parameters: [[String: String]]) {
        
        for index in 0..<srcAddr.count {
            // Concatenate the strings to obtain the url
            let specificServerDatabase: String = String(self.serverURL) + srcAddr[index]
            
            Alamofire.request(specificServerDatabase, parameters: parameters[index])
                .responseJSON { response in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value {
                            let json = JSON(value)
                            for (index,subJson):(String, JSON) in json {
                                print("\(index)：\(subJson)")
                            }
                        }
                    case false:
                        print(response.result.error!)
                    }
            }
        }
    }
    
    // Mark: Request download resource from one server database
    func requestDownloadResourceFromOneServerDatabase(_ srcAddr: String, parameters: [String: String]) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + srcAddr
        
        Alamofire.request(specificServerDatabase, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (index,subJson):(String, JSON) in json {
                            print("\(index)：\(subJson)")
                        }
                    }
                case false:
                    print(response.result.error!)
                }
        }
    }
    
    // Mark: Request download resource from multiple server databases
    func requestDownloadResourceFromMultiServerDatabases(_ srcAddr: [String], parameters: [[String: String]]) {
        
        for index in 0..<srcAddr.count {
            // Concatenate the strings to obtain the url
            let specificServerDatabase: String = String(self.serverURL) + srcAddr[index]
            
            Alamofire.request(specificServerDatabase, parameters: parameters[index])
                .responseJSON { response in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value {
                            let json = JSON(value)
                            for (index,subJson):(String, JSON) in json {
                                print("\(index)：\(subJson)")
                            }
                        }
                    case false:
                        print(response.result.error!)
                    }
            }
        }
    }
    
    // Mark: Using multipartFromData to upload articles
    func multipartArticleUpload(targetAddr: String, parameters: [String: String], completeHandler: @escaping ((_ isSuccess: Bool)->())) {
        // Concatenate the strings to obtain the url
        let specificServerURL: String = String(self.serverURL) + targetAddr
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for param in parameters {
                    multipartFormData.append(param.value.data(using: String.Encoding.utf8)!, withName: param.key)
                }
                
        },
            to: specificServerURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result.isSuccess {
                        case true:
                            completeHandler(true)
                        case false:
                            completeHandler(false)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    
    // Mark: Request passages/articles' list data from one server databases
    func requestArticleListDataFromOneServerDatabase(_ srcAddr: String, parameters: [String: String], completeHandler: @escaping ((_ subJsonArray: [JSON]?, _ isSuccess: Bool)->())) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + srcAddr
        
        Alamofire.request(specificServerDatabase, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        let json = JSON(value)
                        var jsonArray: [JSON] = []
                        
                        for (index,subJson):(String, JSON) in json {
                            if index == "value" {
                                jsonArray.append(subJson)
                            }
                        }
                        completeHandler(jsonArray, true)
                    }
                    else {
                        completeHandler(nil, false)
                    }
                case false:
                    print(response.result.error!)
                    completeHandler(nil, false)
                }
        }
    }
    
    // Mark: Request passages/articles' list data from multiple server databases
    func requestArticleListDataFromMultiServerDatabases(_ srcAddr: [String], parameters: [[String: String]], completeHandler: @escaping ((_ subJsonArray: [JSON]?, _ isSuccess: Bool)->())) {
        
        var subJsonArray: [JSON] = []
        for index in 0..<srcAddr.count {
            // Concatenate the strings to obtain the url
            let specificServerDatabase: String = String(self.serverURL) + srcAddr[index]
            
            Alamofire.request(specificServerDatabase, parameters: parameters[index])
                .responseJSON { response in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value {
                            let json = JSON(value)
                            for (index, subJson):(String, JSON) in json {
                                if index == "value" {
                                    subJsonArray.append(subJson)
                                }
                            }
                            if index == srcAddr.count-1 {
                                completeHandler(subJsonArray, true)
                                return
                            }
                        }
                        else {
                            completeHandler(nil, false)
                        }
                    case false:
                        print(response.result.error!)
                    }
            }
        }
    }
    
    // Mark: Request particular passage information from one server databases
    func requestPassageDetailFromOneServerDatabase(_ srcAddr: String, parameters: [String: String]) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + srcAddr
        
        Alamofire.request(specificServerDatabase, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (index,subJson):(String, JSON) in json {
                            print("\(index)：\(subJson)")
                        }
                    }
                case false:
                    print(response.result.error!)
                }
        }
    }
    
    // Mark: Request particular passage information from multiple server databases
    func requestPassageDetailFromMultiServerDatabases(_ srcAddr: [String], parameters: [[String: String]]) {
        
        for index in 0..<srcAddr.count {
            // Concatenate the strings to obtain the url
            let specificServerDatabase: String = String(self.serverURL) + srcAddr[index]
            
            Alamofire.request(specificServerDatabase, parameters: parameters[index])
                .responseJSON { response in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value {
                            let json = JSON(value)
                            for (index,subJson):(String, JSON) in json {
                                print("\(index)：\(subJson)")
                            }
                        }
                    case false:
                        print(response.result.error!)
                    }
            }
        }
    }
    
    // Mark: Request circles' list data from one server databases
    func requestCircleListDataFromOneServerDatabase(_ srcAddr: String, parameters: [String: String]) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + srcAddr
        
        Alamofire.request(specificServerDatabase, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (index,subJson):(String, JSON) in json {
                            print("\(index)：\(subJson)")
                        }
                    }
                case false:
                    print(response.result.error!)
                }
        }
    }
    
    // Mark: Request circles data from multiple server databases
    func requestCircleListDataFromMultiServerDatabases(_ srcAddr: [String], parameters: [[String: String]]) {
        
        for index in 0..<srcAddr.count {
            // Concatenate the strings to obtain the url
            let specificServerDatabase: String = String(self.serverURL) + srcAddr[index]
            
            Alamofire.request(specificServerDatabase, parameters: parameters[index])
                .responseJSON { response in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value {
                            let json = JSON(value)
                            for (index,subJson):(String, JSON) in json {
                                print("\(index)：\(subJson)")
                            }
                        }
                    case false:
                        print(response.result.error!)
                    }
            }
        }
    }
    
    // Mark: Request circle's details from one server databases
    func requestCircleDetailFromOneServerDatabase(_ srcAddr: String, parameters: [String: String]) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + srcAddr
        
        Alamofire.request(specificServerDatabase, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (index,subJson):(String, JSON) in json {
                            print("\(index)：\(subJson)")
                        }
                    }
                case false:
                    print(response.result.error!)
                }
        }
    }
    
    // Mark: Request circle's details from multiple server databases
    func requestCircleDetailFromMultiServerDatabases(_ srcAddr: [String], parameters: [[String: String]]) {
        
        for index in 0..<srcAddr.count {
            // Concatenate the strings to obtain the url
            let specificServerDatabase: String = String(self.serverURL) + srcAddr[index]
            
            Alamofire.request(specificServerDatabase, parameters: parameters[index])
                .responseJSON { response in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value {
                            let json = JSON(value)
                            for (index,subJson):(String, JSON) in json {
                                print("\(index)：\(subJson)")
                            }
                        }
                    case false:
                        print(response.result.error!)
                    }
            }
        }
    }
    
    // Mark: Request myinfo details from one server databases
    func requestMyInfoDetailFromOneServerDatabase(_ srcAddr: String, parameters: [String: String]) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + srcAddr
        
        Alamofire.request(specificServerDatabase, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (index,subJson):(String, JSON) in json {
                            print("\(index)：\(subJson)")
                        }
                    }
                case false:
                    print(response.result.error!)
                }
        }
    }
    
    // Mark: Request myinfo details from multiple server databases
    func requestMyInfoDetailFromMultiServerDatabases(_ srcAddr: [String], parameters: [[String: String]]) {
        
        for index in 0..<srcAddr.count {
            // Concatenate the strings to obtain the url
            let specificServerDatabase: String = String(self.serverURL) + srcAddr[index]
            
            Alamofire.request(specificServerDatabase, parameters: parameters[index])
                .responseJSON { response in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value {
                            let json = JSON(value)
                            for (index,subJson):(String, JSON) in json {
                                print("\(index)：\(subJson)")
                            }
                        }
                    case false:
                        print(response.result.error!)
                    }
            }
        }
    }
    
    // Mark: Request a user' avatar
    func requestUserAvatar(_ srcAddr: String, parameters: [String: String], completeHandler: ((_ avatar: URL?, _ isSuccess: Bool) ->())? ) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + srcAddr
        
        Alamofire.request(specificServerDatabase, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (index,subJson):(String, JSON) in json {
                            if index == "url" {
                                if let avatarStr = subJson.rawString() {
                                    let avatarURL = URL(string: avatarStr)
                                    completeHandler!(avatarURL, true)
                                    return
                                }
                            }
                        }
                    }
                    completeHandler!(nil, false)
                case false:
                    print(response.result.error!)
                    completeHandler!(nil, false)
                }
        }
    }
    
    // Mark: POST to register
    func post4RegisterNewUser(_ targetAddr: String, parameters: [String: String], completeHandler: @escaping ((_ isSuccess: Bool)->()))  {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + targetAddr
        
        Alamofire.request(specificServerDatabase, method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    completeHandler(true)
                case false:
                    completeHandler(false)
                }
        }
    }
    
    // Mark: POST to login
    func post4Login(_ targetAddr: String, parameters: [String: String], completeHandler: @escaping ((_ isSuccess: Bool)->())) {
        // Concatenate the strings to obtain the url
        let specificServerDatabase: String = String(self.serverURL) + targetAddr
        
        Alamofire.request(specificServerDatabase, method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    completeHandler(true)
                case false:
                    completeHandler(false)
                }
        }
    }
    
}
