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
        print("displayTextUpdated: \(value)")
    }
    
    func displayReceivedCommand(value: String) {
        DispatchQueue.main.async(){
            self.addLabelToView(value: value)
        }
    }
    
    func clearCommandBuffer() {
        print("clearCommandBuffer")
    }
    
    func deleteFirstCommandFromBuffer() {
        print("deleteFirstCommandFromBuffer")
    }
    
    func addLabelToView(value: String) {
        if "\(value)" == "DEL" {
            self.writeMessage.text = ""
        } else {
            self.writeMessage.text = self.writeMessage.text! + "\(value)"
        }
    }
}
