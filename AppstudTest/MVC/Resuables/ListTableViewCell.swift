//
//  ListTableViewCell.swift
//  AppstudTest
//
//  Created by thejus manoharan on 09/06/2018.
//  Copyright © 2018 thejus. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewLabel: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageBackground: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.viewLabel.backgroundColor = .clear
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        visualEffectView.frame = CGRect(x:0 , y:0, width:UIScreen.main.bounds.width, height:40)
        self.labelTitle.alpha = 0.3
        
        self.viewLabel.insertSubview(visualEffectView, at: 0)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
