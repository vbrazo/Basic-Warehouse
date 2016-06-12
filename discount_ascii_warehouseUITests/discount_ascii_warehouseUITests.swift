//
//  discount_ascii_warehouseUITests.swift
//  discount_ascii_warehouseUITests
//
//  Created by Vitor Oliveira on 6/12/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import XCTest

class discount_ascii_warehouseUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialStateIsCorrect() {
        let collections = XCUIApplication().collectionViews
        XCTAssertEqual(collections.count, 1, "There should be 1 collectionView initially")
        XCTAssert(app.staticTexts["labelCurrentlyInStock"].exists)
    }
    
    func testUserFilterAndSearch(){
        
        sleep(2)
        
        let textField = app.textFields["txtSearch"]
        textField.tap()
        textField.typeText("amet bored flat")
        
        app.buttons["btnSearch"].tap()
        
        sleep(4)
        
    }
    
    func testBottomPullToRefresh() {
        
        sleep(2)
        
        let firstCell = app.staticTexts["lblFace0"]
        let start = firstCell.coordinateWithNormalizedOffset(CGVectorMake(0, 30))
        let finish = firstCell.coordinateWithNormalizedOffset(CGVectorMake(0, 0))
        start.pressForDuration(1, thenDragToCoordinate: finish)
        
        sleep(2)
    
    }

}