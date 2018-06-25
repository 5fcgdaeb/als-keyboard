//
//  ALSEngine.swift
//  ExpressionRecognition
//
//  Created by Guven Bolukbasi on 20/04/2017.
//
//

import Foundation
import UIKit

let MOTION_THRESHOLD = CGFloat(4)
let MOVEMENT_THRESHOLD = CGFloat(4)

let MINIMUM_FACE_RECOGNITION_INPUT = 5
let MAXIMUM_FACE_RECOGNITION_INPUT = 10000

let MINIMUM_TIME_REQUIREMENT_BETWEEN_INPUTS = 0.3
let MAXIMUM_TIME_REQUIREMENT_BETWEEN_INPUTS = 3500 // 500 milliseconds

let MAXIMUM_EYEBROW_X_LOCATION_WIGGLE_ROOOM = CGFloat(4)
let MINIMUM_EYEBROW_Y_LOCATION_CHANGE = CGFloat(7)
let MAXIMUM_EYEBROW_Y_LOCATION_CHANGE = CGFloat(80)

let MAXIMUM_MOUTH_X_LOCATION_WIGGLE_ROOOM = CGFloat(4)
let MINIMUM_MOUTH_Y_LOCATION_CHANGE = CGFloat(10)
let MAXIMUM_MOUTH_Y_LOCATION_CHANGE = CGFloat(80)
let MAXIMUM_MOUTH_UPPER_LIP_Y_LOCATION_CHANGE = CGFloat(30)

let MINIMUM_RECOGNITION_LIMIT_FOR_LONG_BLINK = CGFloat(2)
let MINIMUM_EYE_BROW_DIFFERENCE = CGFloat(5)
let MINIMUM_EYE_BROW_AND_EYE_DIFFERENCE = CGFloat(5)

let MINIMUM_MOUTH_DIFFERENCE = CGFloat(200)
let MINIMUM_EYE_MOVEMENT_DISTANCE = CGFloat(200)

protocol KeyboardDelegate {
    func displayTextUpdated(value: String)
    func displayReceivedCommand(value: String)
    func clearCommandBuffer()
    func deleteFirstCommandFromBuffer()
}

class ALSEngine: NSObject {

    let moveDetector: MoveDetector
    let keyboardEngine: FacialMoveKeyboard
    
    init(withKeyboardDelegate keyboardDelegate: KeyboardDelegate) {
        self.moveDetector = DLibMoveDetector()
        self.keyboardEngine = SimpleKeyboard(withDelegate: keyboardDelegate)
    }
    
    func startTyping() {
        self.keyboardEngine.startTyping()
    }
    
    func resetState() {
        self.keyboardEngine.resetState()
    }
    
    func process(faceInputData data: FaceInputData) {
        
        let detectedMoves = self.moveDetector.detectMoves(fromInput: data)
        if detectedMoves.count > 0 {
            self.keyboardEngine.process(facialMove: detectedMoves.first!)
        }
    }
}
