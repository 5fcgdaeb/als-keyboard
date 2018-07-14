//
//  MappingGeneratorTests.swift
//  AlsKeyboardTests
//
//  Created by Guven Bolukbasi on 6.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import XCTest

class MappingGeneratorTests: XCTestCase {
    
    let generator: MappingGenerator = MappingGenerator()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFailureWithJustOneExpression() {
        
        let mapping = self.generator.generateMapping(fromEasyToHardExpressions: [.blink])
        XCTAssertTrue(mapping.count == 0)
    }
    
    func testFailureWithTwoExpressions() {
        
        let mapping = self.generator.generateMapping(fromEasyToHardExpressions: [.blink, .jawMove])
        XCTAssertTrue(mapping.count == 0)
    }
    
    func testSuccessWithMoreThanTwoExpressions() {
        
        let mapping = self.generator.generateMapping(fromEasyToHardExpressions: [.blink, .jawMove, .lookLeft])
        XCTAssertTrue(mapping.count > 0)
    }
    
    func testRequiredExpressionCountWIthThreeExpressions() {
        
        let mapping = self.generator.generateMapping(fromEasyToHardExpressions: [.blink, .jawMove, .lookLeft])
        XCTAssertTrue(mapping.count > 0)
        
        let sampleKey = mapping.keys.first!
        XCTAssertTrue(sampleKey.count == 3)
        
    }
    
}
