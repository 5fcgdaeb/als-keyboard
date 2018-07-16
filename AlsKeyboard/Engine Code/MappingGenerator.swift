//
//  MappingGenerator.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 6.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

struct MappingGenerator {
    
    private var availableCharacters: [String] = []
    
    init() {
        self.availableCharacters = self.charactersUserCanType()
    }
    
    func generateMapping(fromEasyToHardExpressions expressionsOfUser: [FacialExpression]) -> LetterMapping {
        
        guard expressionsOfUser.count > 1 else { return LetterMapping.emptyMapping() }
        
        let userExpressionCount = expressionsOfUser.count
        let countOfAllCharacters = self.availableCharacters.count
        
        var expressionCountRequiredToTypeOneCharacter = 1
        while(Int(pow(Double(userExpressionCount), Double(expressionCountRequiredToTypeOneCharacter))) < countOfAllCharacters) {
            expressionCountRequiredToTypeOneCharacter += 1
        }
        
        if expressionCountRequiredToTypeOneCharacter > userExpressionCount {
            return LetterMapping.emptyMapping()
        }
        
        var allPossibleExpressionCombinations = self.allCombinations(ofExpressions: expressionsOfUser, withLength: expressionCountRequiredToTypeOneCharacter)
        
        if countOfAllCharacters > allPossibleExpressionCombinations.count {
            return LetterMapping.emptyMapping()
        }
        
        var mapping: [[FacialExpression]: String] = [:]
        for (index, character) in self.availableCharacters.enumerated() {
            let combination = allPossibleExpressionCombinations[index]
            mapping[combination] = String(character)
        }
        
        return LetterMapping(allLetters: self.charactersUserCanType(), mapping: mapping)
    }
    
    private func allCombinations(ofExpressions expressions: [FacialExpression], withLength length: Int) -> [[FacialExpression]] {
        
        let totalCombinationCount = Int( pow(Double(expressions.count), Double(length)) )
        var allPossibleExpressionCombinations: [[FacialExpression]] = []
        
        for i in 0..<totalCombinationCount {
            
            let paddedString = String(i, radix:length).pad(with:"0", toLength:length)
            var resultForThisCombination: [FacialExpression] = []
            
            for j in 0..<length {
                let indexToUse = Int(String(paddedString.characterAtIndex(index: j)!))!
                let expressionToUse = expressions[indexToUse]
                resultForThisCombination.append(expressionToUse)
            }
            
            allPossibleExpressionCombinations.append(resultForThisCombination)
        }
        
        return allPossibleExpressionCombinations
    }
    
    private func charactersUserCanType() -> [String] {
        return "abcdefghijklmnopqrstuvwxyz ".map { String($0) }
    }
    
}
