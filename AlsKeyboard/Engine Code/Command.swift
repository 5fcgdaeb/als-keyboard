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
        
        return [command1, command2, command3, command4, command5, command6, command7, command8]
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

