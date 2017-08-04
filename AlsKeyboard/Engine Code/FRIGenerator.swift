//
//  FRIGenerator.swift
//  ExpressionRecognition
//
//  Created by Guven Bolukbasi on 20/04/2017.
//
//

import Foundation

class FRIGenerator: NSObject {

    func generateFRI(withSDKInput sdkInput: SDKInput) -> FaceRecognitionInput? {
        
        guard sdkInput.faceCoordinates.count > 0 else {
            return nil
        }
        
        return FaceRecognitionInput(sdkInput: sdkInput, timeStamp: Date())
    }
}
