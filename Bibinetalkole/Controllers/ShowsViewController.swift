//
//  ShowsViewController.swift
//  Bibinetalkole
//
//  Created by Isaac Samuel on 8/20/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [[String: Any]] = []
    var postsTitle: [[String: Any]] = []
    var postsContent: [[String: Any]] = []
    var urlShows = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bibinetalkole"
        
        tableView.rowHeight = 200
        tableView.estimatedRowHeight = 300
        tableView.dataSource = self
        
        fetchShows()
    }
    
    private func fetchShows(){
        AyiboAPIManager.shared.get(url: "http://bibinetalkole.com/wp-json/wp/v2/posts?page=2&categories=20") { (result, error) in
            if error != nil{
                let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
                print(error!)
                
                return
            }
                    print(result!)
            self.posts = result!
            //autolayout engine from a background thread” error Fixed
            DispatchQueue.main.async { //that allows the UI to update as soon as execution of thread function complete
                self.tableView.reloadData() // to tell table about new data
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showsCell", for: indexPath) as! ShowsViewCell
        
        do{
            let titleDic = (posts as AnyObject).value(forKey: "title")
            let contentDic = (posts as AnyObject).value(forKey: "content")
            
            let titleDicString = titleDic as? [[String: Any]]
            let contentDicString = contentDic as? [[String: Any]]
            
            self.postsTitle = titleDicString!
            self.postsContent = contentDicString!
        }
        let postTitle = postsTitle[indexPath.row]
        let postContent = postsContent[indexPath.row]
        
        let encoded = postTitle["rendered"] as? String
        let htmlTag =  postContent["rendered"] as! String
        
        cell.titleLabel.text = encoded?.stringByDecodingHTMLEntities
        
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
                    cell.webView.load(request)
                }
                
            }
            else{
            }
        }
        return cell
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
