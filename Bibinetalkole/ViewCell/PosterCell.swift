//
//  PosterCell.swift
//  Bibinetalkole
//
//  Created by Isaac Samuel on 8/22/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class PosterCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   //     containerView.layer.backgroundColor = UIColor.darkGray.cgColor
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
}

