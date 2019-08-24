//
//  DetailsViewController.swift
//  Bibinetalkole
//
//  Created by Isaac Samuel on 8/23/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    
    var post: [String: Any]?
    var postImage: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailShow()
    }
    func detailShow(){
        let imgArray = (postImage as AnyObject).value(forKey: "wp:featuredmedia")
        let mediaDetails = (imgArray as AnyObject).value(forKey: "media_details")
        let sizes = (mediaDetails as AnyObject).value(forKey: "sizes")
        do{
            let fullImage =  (sizes as AnyObject).value(forKey: "full")
            let dataDic = fullImage as? [[String: Any]]
            if dataDic != nil{
  //              self.imgPosts = dataDic!
                let imgPosts = dataDic!
                for images in imgPosts{
                    let imageURL = images["source_url"] as? String
                    print(imageURL!)
                    if let imagePath = imageURL,
                        let imgUrl = URL(string:  imagePath){
                        posterImageView.layer.borderColor = UIColor.white.cgColor
                        posterImageView.layer.borderWidth = 2.0
                        posterImageView.layer.cornerRadius = 10.0
                        posterImageView.clipsToBounds = true
                        posterImageView.af_setImage(withURL: imgUrl)
                    }
                    else{
                    }
                }
            }else{}
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
