//
//  CollectionViewController.swift
//  Bibinetalkole
//
//  Created by Isaac Samuel on 8/23/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import AlamofireImage

class CollectionViewcontroller: UICollectionViewController {
    
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
        
        navigationItem.title = "Bibinetalkole Shows"
  /*      if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }*/
 //       collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 8, bottom: 10, right: 8)
        
        collectionView?.dataSource = self
        fetchShows()
    }
    
}

extension CollectionViewcontroller: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewCell", for: indexPath as IndexPath) as! ViewCell
  
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
        cell.titleLabel.text = encoded?.stringByDecodingHTMLEntities
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
                        cell.posterImageView.layer.cornerRadius = 6.0
                        cell.posterImageView.clipsToBounds = true
                        cell.posterImageView.af_setImage(withURL: imgUrl)
                    }
                    else{
                    }
                }
            }else{}
        }
        ////

        
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
                    self.collectionView?.reloadData() // to tell table about new data
                }
            }else{
                print("nil")
            }
        }
    }
    func loadMoreShows(){
        pageID = pageID + 1
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
                do{
                    
                    for item in result!
                    {
                        
                        self.posts.append(item)
                        
                    }
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData() // to tell table about new data
                    }
                }
            }else{
                /*
                let errorAlertController = UIAlertController(title: "End of posts", message: "Please Top up the list", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
                */
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
         // animation 2
         cell.alpha = 0
         UIView.animate(withDuration: 1.5){
         cell.alpha = 1.0
         }
        
        
        if indexPath.row + 1 == posts.count{
            loadMoreShows()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize+40)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView?.indexPath(for: cell)
        let post = posts[(indexPath?.row)!]
        let postImage = postsEmbed[(indexPath?.row)!]
        let postContent = postsContent[(indexPath?.row)!]
        let detailViewController = segue.destination as! DetailsViewController
        detailViewController.post = post
        detailViewController.postImage = postImage
        detailViewController.postContent = postContent
        
    }
    
}
