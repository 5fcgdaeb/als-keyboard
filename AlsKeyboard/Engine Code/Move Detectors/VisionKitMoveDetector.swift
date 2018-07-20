//
//  VisionKitMoveDetector.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 29.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import CoreGraphics


let MOVEMENT_THRESHOLD = CGFloat(4)



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


class VisionKitMoveDetector: MoveDetector {
    
    private var observersById: [String: (FacialMove) -> ()] = [:]
    private var lastDetectedMove: FacialMove?
    
    func feed(faceData input: FaceInputData) {
        
        guard !self.tooEarlyToDetect(forInput: input) else {
            print("Just detected recently, waiting a bit")
            return
        }
        
        var detectedExpression: FacialExpression?
        
        if let expression = detectedExpression {
            let theMove = FacialMove(expression)
            self.lastDetectedMove = theMove
            self.notifyObservers(ofMove: theMove)
        }
        
    }
    
    func listenForMoves(withListenerId listenerId:String, andWithHandler handler: @escaping (FacialMove) -> ()) {
        self.observersById[listenerId] = handler
    }
    
    func stopListeningMoves(forListenerId listenerId: String) {
        self.observersById.removeValue(forKey: listenerId)
    }
    
    // MARK: Private Methods
    private func notifyObservers(ofMove move: FacialMove) {
        
        for (_, completionHandler) in observersById {
            completionHandler(move)
        }
    }
    
    private func tooEarlyToDetect(forInput input: FaceInputData) -> Bool {
        guard let latestMove = self.lastDetectedMove else { return false }
        
        return input.timeStamp.timeIntervalSince1970 < latestMove.secondsSince1970() + SECONDS_REQUIRED_BETWEEN_MOVES
    }
}

