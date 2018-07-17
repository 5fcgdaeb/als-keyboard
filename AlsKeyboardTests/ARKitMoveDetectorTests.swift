//
//  FaceInputDataTests.swift
//  AlsKeyboardTests
//
//  Created by Guven Bolukbasi on 29.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import XCTest
import ARKit

class ARKitMoveDetectorTests: XCTestCase {
    
    var moveDetector: MoveDetector?
    
    override func setUp() {
        self.moveDetector = ARKitMoveDetector()
        super.setUp()
    }
    
    override func tearDown() {
        self.moveDetector = nil
        super.tearDown()
    }
    
    func testMoveDetection() {
        
        let moveExpectation = XCTestExpectation(description: "There should be a detected move!")
        
        self.moveDetector?.listenForMoves { (facialMove) in
            
            XCTAssertTrue(facialMove.secondsSince1970() > 0)
            moveExpectation.fulfill()
        }
        
        let inputData1 = FaceInputData(faceAnchors: [ARFaceAnchor.BlendShapeLocation.eyeBlinkLeft.rawValue:0.9])
        self.moveDetector?.feed(faceData: inputData1)
        
        let result = XCTWaiter().wait(for: [moveExpectation], timeout: 1.0)
        XCTAssertTrue(result == .completed)
        
    }
    
    func testNoMoveDetection() {
        
        let moveExpectation = XCTestExpectation(description: "No move should be detected!")
        
        self.moveDetector?.listenForMoves { (facialMove) in
            
            XCTAssertTrue(facialMove.secondsSince1970() > 0)
            moveExpectation.fulfill()
        }
        
        let inputData2 = FaceInputData(faceAnchors: [:])
        self.moveDetector?.feed(faceData: inputData2)
        
        let result = XCTWaiter().wait(for: [moveExpectation], timeout: 1.0)
        XCTAssertTrue(result == .timedOut)
        
    }
    
}
