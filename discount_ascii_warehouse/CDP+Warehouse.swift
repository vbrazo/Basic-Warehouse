//
//  Warehouse+CoreDataProperties.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/7/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import Foundation
import CoreData

extension Warehouse {
    
    @NSManaged var id: Int16
    @NSManaged var face: String
    @NSManaged var price: Float
    @NSManaged var size: Int16
    @NSManaged var stock: Int16
    @NSManaged var type: String

}