//
//  discount_ascii_warehouseTests.swift
//  discount_ascii_warehouseTests
//
//  Created by Vitor Oliveira on 6/11/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import CoreData
import discount_ascii_warehouse
import SwiftyJSON
import UIKit
import XCTest

class discount_ascii_warehouseTests: XCTestCase {
    
    var coreDataStack : CoreDataStack!
    var globalService : GlobalService!
    var warehouseService: WarehouseService!
    
    override func setUp() {
        super.setUp()
        
        self.coreDataStack = TestCoreDataStack()
        self.warehouseService = WarehouseService(context: coreDataStack.privateContext, coreDataStack: coreDataStack)
        self.globalService = GlobalService(context: coreDataStack.privateContext, coreDataStack: coreDataStack)
    
    }

    override func tearDown() {
        super.tearDown()
        self.coreDataStack = nil
        self.warehouseService = nil
    }
    
    //
    // TDD: Core Data - Warehouse Entity
    //
    
    func testAddWarehouse() {
        
        let uid = Int16(1)
        let face = "test"
        let id = "( ⚆ _ ⚆ )"
        let size = Int16(1)
        let stock = Int16(1)
        let tags : JSON = []
        
        let warehouse = self.warehouseService.add(uid,
                                                  face: face,
                                                  id: id,
                                                  price: 1.2,
                                                  size: size,
                                                  stock: stock,
                                                  tags: tags)
        
        XCTAssertNotNil(warehouse, "Warehouse should not be nil")
        XCTAssertNotNil(warehouse?.face, "Camper should not be nil")
        XCTAssertTrue(warehouse?.face == "test")
        XCTAssertTrue(warehouse?.id == "( ⚆ _ ⚆ )")
        
    }
    
    func testResetWarehouse() {
        self.globalService.reset("Warehouses") { (response) in
            XCTAssertTrue(response == true)
        }
    }
    
    //
    // TDD: Core Data - Tag Entity
    //
    
    func testResetTag() {
        self.globalService.reset("Tags") { (response) in
            XCTAssertTrue(response == true)
        }
    }

}