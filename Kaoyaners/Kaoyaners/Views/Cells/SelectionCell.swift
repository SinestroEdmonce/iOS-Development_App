//
//  SelectionCellTableViewCell.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/6.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class SelectionCell: UITableViewCell {
    @IBOutlet weak var selectionTypeImage: UIImageView!
    @IBOutlet weak var selectionTypeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData2Cell(data: ShareSelectionStaticDataModel){
        // Initialize the cell
        self.selectionTypeImage.image = data.selectionTypeImage
        self.selectionTypeName.text = data.selectionTypeName
        self.accessoryType = .disclosureIndicator
    }
}
