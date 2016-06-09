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
import CoreData

enum HTTPTYPE {
    case GET, PUT, DELETE, POST
}

public class Global {
    
    let modelHelper = ModelHelper()
    let coreDataStack = CoreDataStack()
    
    func request(url: String, params: Dictionary<String,AnyObject>?, headers: Dictionary<String,String>?, type: HTTPTYPE, completion:(Dictionary<Int,JSON>) -> Void)  {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            do {
                
                var opt : HTTP!
                var results : Dictionary<Int,JSON> = [:]
                
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
                            let json = "[\(fullNameArr[i])]"
                            results[i] = JSON(json.parseJSONString!)
                        }
                        completion(results)
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

extension String {
    var parseJSONString: AnyObject? {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
                let message = try NSJSONSerialization.JSONObjectWithData(jsonData, options:.MutableContainers)
                if let jsonResult = message as? NSMutableArray {
                    print(jsonResult)
                    
                    return jsonResult //Will return the json array output
                } else {
                    return nil
                }
            } catch let error as NSError {
                print("An error occurred: \(error)")
                return nil
            }
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}