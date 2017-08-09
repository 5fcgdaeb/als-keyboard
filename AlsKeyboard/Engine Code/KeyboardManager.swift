//
//  KeyboardManager.swift
//  ExpressionRecognition
//
//  Created by MacbookPro on 7.04.2017.
//
//

import Foundation
import UIKit

class KeyboardManager: NSObject {
    
    var delegate: KeyboardDelegate?
    var bufferedCommands: [Command]
    var currentText: String
    var commandMapping: [String: String]
    var shouldItType = false
    
    init(withDelegate: KeyboardDelegate) {
        self.delegate = withDelegate
        self.commandMapping = [
            "ERERSM": "C",
            "SMERSM": "U",
            "BBERER": "J",
            "ERBBER": "D",
            "BBBBER": "M",
            "ERSMER": "G",
            "ERERBB": "B",
            "SMBBSM": "X",
            "ERBBBB": "E",
            "SMSMER": "Y",
            "BBBBBB": "N",
            "ERBBSM": "F",
            "SMBBER": "V",
            "BBSMER": "P",
            "ERERER": "Z",
            "SMERBB": "T",
            "ERSMBB": "H",
            "BBERSM": "L",
            "SMSMSM": "Q",
            "SMERER": "S",
            "ERSMSM": "I",
            "BBSMSM": "R",
            "BBSMBB": "1",
            "SMBBBB": "2",
            "SMSMBB": "A",
            "BBBBSM": "O",
            "BBERBB": "K"
        ]
        
        self.bufferedCommands = []
        self.currentText = ""
    }
    
    func startTyping() {
        self.shouldItType = true
    }
    
    func resetState() {
        self.bufferedCommands.removeAll()
        self.currentText = ""
        self.delegate?.displayTextUpdated(value: self.currentText)
        self.delegate?.clearCommandBuffer()
    }
    
    func process(command: Command) {
        let areThereAnyBufferedCommands = self.bufferedCommands.count > 0
        
        if areThereAnyBufferedCommands {
            let previousCommand = self.bufferedCommands[self.bufferedCommands.count - 1]
            let timeDifferenceInSeconds = Double(command.createdAt.timeIntervalSince(previousCommand.createdAt))
            if timeDifferenceInSeconds < MINIMUM_TIME_REQUIREMENT_BETWEEN_INPUTS {
                return
            }
        }
        
        self.bufferedCommands.append(command)
        self.delegate?.displayReceivedCommand(value: command.shortCode)
        
        if self.shouldItType {
            self.analyzeCommandToGenerateText()
        }
    }
    
    private func analyzeCommandToGenerateText() {
        let length = self.bufferedCommands.count
        
        if length < 3 {
            return
        } else {
            let command1 = self.bufferedCommands[length - 3]
            let command2 = self.bufferedCommands[length - 2]
            let command3 = self.bufferedCommands[length - 1]
            
            let mappingKeyString = "\(command1.shortCode)\(command2.shortCode)\(command3.shortCode)"
            
            if let mappingValue = self.commandMapping[mappingKeyString] {
                self.currentText = self.currentText + mappingValue
                self.bufferedCommands.removeAll()
                self.delegate?.displayTextUpdated(value: self.currentText)
                self.delegate?.displayReceivedCommand(value: " ")
            } else {
                self.bufferedCommands.removeFirst()
                self.delegate?.displayTextUpdated(value: self.currentText)
                self.delegate?.deleteFirstCommandFromBuffer()
            }
        }
    }
}
