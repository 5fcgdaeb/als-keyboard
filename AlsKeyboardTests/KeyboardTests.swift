//
//  FaceInputDataTests.swift
//  AlsKeyboardTests
//
//  Created by Guven Bolukbasi on 29.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import XCTest

class KeyboardTests: XCTestCase {
    
    var moveDetector: MoveDetector?
    var keyboard: FacialMoveKeyboard?
    
    override func setUp() {
//        self.moveDetector = ARKitMoveDetector()
//        self.keyboard = SimpleKeyboard(withDelegate: self)
        super.setUp()
    }
    
    override func tearDown() {
//        self.moveDetector = nil
//        self.keyboard = nil
        super.tearDown()
    }
    
    func testMoveDetection() {
        
        self.moveDetector?.listenForMoves { (facialMove) in
            print("Move came in!")
        }
        
        self.moveDetector?.feed(faceData: FaceInputData(faceCoordinates: []))
    }
    
    func testWholeFlow() {
    
        // 0. UI Input
        // 1. FaceInputData
        // 2. FacialMove?
        // 3. Character?
        
//        let inputData = FaceInputData(faceCoordinates: [])
//        let facialMove = self.moveDetector?.detectMoves(fromInput: inputData)
//        self.keyboard.process(facialMove: facialMove.first!)
        
    }
    
}
