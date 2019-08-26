//
//  FeedsViewController.swift
//  Bibinetalkole
//
//  Created by Isaac Samuel on 8/20/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class FeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableViewFeeds: UITableView!
    
    var posts: [[String: Any]] = []
    var pageID = 1
    var postsTitle: [[String: Any]] = []
    var postsContent: [[String: Any]] = []
    var postsEmbed: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    var imgURLShare: String?
    
    var urlShows = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Bibinetalkole"
        fetchPosts()
        tableViewFeeds.delegate = self
        tableViewFeeds.rowHeight = 280
        tableViewFeeds.estimatedRowHeight = 300
        tableViewFeeds.dataSource = self
        
        
        //   self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    func fetchPosts(){
        
        AyiboAPIManager.shared.get(url: "http://bibinetalkole.com/wp-json/wp/v2/posts?&page=\(pageID)&_embed") { (result, error) in
            if error != nil{
                let errorAlertController = UIAlertController(title: "Cannot Get Datas", message: "The Internet connections appears to be offline", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
                print(error!)
                return
            }
            if result != nil{
                print(result!)
                self.posts = result!
                DispatchQueue.main.async {
                    self.tableViewFeeds?.reloadData()
                }
            }else{
                print("nil")
            }
        }
    }
    
    func loadMorePosts(){
        pageID = pageID + 1
        AyiboAPIManager.shared.get(url: "http://bibinetalkole.com/wp-json/wp/v2/posts?&page=\(pageID)&_embed") { (result, error) in
            if error != nil{
                let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
                print(error!)
                
                return
            }
            if result != nil{
                do{
                    
                    for item in result!
                    {
                        
                        self.posts.append(item)
                        
                    }
                    DispatchQueue.main.async {
                        self.tableViewFeeds?.reloadData() // to tell table about new data
                    }
                }
            }else{
                let errorAlertController = UIAlertController(title: "End of posts", message: "Please Top up the list", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count{
            loadMorePosts()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewFeeds.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        do{
            let titleDic = (posts as AnyObject).value(forKey: "title")
            let embedDic = (posts as AnyObject).value(forKey: "_embedded")
            let contentDic = (posts as AnyObject).value(forKey: "content")
            
            let titleDicString = titleDic as? [[String: Any]]
            let embedDicString = embedDic as? [[String: Any]]
            let contentDicString = contentDic as? [[String: Any]]
            
            self.postsTitle = titleDicString!
            self.postsEmbed = embedDicString!
            self.postsContent = contentDicString!
            
        }
        let postTitle = postsTitle[indexPath.row]
        let postImage = postsEmbed[indexPath.row]
        //    let postContent = postsContent[indexPath.row]
        
        let imgArray = (postImage as AnyObject).value(forKey: "wp:featuredmedia")
        let mediaDetails = (imgArray as AnyObject).value(forKey: "media_details")
        let sizes = (mediaDetails as AnyObject).value(forKey: "sizes")
        
        let encoded = postTitle["rendered"] as? String
        cell.titleFeeds.text = encoded?.stringByDecodingHTMLEntities
        //     print(encoded!)
        //       let htmlTag =  postContent["rendered"] as! String
        
        ////
        do{
            let medium =  (sizes as AnyObject).value(forKey: "medium")
            let dataDic = medium as? [[String: Any]]
            if dataDic != nil{
                self.imgPosts = dataDic!
                //          let remoteImageUrlString = imgPosts[indexPath.row]
                //   }
                ////
                for images in imgPosts{
                    let imageURL = images["source_url"] as? String
                    //      print(imageURL!)
                    if let imagePath = imageURL,
                        let imgUrl = URL(string:  imagePath){
                        //          cell.posterImageView.layer.borderColor = UIColor.white.cgColor
                        //        cell.posterImageView.layer.borderWidth = 2.0
                        cell.imageFeeds.layer.cornerRadius = 2.0
                        cell.imageFeeds.clipsToBounds = true
                        cell.imageFeeds.af_setImage(withURL: imgUrl)
                        //     cell.imageFeeds.cornerRadus(usingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
                    }
                    else{
                    }
                }
            }else{}
        }
        
        return cell
    }
    
    
    
}
