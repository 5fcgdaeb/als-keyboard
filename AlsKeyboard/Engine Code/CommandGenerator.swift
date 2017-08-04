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
//            print("Error - Hit the maximum, starting over again.")
            self.allFaceRecognitionInputs.removeAll()
            return nil
        }
        
        self.allFaceRecognitionInputs.append(input)
        let currentInputCount = self.allFaceRecognitionInputs.count
        
        guard currentInputCount > MINIMUM_FACE_RECOGNITION_INPUT else {
//            print("Error - Still warming up the engine.  [\(Date().alsFriendlyDate())]")
            return nil
        }
        
        let previousInput = self.allFaceRecognitionInputs[currentInputCount - 2]
        
        let difference = previousInput.timeDifference(fromInput:input)
        
        if difference > MAXIMUM_TIME_DIFFERENCE_BETWEEN_INPUTS {
//            print("Error - Too much time passed since the last input, ignoring this one.")
            return nil
        }
        
        let comparisonCoordinates = previousInput.comparisonCoordinates(withOtherInput: input)
        
        let hasEverythingMoved = self.hasEverythingMoved(comparisonCoordinates: comparisonCoordinates)
        
        let haveEyebrowsBeenRaised = self.haveEyebrowsBeenRaised(comparisonCoordinates: comparisonCoordinates)
        
        if hasEverythingMoved {
            print("EVERYTHING MOVED")
            return nil
        }
        
        if haveEyebrowsBeenRaised {
//            print("EYEBROW RAISED!")
            return Command.allCommands()[0]
        }
        
        return nil
    }
    
    func haveEyebrowsBeenRaised(comparisonCoordinates: [CGPoint]) -> Bool {
        let sumOfRightX = comparisonCoordinates[18].x + comparisonCoordinates[19].x + comparisonCoordinates[20].x + comparisonCoordinates[21].x + comparisonCoordinates[22].x
        let sumOfLeftX = comparisonCoordinates[23].x + comparisonCoordinates[24].x + comparisonCoordinates[25].x + comparisonCoordinates[26].x + comparisonCoordinates[27].x
        let sumOfRightY = comparisonCoordinates[18].y + comparisonCoordinates[19].y + comparisonCoordinates[20].y + comparisonCoordinates[21].y + comparisonCoordinates[22].y
        let sumOfLeftY = comparisonCoordinates[23].y + comparisonCoordinates[24].y + comparisonCoordinates[25].y + comparisonCoordinates[26].y + comparisonCoordinates[27].y
        
        let averageOfrightX = sumOfRightX / 5
        let averageOfrightY = sumOfRightY / 5
        
        let averageOfLeftX = sumOfLeftX / 5
        let averageOfLeftY = sumOfLeftY / 5
        
        let averageLastX = (averageOfrightX + averageOfLeftX) / 2
        let averageLastY = (averageOfrightY + averageOfLeftY) / 2
        
        return averageLastY > 10 && abs(averageLastX) < 10
    }
    
    func hasEverythingMoved(comparisonCoordinates: [CGPoint]) -> Bool {
        var sumOfX: CGFloat = 0
        var sumOfY: CGFloat = 0
        for coordinate in comparisonCoordinates {
            sumOfX += coordinate.x
            sumOfY += coordinate.y
        }
        
        let averageXCoordinate = sumOfX / CGFloat(comparisonCoordinates.count)
        let averageYCoordinate = sumOfY / CGFloat(comparisonCoordinates.count)
        
        return abs(averageXCoordinate) > 11 || abs(averageYCoordinate) > 11
    }
}
