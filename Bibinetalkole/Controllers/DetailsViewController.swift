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
    
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var playAudio: WKWebView!
    
    @IBOutlet weak var contentLabel: UILabel!
    var post: [String: Any]?
    var postImage: [String: Any]?
    var postContent: [String: Any]?
    
    var urlShows = ""
    var urlShows1 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailShow()
        playAudio.isOpaque = false
    }
    func showActivityIndicator(show: Bool) {
        if show {
            Activity.startAnimating()
        } else {
            Activity.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation:
        WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation
        navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation:
        WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
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
                     //   posterImageView.layer.borderColor = UIColor.white.cgColor
                    //    posterImageView.layer.borderWidth = 2.0
                      //  posterImageView.layer.cornerRadius = 10.0
                  //      posterImageView.clipsToBounds = true
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
                    print("ok")
                    let request = URLRequest(url: url)
                    print(request)
                    playAudio.load(request)
                    playAudio.navigationDelegate = self as? WKNavigationDelegate
                    playAudio.scrollView.isScrollEnabled = false
                }
            }
            else{
            }
        }
        
        //Content Description
    
        let html3 = htmlTag.allStringsBetween(start: "[vc_column_text]", end: "</p>")
        let input3 = String(describing: html3)
        let html4 = input3.allStringsBetween(start: "[", end: "&lt;iframe")
        let input4 = String(describing: html4)
        let html5 = input4.replacingOccurrences(of: "[\"\\\"", with: "",
                                                options: NSString.CompareOptions.literal, range:nil)
        let content1 = html5.replacingOccurrences(of: "\\\", \\\"\"]", with: "",
                                                   options: NSString.CompareOptions.literal, range:nil)
        let content = content1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  //      print("==========================\n\(content)")
        if content != "[]"{
            contentLabel.text = content.stringByDecodingHTMLEntities
        }
        else{
            contentLabel.text = ""
        }
    }
   /* func webViewDidFinishLoad(_ : WKWebView) {
        Activity.stopAnimating()
        Activity.isHidden = true
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
