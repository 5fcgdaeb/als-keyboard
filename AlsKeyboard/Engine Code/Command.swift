//
//  Command.swift
//  ExpressionRecognition
//
//  Created by MacbookPro on 19.04.2017.
//
//

import Foundation

struct Command {
    
    let commandID: String
    let shortCode: String
    let createdAt: Date
    
    static func allCommands() -> [Command] {
        let command1 = Command(commandID: "EyebrowRaise", shortCode: "ER", createdAt: Date())
        let command2 = Command(commandID: "Blink", shortCode: "BB", createdAt: Date())
        let command3 = Command(commandID: "LongBlink", shortCode: "LB", createdAt: Date())
        let command4 = Command(commandID: "LipDown", shortCode: "LD", createdAt: Date())
        let command5 = Command(commandID: "LipUp", shortCode: "LU", createdAt: Date())
        let command6 = Command(commandID: "EyeMove", shortCode: "EM", createdAt: Date())
        let command7 = Command(commandID: "EyeMove", shortCode: "Y", createdAt: Date())
        let command8 = Command(commandID: "Smile", shortCode: "SM", createdAt: Date())
        let command9 = Command(commandID: "EverythingMoved", shortCode: "DEL", createdAt: Date())
        
        return [command1, command2, command3, command4, command5, command6, command7, command8, command9]
    }
}
