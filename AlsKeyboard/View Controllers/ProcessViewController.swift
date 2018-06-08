//
//  ProcessViewController.swift
//  faceKeyboard
//
//  Created by Berker on 26.07.2017.
//  Copyright © 2017 dorianlabs. All rights reserved.
//

import Foundation
import UIKit

class ProcessViewController: KeyboardDelegate {
    let view: UIView
    let writeMessage: UILabel
    let message: UILabel
    
    init(view: UIView, writeMessage: UILabel, message: UILabel) {
        self.view = view
        self.writeMessage = writeMessage
        self.message = message
    }
    
    func displayTextUpdated(value: String) {
        DispatchQueue.main.async {
            self.message.text = "\(value)"
        }
    }
    
    func displayReceivedCommand(value: String) {
        DispatchQueue.main.async(){
            self.addLabelToView(value: value)
        }
    }
    
    func clearCommandBuffer() {
    }
    
    func deleteFirstCommandFromBuffer() {
    }
    
    func addLabelToView(value: String) {
        if self.writeMessage.text != nil {
            if self.writeMessage.text!.characters.count > 61 {
                self.writeMessage.text = ""
            } else {
                self.writeMessage.text = self.writeMessage.text! + "\(value)"
            }
        }
    }
}
