//
//  DetectedExpressionView.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 17.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit

class DetectedExpressionView: UIView {
    
    var expressionLabel: UILabel!
    var descriptiveLabel: UILabel!
    var detectedMove: FacialMove?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.initializeLayer()
        self.createAndAddExpressionLabel()
        self.createAndAddDescriptiveLabel()
    }
    
    public func update(withDetectedMove move:FacialMove) {
        self.detectedMove = move
        self.expressionLabel.text = move.expression.coolDescription()
        self.descriptiveLabel.text = move.expression.shortDescription()
    }
    
    public func containsMove() -> Bool {
        return self.detectedMove != nil
    }
    
    public func moveConsumed() {
        self.detectedMove = nil
        
        UIView.animate(withDuration: 0.8, animations: {
            self.expressionLabel.center.y += 80
            self.descriptiveLabel.center.y += 80
        }) { (isCompleted) in
            UIView.animate(withDuration: 0.3, animations: {
                self.expressionLabel.center.y -= 80
                self.descriptiveLabel.center.y -= 80
            }) { (isCompleted) in
                self.expressionLabel.text = "-"
                self.descriptiveLabel.text = ""
            }
        }
    }
    
    private func initializeLayer() {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.0
    }
    
    private func createAndAddExpressionLabel() {
        
        self.expressionLabel = UILabel()
        self.expressionLabel.textAlignment = .center
        self.expressionLabel.text = "-"
        self.expressionLabel.font = self.expressionLabel.font.withSize(22)
        self.expressionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.expressionLabel)
        
        NSLayoutConstraint.activate(
            [self.expressionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             self.expressionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
             self.expressionLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
             self.expressionLabel.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
    }
    
    private func createAndAddDescriptiveLabel() {
        
        self.descriptiveLabel = UILabel()
        self.descriptiveLabel.textAlignment = .center
        self.descriptiveLabel.text = ""
        self.descriptiveLabel.font = self.descriptiveLabel.font.withSize(22)
        self.descriptiveLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.descriptiveLabel)
        
        NSLayoutConstraint.activate(
            [self.descriptiveLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             self.descriptiveLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 10)
            ])
    }
}
