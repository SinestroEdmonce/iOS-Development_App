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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
