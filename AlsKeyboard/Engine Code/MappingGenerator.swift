//
//  MappingGenerator.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 6.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

struct MappingGenerator {
    
    private var a: Int = 0
    private var availableCharacters: [String] = []
    
    init() {
        self.availableCharacters = self.charactersUserCanType()
    }
    
    func generateMapping(fromEasyToHardExpressions expressions: [FacialExpression]) -> [[FacialExpression]: String] {
        
        guard expressions.count > 1 else { return [:] }
        
        let expressionCount = expressions.count
        let characterCount = self.availableCharacters.count
        
        var expressionCountRequiredToTypeOneCharacter = 1
        while(Int(pow(Double(expressionCount), Double(expressionCountRequiredToTypeOneCharacter))) < characterCount) {
            expressionCountRequiredToTypeOneCharacter += 1
        }
        
        if expressionCountRequiredToTypeOneCharacter > expressionCount {
            return [:]
        }
        
        let totalCombinationCount = Int( pow(Double(expressionCountRequiredToTypeOneCharacter), Double(expressionCountRequiredToTypeOneCharacter)) )
        let expressionsWeWillUse = expressions[0..<expressionCountRequiredToTypeOneCharacter]
        var allPossibleExpressionCombinations: [[FacialExpression]] = []
        
        for i in 0..<totalCombinationCount {
            
            let paddedString = String(i, radix:3).pad(with:"0", toLength:3)
            var resultForThisCombination: [FacialExpression] = []
            
            for j in 0..<expressionsWeWillUse.count {
                let indexToUse = Int(String(paddedString.characterAtIndex(index: j)!))!
                let expressionToUse = expressionsWeWillUse[indexToUse]
                resultForThisCombination.append(expressionToUse)
            }
            
            allPossibleExpressionCombinations.append(resultForThisCombination)
        }
        
//        for (index, character) in self.availableCharacters.enumerated() {
//
//        }
        return [[.blink]:"a"]
    }
    
    private func charactersUserCanType() -> [String] {
        return "abcdefghijklmnopqrstuvwxyz ".map { String($0) }
    }
    
}
