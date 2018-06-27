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


class ALSEngine: NSObject {

    let moveDetector: MoveDetector
    let keyboardEngine: FacialMoveKeyboard
    
    override init() {
        self.moveDetector = ARKitMoveDetector()
        self.keyboardEngine = SimpleKeyboard(withMoveDetector: self.moveDetector)
    }
}
