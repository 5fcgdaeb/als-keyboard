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
    
    func testExample() {
        
        let mapping = self.generator.generateMapping(fromEasyToHardExpressions: [.blink])
        XCTAssertTrue(mapping.count == 0)
    }
    
}
