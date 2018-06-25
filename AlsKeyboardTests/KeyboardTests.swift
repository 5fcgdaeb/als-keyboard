//
//  DisplayLiveSamplesTests.swift
//  DisplayLiveSamplesTests
//
//  Created by Luis Reisewitz on 15.05.16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//

import XCTest

class KeyboardTests: XCTestCase, KeyboardDelegate {
    
    var moveDetector: MoveDetector?
    var keyboard: FacialMoveKeyboard?
    
    override func setUp() {
        self.moveDetector = ARKitMoveDetector()
        self.keyboard = SimpleKeyboard(withDelegate: self)
        super.setUp()
    }
    
    override func tearDown() {
        self.moveDetector = nil
        self.keyboard = nil
        super.tearDown()
    }
    
    func testExample() {
        var keyboard = SimpleKeyboard(withDelegate: self)
//        keyboard.
    }
    
    func testWholeFlow() {
    
        // 0. UI Input
        // 1. FaceInputData
        // 2. FacialMove?
        // 3. Character?
        
        let inputData = FaceInputData(faceCoordinates: [])
        let facialMove = self.moveDetector?.detectMoves(fromInput: inputData)
        self.keyboard.process(facialMove: facialMove.first!)
        
    }
    
    func displayTextUpdated(value: String) {}
    func displayReceivedCommand(value: String) {}
    func clearCommandBuffer() {}
    func deleteFirstCommandFromBuffer() {}
    
}
