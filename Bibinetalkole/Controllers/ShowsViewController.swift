//
//  ShowsViewController.swift
//  Bibinetalkole
//
//  Created by Isaac Samuel on 8/20/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class ShowsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [[String: Any]] = []
    var pageID = 1
    var postsTitle: [[String: Any]] = []
    var postsContent: [[String: Any]] = []
    var postsEmbed: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    var imgURLShare: String?
    
    var urlShows = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
 
        fetchShows()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
  //      let show = posts[indexPath.item]

        do{
            let titleDic = (posts as AnyObject).value(forKey: "title")
            let embedDic = (posts as AnyObject).value(forKey: "_embedded")
            
            let titleDicString = titleDic as? [[String: Any]]
            let embedDicString = embedDic as? [[String: Any]]
            
            self.postsTitle = titleDicString!
            self.postsEmbed = embedDicString!
        }
        let postTitle = postsTitle[indexPath.row]
        let postImage = postsEmbed[indexPath.row]
        
        let imgArray = (postImage as AnyObject).value(forKey: "wp:featuredmedia")
        let mediaDetails = (imgArray as AnyObject).value(forKey: "media_details")
        let sizes = (mediaDetails as AnyObject).value(forKey: "sizes")
        
        let encoded = postTitle["rendered"] as? String
        print(encoded!)
        ////
        do{
            let thumbnail =  (sizes as AnyObject).value(forKey: "thumbnail")
            let dataDic = thumbnail as? [[String: Any]]
            if dataDic != nil{
                self.imgPosts = dataDic!
                //          let remoteImageUrlString = imgPosts[indexPath.row]
                //   }
                ////
                for images in imgPosts{
                    let imageURL = images["source_url"] as? String
                    print(imageURL!)
                    if let imagePath = imageURL,
                        let imgUrl = URL(string:  imagePath){
                        cell.posterImageView.layer.borderColor = UIColor.white.cgColor
                        cell.posterImageView.layer.borderWidth = 2.0
                        cell.posterImageView.layer.cornerRadius = 2.0
                        cell.posterImageView.clipsToBounds = true
                        cell.posterImageView.af_setImage(withURL: imgUrl)
                    }
                    else{
                    }
                }
            }else{}
        }
        ////
    //    cell.titleLabel.text = encoded?.stringByDecodingHTMLEntities
        
        return cell
    }
    
    func fetchShows(){
        AyiboAPIManager.shared.get(url: "http://bibinetalkole.com/wp-json/wp/v2/posts?page=\(pageID)&categories=20&_embed") { (result, error) in
            if error != nil{
                let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
                print(error!)
                
                return
            }
            if result != nil{
                //   print(result!)
                self.posts = result!
                //autolayout engine from a background thread” error Fixed
                DispatchQueue.main.async { //that allows the UI to update as soon as execution of thread function complete
                    self.collectionView.reloadData() // to tell table about new data
                }
            }else{
                print("nil")
            }
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
