//
//  MusicPickerCell.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/11.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class MusicPickerCell: UITableViewCell {
    @IBOutlet weak var fileTypeImage: UIImageView!
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    @IBOutlet weak var fileTime: UILabel!
    
    // 设置选中状态
    open override var isSelected: Bool {
        didSet{
            if isSelected {
                self.selectedIcon.image = UIImage(named: "_image_selected")
            }else{
                self.selectedIcon.image = UIImage(named: "_image_not_selected")
            }
        }
    }
    
    // 播放动画，选中状态图标改变时使用
    func playAnimate() {
        // 图标先缩小，再放大
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        self.selectedIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4,
                                                       animations: {
                                                        self.selectedIcon.transform = CGAffineTransform.identity
                                    })
        }, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
