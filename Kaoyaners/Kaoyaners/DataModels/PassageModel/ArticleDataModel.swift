//
//  ArticleDataModel.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/11.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class ArticleDataModel: NSObject {
    
    var circleName: String!
    var passageContent: String!
    var ownerName: String!
    
    init(_ circle: String, article: String, owner: String){
        
        self.circleName = circle
        self.passageContent = article
        self.ownerName = owner
    }
    
}
