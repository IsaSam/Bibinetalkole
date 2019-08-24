//
//  DetailsViewController.swift
//  Bibinetalkole
//
//  Created by Isaac Samuel on 8/23/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var playAudio: WKWebView!
    
    var post: [String: Any]?
    var postImage: [String: Any]?
    var postContent: [String: Any]?
    
    var urlShows = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailShow()
    }
    func detailShow(){
        //for images
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
              //      print(imageURL!)
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
        //audio content
        let htmlTag =  postContent!["rendered"] as! String
        
        let html2 = htmlTag.allStringsBetween(start: "iframe src=", end: "/iframe")
        let input = String(describing: html2)
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let urlYou = input[range]
            if urlYou != ""{
                urlShows = String(urlYou)
                print(urlShows)
                
                if let url = URL(string: urlShows) {
                    let request = URLRequest(url: url)
                    playAudio.load(request)
                    playAudio.scrollView.isScrollEnabled = false
                }
            }
            else{
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
