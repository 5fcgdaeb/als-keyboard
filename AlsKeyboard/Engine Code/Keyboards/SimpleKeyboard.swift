//
//  SimpleKeyboard.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 24.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

let MINIMUM_TIME_REQUIREMENT_BETWEEN_INPUTS = 0.3
let MAXIMUM_TIME_REQUIREMENT_BETWEEN_INPUTS = Double(3.5) // 500 milliseconds

class SimpleKeyboard: FacialMoveKeyboard {
    
    var letterMapping: LetterMapping
    
    private var moveDetector: MoveDetector
    private var bufferedFacialMoves: [FacialMove] = []
    private var shouldItType = true
    private var observers: [(String) -> ()] = []
    
    init(withMoveDetector moveDetector: MoveDetector) {
        
        self.moveDetector = moveDetector
        self.letterMapping = MappingGenerator().generateMapping(fromEasyToHardExpressions: [.blink, .jawMove, .lookLeft, .lookRight, .smile, .eyebrowMove])
        
        self.moveDetector.listenForMoves(withHandler: self.moveReceivedClosure())
    }
    
    func moveReceivedClosure() -> (FacialMove) -> () {
        
        return {
            
            [unowned self] facialMove in
            print("Keyboard received move")
            let areThereBufferedMoves = self.bufferedFacialMoves.count > 0
            
            if areThereBufferedMoves {
                let previousMove = self.bufferedFacialMoves[self.bufferedFacialMoves.count - 1]
                let timeDifferenceInSeconds = Double(facialMove.secondsSince1970() - previousMove.secondsSince1970())
                if timeDifferenceInSeconds < MINIMUM_TIME_REQUIREMENT_BETWEEN_INPUTS {
                    return
                }
            }
            
            self.bufferedFacialMoves.append(facialMove)
            
            if self.shouldItType {
                self.analyzeCommandToGenerateText()
            }
        }
    }
    
    func listenForKeyboardEvents(withHandler handler: @escaping (String) -> ()) {
        self.observers.insert(handler, at: 0)
    }
    
    func startTyping() {
        self.shouldItType = true
    }
    
    func resetState() {
        self.clearBufferedMoves()
    }
    
    private func analyzeCommandToGenerateText() {
        
        let bufferedMoveCount = self.bufferedFacialMoves.count
        if self.letterMapping.minimumExpressionCount != bufferedMoveCount { // We don't have enough moves yet
            return
        }
        else {
            let expressions = self.bufferedFacialMoves.map { $0.expression }
            
            var generatedCharacter = ""
            if let mappingValue = self.letterMapping[expressions] {
                generatedCharacter = mappingValue
                
            }
            for observer in self.observers {
                observer(generatedCharacter)
            }
            self.clearBufferedMoves()
        }
    }
    
    private func clearBufferedMoves() {
        self.bufferedFacialMoves.removeAll()
    }
}

/*
 
 E    11.1607%    56.88    M    3.0129%    15.36
 A    8.4966%    43.31    H    3.0034%    15.31
 R    7.5809%    38.64    G    2.4705%    12.59
 I    7.5448%    38.45    B    2.0720%    10.56
 O    7.1635%    36.51    F    1.8121%    9.24
 T    6.9509%    35.43    Y    1.7779%    9.06
 N    6.6544%    33.92    W    1.2899%    6.57
 S    5.7351%    29.23    K    1.1016%    5.61
 L    5.4893%    27.98    V    1.0074%    5.13
 C    4.5388%    23.13    X    0.2902%    1.48
 U    3.6308%    18.51    Z    0.2722%    1.39
 D    3.3844%    17.25    J    0.1965%    1.00
 P    3.1671%    16.14    Q    0.1962%    (1)
 
 */
