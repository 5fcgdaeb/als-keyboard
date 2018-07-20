//
//  FacialMoveKeyboard.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 24.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation


protocol FacialMoveKeyboard {
    
    var letterMapping: LetterMapping { get }
    
    func resetState()
    
    func listenForKeyboardEvents(withListenerId listenerId: String, andWithHandler handler: @escaping (String) -> ())
    func stopListeningEvents(forListenerId listenerId: String)

}
