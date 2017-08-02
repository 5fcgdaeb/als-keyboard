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
            print("Error - Hit the maximum, starting over again.")
            self.allFaceRecognitionInputs.removeAll()
            return nil
        }
        
        self.allFaceRecognitionInputs.append(input)
        let currentInputCount = self.allFaceRecognitionInputs.count
        
        guard currentInputCount > MINIMUM_FACE_RECOGNITION_INPUT else {
            print("Error - Still warming up the engine.  [\(Date().alsFriendlyDate())]")
            return nil
        }
        
        let previousInput = self.allFaceRecognitionInputs[currentInputCount - 2]
        
        let difference = previousInput.timeDifference(fromInput:input)
        if difference > MAXIMUM_TIME_DIFFERENCE_BETWEEN_INPUTS {
            print("Error - Too much time passed since the last input, ignoring this one.")
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
            print("EYEBROW RAISED!")
            return Command.allCommands()[0]
        }
        
        return nil
    }
    
    func haveEyebrowsBeenRaised(comparisonCoordinates: [CGPoint]) -> Bool {
        let sumOfLeftY = comparisonCoordinates[0].y + comparisonCoordinates[1].y + comparisonCoordinates[2].y + comparisonCoordinates[3].y
        let sumOfRightY = comparisonCoordinates[4].y + comparisonCoordinates[5].y + comparisonCoordinates[6].y + comparisonCoordinates[7].y
        
        let leftYAverage = sumOfLeftY / 4
        let rightYAverage = sumOfRightY / 4
        
        print("-----")
        
        print("0.X => \(comparisonCoordinates[0].x)")
        print("1.X => \(comparisonCoordinates[1].x)")
        print("2.X => \(comparisonCoordinates[2].x)")
        print("3.X => \(comparisonCoordinates[3].x)")
        
        print("-----")
        
        print("0.Y => \(comparisonCoordinates[0].y)")
        print("1.Y => \(comparisonCoordinates[1].y)")
        print("2.Y => \(comparisonCoordinates[2].y)")
        print("3.Y => \(comparisonCoordinates[3].y)")
        
        print("-----")
        
        return leftYAverage > 15 || rightYAverage > 15
    }
    
    func hasEverythingMoved(comparisonCoordinates: [CGPoint]) -> Bool {
        let middleOfFaceX = comparisonCoordinates[62].x
        let middleOfFaceY = comparisonCoordinates[62].y
        
        return middleOfFaceX > 15 || middleOfFaceY > 15
    }
}
