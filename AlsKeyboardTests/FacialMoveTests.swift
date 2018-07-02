//
//  FacialMoveTests.swift
//  AlsKeyboardTests
//
//  Created by Guven Bolukbasi on 2.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import XCTest

class FacialMoveTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMoveCreation() {
        
        let move1 = FacialMove(.blink)
        
        XCTAssertNotNil(move1.timestamp)
        XCTAssertTrue(move1.secondsSince1970() > 0)
        
        let move2 = FacialMove(.blink)
        XCTAssertTrue(move2.secondsSince1970() > move1.secondsSince1970())
    }
    
    func testMoveEquality() {
        
        let move1 = FacialMove(.blink)
        sleep(1)
        let move2 = FacialMove(.blink)
        
        XCTAssertFalse(move1 == move2)
    }
    
}
