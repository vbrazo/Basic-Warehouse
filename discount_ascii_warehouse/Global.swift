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
    
    var screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
    var screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
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
                        let fullHash = text.characters.split{$0 == "\n"}.map(String.init)
                        for i in 0...fullHash.count-1 {
                            let json = "[\(fullHash[i])]"
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
    
    func refresh_models(stock : CurrentlyInStock, txtSearch: String?, completion: (Bool) -> Void) {
        
        modelHelper.delete_all("Warehouses") { (response) in
            
            var params = [String: AnyObject]()
            
            if (stock.type == .HIDE) {
                params["onlyInStock"] = true
            } else {
                params["onlyInStock"] = false
            }
            
            if let text = txtSearch {
                params["q"] = text
            }
            
            self.request(ROUTES.search, params: params, headers: nil, type: HTTPTYPE.GET) { (response) in
            
                if response.count > 0 {
                    for i in 0...response.count-1 {
        
                        let warehouse = NSEntityDescription.insertNewObjectForEntityForName("Warehouses", inManagedObjectContext: self.coreDataStack.context) as! Warehouse
                    
                        if let info = response[i] {
                            let hash = info[0]
                            warehouse.face = hash["face"].stringValue
                            warehouse.id = hash["id"].stringValue
                            warehouse.price = hash["price"].floatValue
                            warehouse.size = Int16(hash["size"].intValue)
                            warehouse.stock = Int16(hash["stock"].intValue)
                        }
                    }
                
                    do {
                        try self.coreDataStack.context.save()
                    } catch let error as NSError  {
                        print("Could not save \(error)")
                    }

                }
            }
        }
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