//
//  Warehouse+CoreDataProperties.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/7/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import Foundation
import CoreData

public extension Warehouse {

    @NSManaged var uid: Int16
    @NSManaged var id: String
    @NSManaged var face: String
    @NSManaged var price: Float
    @NSManaged var size: Int16
    @NSManaged var stock: Int16
    @NSManaged var type: String
    @NSManaged var tag: Set<Tag>

}