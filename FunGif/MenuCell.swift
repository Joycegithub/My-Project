//
//  MenuCell.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/12.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var size: CGFloat {
        return label.font.value(forKey: "pointSize") as! CGFloat
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView!.backgroundColor = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1.0)
        
        if isSelected {
            label.font = UIFont(name: "AmericanTypewriter-Bold", size: size)
        } else {
            label.font = UIFont(name: "AmericanTypewriter", size: size)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
        super.setSelected(selected, animated: animated)

        if selected {
            label.font = UIFont(name: "AmericanTypewriter-Bold", size: size)
        } else {
            label.font = UIFont(name: "AmericanTypewriter", size: size)
        }
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted , animated: animated)
        
        if highlighted {
            label.font = UIFont(name: "AmericanTypewriter-Bold", size: size)
        } else {
            label.font = UIFont(name: "AmericanTypewriter", size: size)
        }
    }

}
