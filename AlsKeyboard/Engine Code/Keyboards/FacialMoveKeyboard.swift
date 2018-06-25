//
//  FacialMoveKeyboard.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 24.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

struct KeyboardOutput {
    var bufferedFacialMoves: [FacialMove]
    var typedCharacter: String?
}

protocol FacialMoveKeyboard {
    var commandMapping: [[FacialExpression] : String] { get }
    func process(facialMove move: FacialMove) -> KeyboardOutput
    func startTyping()
    func resetState()
}
