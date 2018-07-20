//
//  MoveDetector.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 24.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

protocol MoveDetector {
    
    func feed(faceData input: FaceInputData)

    func listenForMoves(withListenerId listenerId:String, andWithHandler handler: @escaping (FacialMove) -> ())
    func stopListeningMoves(forListenerId listenerId: String)

}
