//
//  Global.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/1/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

enum HTTPTYPE {
    case GET, PUT, DELETE, POST
}

public class Global {
    
    public var base_url = "http://74.50.59.155:5000/api"
    
    func request(url: String, params: Dictionary<String,AnyObject>?, headers: Dictionary<String,String>?, type: HTTPTYPE, completion:(Array<String>) -> Void)  {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            do {
                
                var opt : HTTP!
                
                switch type {
                    case .GET:
                        opt = try HTTP.GET(url, parameters: params, headers: headers)
                    case .PUT:
                        opt = try HTTP.PUT(url, parameters: params, headers: headers)
                    case .DELETE:
                        opt = try HTTP.DELETE(url, parameters: params, headers: headers)
                    case .POST:
                        opt = try HTTP.POST(url, parameters: params, headers: headers)
                }
                
                opt.start { response in
                    
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        return
                    }
                    
                    if let text = response.text {
                        let fullNameArr = text.characters.split{$0 == "\n"}.map(String.init)
                        for i in 0...fullNameArr.count-1 {
                            print(JSON(fullNameArr[i]))
                        }
                        completion(fullNameArr)
                    } else {
                        print("got an error")
                        return
                    }
                    
                }
                
            } catch let error {
                print("got an error creating the request: \(error)")
            }
            
        })
    }
    
}