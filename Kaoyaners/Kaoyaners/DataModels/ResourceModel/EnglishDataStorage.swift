//
//  EnglishDataStorage.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/3.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import SwiftyJSON

class EnglishDataStorage: NSObject {
    var englishDataResults = [ResourceDataModel]()
    
    init(dicts: [NSDictionary]){
        // Obtain the data and store data
        for dict in dicts {
            let imageURL = dict["images"] as! String
            let category = dict["category"] as! String
            let subject = dict["subject"] as! String
            let owner = dict["owner"] as! String
            let srcName = dict["srcname"] as! String
            let srcIntro = dict["srcintro"] as! String
            let revCounter = dict["revcounter"] as! String
            
            let englishData = ResourceDataModel(imageURL: imageURL, resourceCategory: category, subjectName: subject, ownerName: owner, resourceName: srcName, resourceIntro: srcIntro, reviewCounter: revCounter)
            self.englishDataResults.append(englishData)
        }
    }
    
    // Use json to initialize
    init(jsonArray: [JSON]) {
        // Obtain the data and store data
        var imageURL: String = "..."
        var category: String = "..."
        var subject: String = "..."
        var owner: String = "..."
        var srcName: String = "..."
        var srcIntro: String = "..."
        // var revCounter: String!
        
        for json in jsonArray {
            for (_ , resource):(String, JSON) in json {
                for (index, subJson): (String, JSON) in resource {
                    if index == "catalog" {
                        if let categoryStr = subJson.rawString() {
                            category = categoryStr
                        }
                    }
                    else if index == "file_tag" {
                        if let tagStr = subJson.rawString() {
                            subject = tagStr
                        }
                    }
                    else if index == "owner_id" {
                        if let ownerStr = subJson.rawString() {
                            owner = ownerStr
                        }
                    }
                    else if index == "name" {
                        if let srcNameStr = subJson.rawString() {
                            srcName = srcNameStr
                        }
                    }
                    else if index == "introduction" {
                        if let introStr = subJson.rawString() {
                            srcIntro = introStr
                        }
                    }
                    else if index == "suffix" {
                        if let suffixStr = subJson.rawString() {
                            imageURL = AppSettings().suffixBack2Image(suffixStr)
                        }
                    }
                }
                
                let englishData = ResourceDataModel(imageURL: imageURL, resourceCategory: category, subjectName: subject, ownerName: owner, resourceName: srcName, resourceIntro: srcIntro, reviewCounter: "0")
                self.englishDataResults.append(englishData)
            }
        }
    }
    
    
}
