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
    let imageView: UIView
    var labelX = 100
    
    init(imageView: UIView) {
        self.imageView = imageView
    }
    
    func displayTextUpdated(value: String) {
        print("displayTextUpdated: \(value)")
    }
    
    func displayReceivedCommand(value: String) {
        self.addLabelToView(value: value)
    }
    
    func clearCommandBuffer() {
        print("clearCommandBuffer")
    }
    
    func deleteFirstCommandFromBuffer() {
        print("deleteFirstCommandFromBuffer")
    }
    
    func addLabelToView(value: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: labelX, y: 100)
        label.textColor = UIColor.red
        label.textAlignment = .center
        label.text = "\(value)"
        self.imageView.addSubview(label)
        labelX = labelX + 50
    }
}
