//
//  AyiboAPIManager.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 1/28/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import Foundation

struct AyiboAPIManager{
    
    static let shared:AyiboAPIManager = AyiboAPIManager()
    
    func get(url:String, completion: @escaping ([[String: Any]]?, String?) -> Void ){
        let urlRequest = URLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: urlRequest) { ( data, response, error) in
           
            if error != nil {
                completion(nil, error?.localizedDescription)
                return
            }
           
            
            do{
                
                
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String : Any]]
                
                /*
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(data)
                let json = String(data: jsonData, encoding: .utf8)
                */
                
                completion(json, nil)
                
                
            }catch{
                print("Error: \(error.localizedDescription)")
                
            }
                
        }.resume()
    }
}
