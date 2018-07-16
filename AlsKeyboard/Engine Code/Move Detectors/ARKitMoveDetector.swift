//
//  ARKitMoveDetector.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 24.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation
import ARKit

let MOVE_DETECTION_THRESHOLD_BETWEEN_ZERO_AND_ONE: Float = 0.7
let SECONDS_REQUIRED_BETWEEN_MOVES = 0.8

class ARKitMoveDetector: MoveDetector {
    
    private var observers: [(FacialMove) -> ()] = []
    private var lastDetectedMove: FacialMove?
    
    func feed(faceData input: FaceInputData) {
        
        guard !self.tooEarlyToDetect(forInput: input) else {
//            print("Just detected recently, waiting a bit")
            return
        }
        
        var faceAnchors = input.faceAnchors
        
        faceAnchors.forEach{
            if $0.value < MOVE_DETECTION_THRESHOLD_BETWEEN_ZERO_AND_ONE {
                faceAnchors[$0.key] = nil
            }
        }
        
//        let sortedAnchors = faceAnchors.sorted { $0.value < $1.value}
//        let debugDescription = sortedAnchors.map { "\($0.0) - \($0.1)" }
//        print(debugDescription)
        
        var detectedExpression: FacialExpression?
        
        for (key, _) in faceAnchors {
            
            switch key {
            
            case ARFaceAnchor.BlendShapeLocation.eyeLookOutRight.rawValue, ARFaceAnchor.BlendShapeLocation.eyeLookInLeft.rawValue:
                detectedExpression = .lookRight
            case ARFaceAnchor.BlendShapeLocation.eyeLookOutLeft.rawValue, ARFaceAnchor.BlendShapeLocation.eyeLookInRight.rawValue:
                detectedExpression = .lookLeft
            case ARFaceAnchor.BlendShapeLocation.jawOpen.rawValue:
                detectedExpression = .jawMove
            case ARFaceAnchor.BlendShapeLocation.browInnerUp.rawValue, ARFaceAnchor.BlendShapeLocation.browOuterUpLeft.rawValue, ARFaceAnchor.BlendShapeLocation.browOuterUpRight.rawValue:
                detectedExpression = .eyebrowMove
            case ARFaceAnchor.BlendShapeLocation.mouthSmileLeft.rawValue, ARFaceAnchor.BlendShapeLocation.mouthSmileRight.rawValue:
                detectedExpression = .smile
            case ARFaceAnchor.BlendShapeLocation.eyeBlinkLeft.rawValue, ARFaceAnchor.BlendShapeLocation.eyeBlinkRight.rawValue:
                detectedExpression = .blink
            default:
                detectedExpression = .none
            }
            
            if let _ = detectedExpression { break }
        }
        
        if let expression = detectedExpression {
            let theMove = FacialMove(expression)
            self.lastDetectedMove = theMove
            self.notifyObservers(ofMove: theMove)
        }
        
    }
    
    func listenForMoves(withHandler handler: @escaping (FacialMove) -> ()) {
        self.observers.insert(handler, at: 0)
    }
    
    
    // MARK: Private Methods
    private func notifyObservers(ofMove move: FacialMove) {
        
        for observer in observers {
            observer(move)
        }
    }
    
    private func tooEarlyToDetect(forInput input: FaceInputData) -> Bool {
        guard let latestMove = self.lastDetectedMove else { return false }
        
        return input.timeStamp.timeIntervalSince1970 < latestMove.secondsSince1970() + SECONDS_REQUIRED_BETWEEN_MOVES
    }
}
