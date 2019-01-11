//
//  RecmArticleDataStorage.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/11.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecmdArticleDataStorage: NSObject {
    var recmdArticleDataResults = [ArticleDataModel]()

    init(dicts: [NSDictionary]){
        // Obtain the data and store data
        for dict in dicts {
            let circleName = dict["circle"] as! String
            let content = dict["content"] as! String
            let owner = dict["owner"] as! String

            let recmdArticleData = ArticleDataModel(circleName, article: content, owner: owner)
            self.recmdArticleDataResults.append(recmdArticleData)
        }
    }
    
    func append(jsonArray: [JSON]) {
        // Obtain the data and store data
        var circleName: String = "..."
        var content: String = "..."
        var owner: String = "..."
        // var revCounter: String!
        
        for json in jsonArray {
            for (_ , resource):(String, JSON) in json {
                for (index, subJson): (String, JSON) in resource {
                    if index == "owner_id" {
                        if let ownerStr = subJson.rawString() {
                            owner = ownerStr
                        }
                    }
                    else if index == "content" {
                        if let contentStr = subJson.rawString() {
                            content = contentStr
                        }
                    }
                    else if index == "circle" {
                        if let circleStr = subJson.rawString() {
                            circleName = circleStr
                        }
                    }
                }
                
                let recmdArticleData = ArticleDataModel(circleName, article: content, owner: owner)
                self.recmdArticleDataResults.append(recmdArticleData)
            }
        }
    }

    // Use json to initialize
    init(jsonArray: [JSON]) {
        // Obtain the data and store data
        var circleName: String = "..."
        var content: String = "..."
        var owner: String = "..."
        // var revCounter: String!

        for json in jsonArray {
            for (_ , resource):(String, JSON) in json {
                for (index, subJson): (String, JSON) in resource {
                    if index == "owner_id" {
                        if let ownerStr = subJson.rawString() {
                            owner = ownerStr
                        }
                    }
                    else if index == "content" {
                        if let contentStr = subJson.rawString() {
                            content = contentStr
                        }
                    }
                    else if index == "circle" {
                        if let circleStr = subJson.rawString() {
                            circleName = circleStr
                        }
                    }
                }

                let recmdArticleData = ArticleDataModel(circleName, article: content, owner: owner)
                self.recmdArticleDataResults.append(recmdArticleData)
            }
        }
    }
}
