//
//  ResourceDataModel.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/3.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class ResourceDataModel: NSObject {
    
    var imageURL: String!
    var resourceCategory: String!
    var subjectName: String!
    var ownerName: String!
    var resourceName: String!
    var resourceIntro: String!
    
    init(imageURL: String, resourceCategory: String, subjectName: String, ownerName: String, resourceName: String, resourceIntro: String){
        
        self.imageURL = imageURL
        self.resourceCategory = resourceCategory
        self.subjectName = subjectName
        self.ownerName = ownerName
        self.resourceName = resourceName
        self.resourceIntro = resourceIntro
    }
}
