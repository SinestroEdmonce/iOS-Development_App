//
//  ResourceCell.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/1.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class ResourceCell: UITableViewCell {
    
    @IBOutlet weak var resourceFileCategoryImage: UIImageView!
    @IBOutlet weak var resourceCategory: UILabel!
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var reviewCounter: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var resourceName: UILabel!
    @IBOutlet weak var resourceIntro: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
