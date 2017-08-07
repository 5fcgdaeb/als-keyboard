//
//  RecognationEngine.swift
//  ExpressionRecognition
//
//  Created by MacbookPro on 7.04.2017.
//
//

import Foundation
import UIKit

class CommandGenerator: NSObject {
    
    var allFaceRecognitionInputs: [FaceRecognitionInput] = []
    
    func process(input: FaceRecognitionInput) -> Command? {
        guard self.allFaceRecognitionInputs.count < MAXIMUM_FACE_RECOGNITION_INPUT else {
            self.allFaceRecognitionInputs.removeAll()
            return nil
        }
        
        self.allFaceRecognitionInputs.append(input)
        let currentInputCount = self.allFaceRecognitionInputs.count
        
        guard currentInputCount > MINIMUM_FACE_RECOGNITION_INPUT else {
            return nil
        }
        
        let previousInput = self.allFaceRecognitionInputs[currentInputCount - 2]
        
        let difference = previousInput.timeDifference(fromInput:input)
    
        print(difference)
        
        if difference > MAXIMUM_TIME_REQUIREMENT_BETWEEN_INPUTS {
            return nil
        }
        
        let comparisonCoordinates = previousInput.comparisonCoordinates(withOtherInput: input)
        
        let haveEyebrowsBeenRaised = self.haveEyebrowsBeenRaised(comparisonCoordinates: comparisonCoordinates)
        
        let haveEyesBeenBlinked = self.haveEyesBeenBlinked(comparisonCoordinates: comparisonCoordinates)
        
        let isSmiling = self.isSmiling(comparisonCoordinates: comparisonCoordinates)
        
        let isEverythingMoved = self.isEverythingMoved(comparisonCoordinates: comparisonCoordinates)
        
        if isEverythingMoved {
            return Command.allCommands()[8]
        }
        
        if isSmiling {
            return Command.allCommands()[7]
        }
        
        if haveEyebrowsBeenRaised {
            return Command.allCommands()[0]
        }
        
        if haveEyesBeenBlinked {
            return Command.allCommands()[1]
        }
        
        return nil
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
    
    func isEverythingMoved(comparisonCoordinates: [CGPoint]) -> Bool {
        let centerOfFaceX = abs(comparisonCoordinates[28].x + comparisonCoordinates[34].x + comparisonCoordinates[9].x) / 3
        let centerOfFaceY = abs(comparisonCoordinates[28].y + comparisonCoordinates[34].y + comparisonCoordinates[9].y) / 3
        
        return centerOfFaceY > 10 || centerOfFaceX > 10
    }
}
