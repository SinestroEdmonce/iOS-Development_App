//
//  NetworkInteract2Backend.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/7.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import Alamofire

class NetworkInteract2Backend: NSObject {
    
    private let serverURL: String = "192.168.1.1:3000"
    
    func oneResourceFileUpload(_ fileAtPath: String, parameters: String) -> Bool {
        var isSuccess: Bool = true
        let fileManager = FileManager.default
        let specificServerURL = self.serverURL + "?" + parameters
        if (fileManager.fileExists(atPath: fileAtPath)) {
            let fileURL = URL(fileURLWithPath: fileAtPath)
            Alamofire.upload(fileURL, to: specificServerURL)
                .uploadProgress { progress in // main queue by default
                    print("当前进度: \(progress.fractionCompleted)")
                }
                .responseJSON { response in
                    switch response.result.isSuccess {
                    case true:
                       isSuccess = true
                    case false:
                        isSuccess = false
                        
                    }
                    
            }
            return isSuccess
        }
        else {
            return false
        }
    }
    
    func multipleResourceFileUpload2DifferentURLs(_ filesAtPath: [String], parameters: [String]) -> Bool {
        var isSuccess: Bool = true
        let fileManager = FileManager.default
        
        for index in 0..<filesAtPath.count {
            if (fileManager.fileExists(atPath: filesAtPath[index])) {
                let fileURL = URL(fileURLWithPath: filesAtPath[index])
                let specificServerURL = self.serverURL + "?" + parameters[index]
                Alamofire.upload(fileURL, to: specificServerURL)
                    .uploadProgress { progress in // main queue by default
                        print("当前进度: \(progress.fractionCompleted)")
                    }
                    .responseJSON { response in
                        switch response.result.isSuccess {
                        case true:
                            isSuccess = true
                        case false:
                            isSuccess = false
                            
                        }
                        
                }
                return isSuccess
            }
            else {
                return false
            }
        }
        return isSuccess
    }
    
    func multipleResourceFileUpload2SameURL(_ filesAtPath: [String], fileNames: [String], parameters: String) -> Bool {
        var isSuccess: Bool = true
        let fileManager = FileManager.default
        let specificServerURL = self.serverURL + "?" + parameters
        var fileURLs: [URL] = []
        
        for index in 0..<filesAtPath.count {
            if (!fileManager.fileExists(atPath: filesAtPath[index])) {
                isSuccess = false
                return isSuccess
            }
            else {
                fileURLs.append(URL(fileURLWithPath: filesAtPath[index]))
            }
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for index in 0..<filesAtPath.count{
                    multipartFormData.append(fileURLs[index], withName: fileNames[index])
                }},
            to: specificServerURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result.isSuccess {
                        case true:
                            isSuccess = true
                        case false:
                            isSuccess = false
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    isSuccess = false
                }
        }
        )
        return isSuccess
    }
    
    
}
