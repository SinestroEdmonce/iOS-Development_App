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
    @IBOutlet weak var intervalView: UIView!
    
    private let eliptical: String = "\n\n"
    private let linesMax: Int = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData2Cell(data: ResourceDataModel){
        // Initialize the cell
        
        self.resourceFileCategoryImage.image = UIImage(named: "AvatarDefault")
        self.resourceCategory.text = data.resourceCategory
        self.subjectName.text = data.subjectName
        self.ownerName.text = data.ownerName
        self.reviewCounter.text = data.reviewCounter
        self.resourceName.text = data.resourceName
        
        // Introduction settings
        self.resourceIntro.text = data.resourceIntro + self.eliptical
        self.resourceIntro.numberOfLines = self.linesMax
        self.resourceIntro.lineBreakMode = .byTruncatingTail
    }
    
}
