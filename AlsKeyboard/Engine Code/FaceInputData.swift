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
    
    var isAnchorBased: Bool {
        get {
            return self.faceAnchors.count > 0
        }
    }
    
    var isCoordinateBased: Bool {
        get {
            return !self.isAnchorBased
        }
    }
    
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
    
    func timeDifference(fromInput otherInput:FaceInputData) -> TimeInterval {
        return abs(self.timeStamp.timeIntervalSince(otherInput.timeStamp))
    }
    
    func maximumMovement(fromInput otherInput:FaceInputData) -> CGFloat {
        
        guard self.isCoordinateBased else { return -1 }
        
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
    
    func isEverythingBelow(motionThreshold threshold:CGFloat, comparedToInput otherInput:FaceInputData) -> Bool {
        
        guard self.isCoordinateBased else { return false }
        
        for (index, coordinate) in self.faceCoordinates.enumerated() {
            let otherCoordinate = otherInput.faceCoordinates[index]
            let differenceInX = abs(coordinate.x - otherCoordinate.x)
            let differenceInY = abs(coordinate.y - otherCoordinate.y)
            if differenceInX > threshold || differenceInY > threshold {
                return false
            }
        }
        
        return true
    }
    
    func comparisonCoordinates(withOtherInput input:FaceInputData) -> [CGPoint] {
        
        guard self.isCoordinateBased else { return [CGPoint.init()] }
        
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
        
        guard self.isCoordinateBased else { return CGPoint.init() }
        
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
