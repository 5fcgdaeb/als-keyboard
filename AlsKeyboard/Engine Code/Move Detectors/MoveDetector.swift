//
//  MoveDetector.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 24.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

protocol MoveDetector {
    func detectMoves(fromInput input: FaceInputData) -> [FacialMove]
}
