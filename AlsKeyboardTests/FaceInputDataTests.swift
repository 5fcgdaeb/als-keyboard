//
//  FaceInputDataTests.swift
//  AlsKeyboardTests
//
//  Created by Guven Bolukbasi on 29.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import XCTest

class FaceInputDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInputType() {
        
        let input1 = FaceInputData(faceCoordinates: [CGPoint.init(x: 3, y: 4)])
        XCTAssertFalse(input1.isAnchorBased)
        XCTAssertTrue(input1.isCoordinateBased)
        
        let input2 = FaceInputData(faceAnchors: ["a": Float(0.3)])
        XCTAssertTrue(input2.isAnchorBased)
        XCTAssertFalse(input2.isCoordinateBased)
    }
    
    func testTimeDifferenceBetweenInputs() {
        
        let input1 = FaceInputData(faceCoordinates: [])
        sleep(1)
        let input2 = FaceInputData(faceCoordinates: [])
        
        XCTAssertTrue(input1.timeDifference(fromInput: input2) > 0)
        
        let input3 = FaceInputData(faceCoordinates: [])
        sleep(1)
        let input4 = FaceInputData(faceCoordinates: [])
        
        XCTAssertTrue(input3.timeDifference(fromInput: input4) > 1)
        
        XCTAssertTrue(input3.timeDifference(fromInput: input3) == 0)
    }
    
    func testRetrievingCoordinateForAnchorBasedInput() {
        
        let input1 = FaceInputData(faceAnchors: ["a": Float(0.3)])
        let input2 = FaceInputData(faceAnchors: ["a": Float(0.3)])
        
        XCTAssertTrue(input1.maximumMovement(fromInput: input2) == -1)
        XCTAssertTrue(input1.isEverythingBelowMotionThreshold(fromInput: input2) == false)
        XCTAssertTrue(input1.comparisonCoordinates(withOtherInput: input2) == [CGPoint.init()])
        
    }
    
}
