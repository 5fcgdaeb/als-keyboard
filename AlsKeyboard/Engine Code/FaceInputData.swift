//
//  FaceRecognitionInput.swift
//  ExpressionRecognition
//
//  Created by MacbookPro on 19.04.2017.
//
//

import Foundation
import UIKit

class FaceInputData: NSObject {
    
    let faceCoordinates: [CGPoint]
    let faceAnchors: [String: Float]
    let timeStamp: Date
    
    init(faceCoordinates: [CGPoint]) {
        self.faceCoordinates = faceCoordinates
        self.faceAnchors = [:]
        self.timeStamp = Date()
    }
    
    init(faceAnchors: [String: Float]) {
        self.faceAnchors = faceAnchors
        self.faceCoordinates = []
        self.timeStamp = Date()
    }
    
    func timeDifference(fromInput otherInput:FaceInputData) -> Int {
        let difference = self.timeStamp.timeIntervalSince1970 - otherInput.timeStamp.timeIntervalSince1970
        return abs(Int(difference))
    }
    
    func maximumMovement(fromInput otherInput:FaceInputData) -> CGFloat {
        var maximum = CGFloat(0)
        for (index, coordinate) in self.faceCoordinates.enumerated() {
            let otherCoordinate = otherInput.faceCoordinates[index]
            let movement = abs((otherCoordinate.x + otherCoordinate.y) - (coordinate.x + coordinate.y))
            if movement > maximum {
                maximum = movement
            }
        }
        return maximum
    }
    
    func isEverythingBelowMotionThreshold(fromInput otherInput:FaceInputData) -> Bool {
        for (index, coordinate) in self.faceCoordinates.enumerated() {
            let otherCoordinate = otherInput.faceCoordinates[index]
            let differenceInX = abs(coordinate.x - otherCoordinate.x)
            let differenceInY = abs(coordinate.y - otherCoordinate.y)
            if differenceInX > MOTION_THRESHOLD || differenceInY > MOTION_THRESHOLD {
                return false
            }
        }
        
        return true
    }
    
    func comparisonCoordinates(withOtherInput input:FaceInputData) -> [CGPoint] {
        var allCoordinates: [CGPoint] = []
        for (index, coordinate) in self.faceCoordinates.enumerated() {
            let differenceInX = coordinate.x - input.faceCoordinates[index].x
            let differenceInY = coordinate.y - input.faceCoordinates[index].y
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
}
