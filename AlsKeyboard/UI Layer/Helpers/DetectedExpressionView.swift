//
//  DetectedExpressionView.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 17.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit

@IBDesignable class DetectedExpressionView: UIView {
    
    @IBInspectable var order: UInt = 0
    
    var expressionLabel: UILabel!
    var descriptiveLabel: UILabel!
    var topLabel: UILabel!
    
    private var detectedMove: FacialMove?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.initializeLayer()
        self.createAndAddTopLabel()
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
        
        var xCoordinateMoveAmount: CGFloat = 0
        if self.order == 1 {
            xCoordinateMoveAmount = 20
        }
        else {
            xCoordinateMoveAmount = -20
        }
        
        UIView.animate(withDuration: 0.8, animations: {
            self.expressionLabel.center.y += 80
            self.expressionLabel.center.x += xCoordinateMoveAmount
            self.expressionLabel.alpha = 0
            
            self.descriptiveLabel.center.y += 80
            self.descriptiveLabel.center.x += xCoordinateMoveAmount
            self.descriptiveLabel.alpha = 0
        }) { (isCompleted) in
            self.expressionLabel.center.y -= 80
            self.expressionLabel.center.x -= xCoordinateMoveAmount
            self.expressionLabel.alpha = 1
            
            self.descriptiveLabel.center.y -= 80
            self.descriptiveLabel.center.x -= xCoordinateMoveAmount
            self.descriptiveLabel.alpha = 1
            
            self.expressionLabel.text = ""
            self.descriptiveLabel.text = ""
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
        self.expressionLabel.text = ""
        self.expressionLabel.font = UIFont(name: "AvenirNext-Regular", size: 30)!
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
        self.descriptiveLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)!
        self.descriptiveLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.descriptiveLabel)
        
        NSLayoutConstraint.activate(
            [self.descriptiveLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             self.descriptiveLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 10)
            ])
    }
    
    private func createAndAddTopLabel() {
        
        self.topLabel = UILabel()
        self.topLabel.textAlignment = .center
        if self.order == 1 {
            self.topLabel.text = "First Move"
        }
        else {
            self.topLabel.text = "Second Move"
        }
        self.topLabel.font = UIFont(name: "AvenirNext-Regular", size: 24)!
        self.topLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.topLabel)
        
        NSLayoutConstraint.activate(
            [self.topLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             self.topLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -10)
            ])
    }
}
