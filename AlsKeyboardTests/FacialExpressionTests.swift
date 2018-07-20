//
//  FacialExpressionTests.swift
//  AlsKeyboardTests
//
//  Created by Guven Bolukbasi on 29.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import XCTest

class FacialExpressionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEqualityOfExpressionArrays() {
        
        let expressions1: [FacialExpression] = [.jawMove, .blink, .eyebrowMove]
        let expressions2: [FacialExpression] = [.jawMove, .lookRight, .eyebrowMove]
        let expressions3: [FacialExpression] = [.jawMove, .lookRight, .eyebrowMove]
        
        XCTAssertFalse(expressions1 == expressions3)
        
        XCTAssertTrue(expressions2 == expressions3)
    }
    
    func testExpressionListDescription() {
        
        let expressions1: [FacialExpression] = [.jawMove, .blink, .eyebrowMove]
        
        XCTAssertNotNil(expressions1.expressionListDescription())
        XCTAssertTrue(expressions1.expressionListDescription().count > 0)
        
        let expressions2: [FacialExpression] = []
        
        XCTAssertNotNil(expressions2.expressionListDescription())
        XCTAssertTrue(expressions2.expressionListDescription().count == 0)
    }
    
}
