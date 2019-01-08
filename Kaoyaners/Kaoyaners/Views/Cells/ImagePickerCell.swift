//
//  ImagePickerCell.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/8.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

// 相簿列表单元格

class ImagePickerCell: UITableViewCell {
    // 相簿名称标签
    @IBOutlet weak var titleLabel:UILabel!
    // 照片数量标签
    @IBOutlet weak var countLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
