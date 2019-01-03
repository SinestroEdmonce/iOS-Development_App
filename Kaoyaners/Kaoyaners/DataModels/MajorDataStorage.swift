//
//  MajorDataStorage.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/3.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class MajorDataStorage: NSObject {
    var majorDataResults = [ResourceDataModel]()
    
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
            
            let majorData = ResourceDataModel(imageURL: imageURL, resourceCategory: category, subjectName: subject, ownerName: owner, resourceName: srcName, resourceIntro: srcIntro, reviewCounter: revCounter)
            self.majorDataResults.append(majorData)
        }
    }
}
