//
//  DLibMoveDetector.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 24.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation
import CoreGraphics

let MINIMUM_FACE_RECOGNITION_INPUT = 5
let MAXIMUM_FACE_RECOGNITION_INPUT = 10000

class DLibMoveDetector: MoveDetector {
    
    var allFaceRecognitionInputs: [FaceInputData] = []
    var allComparisonCoordinates: [String: Any] = [:]
    
    func detectMoves(fromInput input: FaceInputData) -> [FacialMove] {
        
        guard self.allFaceRecognitionInputs.count < MAXIMUM_FACE_RECOGNITION_INPUT else {
            self.allFaceRecognitionInputs.removeAll()
            return []
        }
        
        self.allFaceRecognitionInputs.append(input)
        let currentInputCount = self.allFaceRecognitionInputs.count
        
        guard currentInputCount > MINIMUM_FACE_RECOGNITION_INPUT else {
            return []
        }
        
        let previousInput = self.allFaceRecognitionInputs[currentInputCount - 2]
        
        let coordinatesToCompareTo = previousInput.comparisonCoordinates(withOtherInput: input)
        
        let haveEyebrowsBeenRaised = self.haveEyebrowsBeenRaised(comparisonCoordinates: coordinatesToCompareTo)
        let haveEyesBeenBlinked = self.haveEyesBeenBlinked(comparisonCoordinates: coordinatesToCompareTo)
        let isSmiling = self.isSmiling(comparisonCoordinates: coordinatesToCompareTo)
        
        if haveEyebrowsBeenRaised {
            return [FacialMove(.eyebrowMove)]
        }
        
        if haveEyesBeenBlinked {
            return [FacialMove(.blink)]
        }
        
        if isSmiling {
            return [FacialMove(.smile)]
        }
        
        return []
    }
    
    func haveEyebrowsBeenRaised(comparisonCoordinates: [CGPoint]) -> Bool {
        let sumOfRightX = comparisonCoordinates[18].x + comparisonCoordinates[19].x + comparisonCoordinates[20].x + comparisonCoordinates[21].x + comparisonCoordinates[22].x
        let sumOfLeftX = comparisonCoordinates[23].x + comparisonCoordinates[24].x + comparisonCoordinates[25].x + comparisonCoordinates[26].x + comparisonCoordinates[27].x
        let sumOfRightY = comparisonCoordinates[18].y + comparisonCoordinates[19].y + comparisonCoordinates[20].y + comparisonCoordinates[21].y + comparisonCoordinates[22].y
        let sumOfLeftY = comparisonCoordinates[23].y + comparisonCoordinates[24].y + comparisonCoordinates[25].y + comparisonCoordinates[26].y + comparisonCoordinates[27].y
        
        let averageOfRightX = sumOfRightX / 5
        let averageOfRightY = sumOfRightY / 5
        
        let averageOfLeftX = sumOfLeftX / 5
        let averageOfLeftY = sumOfLeftY / 5
        
        let averageLastX = (averageOfRightX + averageOfLeftX) / 2
        let averageLastY = (averageOfRightY + averageOfLeftY) / 2
        
        return averageLastY > 10 && abs(averageLastX) < 10
    }
    
    func haveEyesBeenBlinked(comparisonCoordinates: [CGPoint]) -> Bool {
        let sumOfTopY = comparisonCoordinates[38].y + comparisonCoordinates[39].y + comparisonCoordinates[44].y + comparisonCoordinates[45].y
        let sumOfBottomY = comparisonCoordinates[42].y + comparisonCoordinates[41].y + comparisonCoordinates[48].y + comparisonCoordinates[47].y
        
        let averageOfTopY = sumOfTopY / 4
        let averageOfBottomY = sumOfBottomY / 4
        
        return abs(averageOfTopY - averageOfBottomY) > 10
    }
    
    func isSmiling(comparisonCoordinates: [CGPoint]) -> Bool {
        let leftCorner = comparisonCoordinates[55].x
        let rightCorner = comparisonCoordinates[49].x
        
        return abs(leftCorner - rightCorner) > 10 && abs(leftCorner - rightCorner) < 20
    }
    
    func feed(faceData input: FaceInputData) {}
    func listenForMoves(withHandler handler: @escaping (FacialMove) -> ()) {}
}
