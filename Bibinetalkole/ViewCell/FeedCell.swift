//
//  FeedCell.swift
//  Bibinetalkole
//
//  Created by Isaac Samuel on 8/25/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var imageFeeds: UIImageView!
    @IBOutlet weak var titleFeeds: UILabel!
    @IBOutlet weak var dateFeeds: UILabel!
    @IBOutlet weak var imageBackShare: UIImageView!
    @IBOutlet weak var btnSharePosts: UIButton!
    
    var buttonTapped = false
    var buttonTapped2 = false
    weak var delegate: PostsCellDelegate?
    
    @IBAction func shareTapped(_ sender: UIButton) {
        delegate?.PostsCellDidTapShare(self)
        
        if buttonTapped2 == false{
            let buttonRow = sender.tag
            btnSharePosts.tag = buttonRow
            btnSharePosts.addTarget(self,action:#selector(shareTapped(_:)),
                                    for:.touchUpInside)
            print("share succesfully of index \(buttonRow)")
            btnSharePosts.index(ofAccessibilityElement: buttonRow)
            buttonTapped2 = true
            
        }
            
        else{
            let buttonRow = sender.tag
            btnSharePosts.tag = buttonRow
            btnSharePosts.addTarget(self,action:#selector(shareTapped(_:)),
                                    for:.touchUpInside)
            print("share of index \(buttonRow)")
            //           saveButton.setTitle("Save", for: UIControlState .normal)
            //   btnSharePosts.setImage(UIImage(named: "addtag100"), for: .normal)
            buttonTapped = false
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
protocol PostsCellDelegate : class {
    func PostsCellDidTapShare(_ sender: FeedCell)
}
