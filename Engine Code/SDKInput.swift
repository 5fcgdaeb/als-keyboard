//
//  SDKInput.swift
//  ExpressionRecognition
//
//  Created by Guven Bolukbasi on 20/04/2017.
//
//

import Foundation
import UIKit

class SDKInput: NSObject {
    let faceCoordinates: [CGPoint]
    
    init(faceCoordinates: [CGPoint]) {
        self.faceCoordinates = faceCoordinates
    }
}
