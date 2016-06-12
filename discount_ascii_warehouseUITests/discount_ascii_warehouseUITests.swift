//
//  discount_ascii_warehouseUITests.swift
//  discount_ascii_warehouseUITests
//
//  Created by Vitor Oliveira on 6/12/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import XCTest

class discount_ascii_warehouseUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialStateIsCorrect() {
        let collections = XCUIApplication().collectionViews
        XCTAssertEqual(collections.count, 1, "There should be 1 object initially")
    }

}