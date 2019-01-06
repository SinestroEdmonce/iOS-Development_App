//
//  ShareSelectionStaticDataModel.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class ShareSelectionStaticDataModel: NSObject {
    var selectionTypeImage: UIImage
    var selectionTypeName: String!
    
    init(image: UIImage, name: String){
        self.selectionTypeImage = image
        self.selectionTypeName = name
    }
}
