//
//  FeedsViewController.swift
//  Bibinetalkole
//
//  Created by Isaac Samuel on 8/20/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PostsCellDelegate{

    @IBOutlet weak var tableViewFeeds: UITableView!
    
    var posts: [[String: Any]] = []
    var pageID = 1
    var postsTitle: [[String: Any]] = []
    var postsContent: [[String: Any]] = []
    var postsEmbed: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    var imgURLShare: String?
    var urlShows = ""
    var convertedDate: String = ""
    var convertedTime: String = ""
    var titleShare: String?
    var postShare: [String: Any] = [:]
    var imagePost1: UIImageView?
    var imagePost2: UIImage?
    var imgShare: UIImage?
    
    /*override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }*/

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
        let post = posts[indexPath.row]
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
        cell.btnSharePosts.tag = indexPath.row
        
        let imgArray = (postImage as AnyObject).value(forKey: "wp:featuredmedia")
        let mediaDetails = (imgArray as AnyObject).value(forKey: "media_details")
        let sizes = (mediaDetails as AnyObject).value(forKey: "sizes")
        
        let encoded = postTitle["rendered"] as? String
        cell.titleFeeds.text = encoded?.stringByDecodingHTMLEntities
        titleShare = encoded?.stringByDecodingHTMLEntities
        //     print(encoded!)
        //       let htmlTag =  postContent["rendered"] as! String
        
        ////
        do{
            let medium =  (sizes as AnyObject).value(forKey: "medium")
            let dataDic = medium as? [[String: Any]]
            if dataDic != nil{
                self.imgPosts = dataDic!
                for images in imgPosts{
                    let imageURL = images["source_url"] as? String
                    imgURLShare = imageURL
                    //      print(imageURL!)
                    if let imagePath = imageURL,
                        let imgUrl = URL(string:  imagePath){
                        //          cell.posterImageView.layer.borderColor = UIColor.white.cgColor
                        //        cell.posterImageView.layer.borderWidth = 2.0
                        cell.imageFeeds.layer.cornerRadius = 2.0
                        cell.imageFeeds.clipsToBounds = true
                        cell.imageFeeds.af_setImage(withURL: imgUrl)
                        
                    }
                    else{
                    }
                    //  imgShare = cell.imagePost.image
                    imagePost1 = cell.imageFeeds
                    imagePost2 = cell.imageFeeds.image
                }
            }else{}
        }
        //date format conversion
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDateFormatter = DateFormatter()
        //        newDateFormatter.dateFormat = "MMM dd, yyyy"
        newDateFormatter.dateFormat = "dd MMM, yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH-mm-ss"
        let newTimeFormatter = DateFormatter()
        newTimeFormatter.dateFormat = "h:mm a"
        
        let dateTime = post["date"] as? String
        
        let dateComponents = dateTime?.components(separatedBy: "T")
        let splitDate = dateComponents![0]
        let splitTime = dateComponents![1]
        if let date = dateFormatter.date(from: splitDate) {
            convertedDate = newDateFormatter.string(from: date)
        }
        if let time = timeFormatter.date(from: splitTime){
            convertedTime = newTimeFormatter.string(from: time)
        }
        cell.dateFeeds.text = convertedDate
        
        cell.btnSharePosts.addTarget(self, action: #selector(FeedsViewController.shareTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func PostsCellDidTapShare(_ sender: FeedCell) {
        guard let tappedIndexPath = tableViewFeeds.indexPath(for: sender) else { return }
        print("Sharing", sender, tappedIndexPath)
    }
    
    @objc func shareTapped(_ sender: Any?) {
        print("share Tapped", sender!)
        
    }
    
    @IBAction func btnSharePosts(_ sender: UIButton) {
        
        postShare = posts[sender.tag]
        let postShare1 = (postShare as AnyObject).value(forKey: "title") as! [String : Any]
        let embedDic = (postShare as AnyObject).value(forKey: "_embedded")
        let embedDicString = embedDic! as! [String: Any]
        
        let title = (postShare1["rendered"] as? String)?.stringByDecodingHTMLEntities
        let URl = postShare["link"] as? String
        if let imgArray = (embedDicString as AnyObject).value(forKey: "wp:featuredmedia"){
            let mediaDetails = (imgArray as AnyObject).value(forKey: "media_details")
            let sizes = (mediaDetails as AnyObject).value(forKey: "sizes")
          //  let encoded = postTitle["rendered"] as? String
            let medium =  (sizes as AnyObject).value(forKey: "medium")
            let dataDic = medium as? [[String: Any]]
            self.imgPosts = dataDic!
                for images in imgPosts{
                    let imageURL = images["source_url"] as? String
                    print("image urlshare .......\(imageURL!)")
                    if let imagePath = imageURL,
                        let imgUrl = URL(string:  imagePath){
                        imagePost1?.af_setImage(withURL: imgUrl)
                        
                        
                    }
                    else{
                        imagePost1?.image = nil
                        print("+======================= nil ")
                    }
                let image = imagePost1?.image
                    let vc = UIActivityViewController(activityItems: [title as Any, URl!, image as Any], applicationActivities: [])
                    if let popoverController = vc.popoverPresentationController{
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = self.view.bounds
                    }
                    self.present(vc, animated: true, completion: nil)
                    imagePost1?.image = imagePost2
                }
            }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableViewFeeds?.indexPath(for: cell)
        let post = posts[(indexPath?.row)!]
        let postImage = postsEmbed[(indexPath?.row)!]
        let postContent = postsContent[(indexPath?.row)!]
        let detailViewController = segue.destination as! DetailsViewController
        detailViewController.post = post
        detailViewController.postImage = postImage
        detailViewController.postContent = postContent
    }
    
    
    
    
}
