//
//  CircleContentCell.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/1.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class CircleContentCell: UITableViewCell {
    
    @IBOutlet weak var circleNameButton: UIButton!
    @IBOutlet weak var circleOperator: UIButton!
    @IBOutlet weak var circleContentView: UITextView!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var ownerName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadData2Cell(data: ArticleDataModel){
        // Initialize the cell
        self.circleNameButton.setTitle(data.circleName, for: .normal)
        self.circleContentView.attributedText = NSAttributedString(string: data.passageContent)
        self.ownerName.text = data.ownerName
        
        // Button operated settings
        self.reviewButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.reviewButton.setTitleColor(UIColor.darkText, for: .highlighted)
        
        self.favButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.favButton.setTitleColor(UIColor.darkText, for: .highlighted)
        
        self.upButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.upButton.setTitleColor(UIColor.darkText, for: .highlighted)
        
        self.shareButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.shareButton.setTitleColor(UIColor.darkText, for: .highlighted)
    }
    
}
