//
//  Global.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/1/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import UIKit
import CoreData
import SwiftHTTP
import SwiftyJSON

enum HTTPTYPE {
    case GET, PUT, DELETE, POST
}

struct User {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var auth_token : String = ""
    var email : String = ""
    var facebook_id : String = ""
    var name : String = ""
    var user_id : String = ""
    
    init(){
        
        if let auth_token = defaults.stringForKey("auth_token") {
            self.auth_token = auth_token
        }
        
        if let email = defaults.stringForKey("email") {
            self.email = email
        }
        
        if let facebook_id = defaults.stringForKey("facebook_id") {
            self.facebook_id = facebook_id
        }
        
        if let name = defaults.stringForKey("name") {
            self.name = name
        }
        
        if let user_id = defaults.stringForKey("user_id") {
            self.user_id = user_id
        }
        
    }
}

public class GlobalHelper {
    
    var screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
    var screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func request(url: String, params: Dictionary<String,AnyObject>?, headers: Dictionary<String,String>?, type: HTTPTYPE, completion:(JSON) -> Void)  {
        
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
                    
                    do {
                        let object:AnyObject? = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments)
                        let json = JSON(object!)
                        return completion(json)
                    } catch _ as NSError {
                        return
                    } catch {
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
            do {
                let message = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
                if let jsonResult = message as? NSMutableArray {
                    return jsonResult
                } else {
                    return nil
                }
            } catch let error as NSError {
                print("An error occurred: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
}