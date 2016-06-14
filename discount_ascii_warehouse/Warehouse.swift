//
//  Schema.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/7/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import Foundation
import CoreData

@objc(Warehouse)
public class Warehouse: NSManagedObject {
    
    let errorDomain = "UserErrorDomain"
    
    enum UserErrorType: Int {
        case InvalidFace
    }
    
    func validateFace(value: AutoreleasingUnsafeMutablePointer<AnyObject?>) throws {
        var error: NSError? = nil;
        
        if let first = value.memory as? String {
            print(first)
            if first == "" {
                let errorType = UserErrorType.InvalidFace
                error = NSError(domain: errorDomain, code: errorType.rawValue, userInfo: [ NSLocalizedDescriptionKey : "The face cannot be empty." ] )
            }
        } else {
            let errorType = UserErrorType.InvalidFace
            error = NSError(domain: errorDomain, code: errorType.rawValue, userInfo: [ NSLocalizedDescriptionKey : "The face cannot be blank." ] )
        }
        
        if let error = error {
            throw error
        }
    }

}