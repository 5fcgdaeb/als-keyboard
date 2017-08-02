//
//  FaceRecognitionInput.swift
//  ExpressionRecognition
//
//  Created by MacbookPro on 19.04.2017.
//
//

import Foundation
import UIKit

class FaceRecognitionInput: NSObject {
    
    let sdkInput: SDKInput
    let timeStampOfInput: Date
    
    init(sdkInput: SDKInput, timeStamp: Date) {
        self.sdkInput = sdkInput
        self.timeStampOfInput = timeStamp
    }
    
    func rightEyeBrowCoordinates() -> [CGPoint] {
        let coordinate1: CGPoint = self.sdkInput.faceCoordinates[0]
        let coordinate2: CGPoint = self.sdkInput.faceCoordinates[1]
        let coordinate3: CGPoint = self.sdkInput.faceCoordinates[2]
        let coordinate4: CGPoint = self.sdkInput.faceCoordinates[3]
        return [coordinate1, coordinate2, coordinate3, coordinate4]
    }
    
    func averageRightEyeBrowLocation() -> CGPoint {
        let rightEyeBrowCoordinates = self.rightEyeBrowCoordinates()
        return self.averageOfCoordinates(coordinates: rightEyeBrowCoordinates)
    }
    
    func timeDifference(fromInput otherInput:FaceRecognitionInput) -> Int {
        let difference = self.timeStampOfInput.millisecondsSince1970 - otherInput.timeStampOfInput.millisecondsSince1970
        return abs(Int(difference))
    }
    
    func maximumMovement(fromInput otherInput:FaceRecognitionInput) -> CGFloat {
        var maximum = CGFloat(0)
        for (index, coordinate) in self.sdkInput.faceCoordinates.enumerated() {
            let otherCoordinate = otherInput.sdkInput.faceCoordinates[index]
            let movement = abs((otherCoordinate.x + otherCoordinate.y) - (coordinate.x + coordinate.y))
            if movement > maximum {
                maximum = movement
            }
        }
        return maximum
    }
    
    func isEverythingBelowMotionThreshold(fromInput otherInput:FaceRecognitionInput) -> Bool {
        for (index, coordinate) in self.sdkInput.faceCoordinates.enumerated() {
            let otherCoordinate = otherInput.sdkInput.faceCoordinates[index]
            let differenceInX = abs(coordinate.x - otherCoordinate.x)
            let differenceInY = abs(coordinate.y - otherCoordinate.y)
            if differenceInX > MOTION_THRESHOLD || differenceInY > MOTION_THRESHOLD {
                return false
            }
        }
        
        return true
    }
    
    func comparisonCoordinates(withOtherInput input:FaceRecognitionInput) -> [CGPoint] {
        var allCoordinates: [CGPoint] = []
        for (index, coordinate) in self.sdkInput.faceCoordinates.enumerated() {
            let differenceInX = coordinate.x - input.sdkInput.faceCoordinates[index].x
            let differenceInY = coordinate.y - input.sdkInput.faceCoordinates[index].y
            let coordinate = CGPoint(x: differenceInX, y: differenceInY)
            allCoordinates.append(coordinate)
        }
        
        return allCoordinates
    }
    
    private func averageOfCoordinates(coordinates: [CGPoint]) -> CGPoint {
        var sumOfX: CGFloat = 0
        var sumOfY: CGFloat = 0
        for coordinate in coordinates {
            sumOfX += coordinate.x
            sumOfY += coordinate.y
        }
        
        let averageXCoordinate = sumOfX / CGFloat(coordinates.count)
        let averageYCoordinate = sumOfY / CGFloat(coordinates.count)
        
        return CGPoint(x: averageXCoordinate, y: averageYCoordinate)
    }
    
    func averageOfWholeFace() -> CGPoint {
        return self.averageOfCoordinates(coordinates: self.sdkInput.faceCoordinates)
    }
}
