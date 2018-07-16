//
//  KeyboardMappingVC.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 16.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit

class KeyboardMappingVC: UIViewController {
    
}

extension KeyboardMappingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letterMapping = ALSEngine.shared().keyboardEngine.letterMapping
        return letterMapping.letterCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MappingCell", for: indexPath)
        
        let letterMapping = ALSEngine.shared().keyboardEngine.letterMapping
        let sortedLetters = letterMapping.sortedLetters
        let letter = sortedLetters[indexPath.row]
        let expressions = letterMapping.expressionsRequired(forLetter: letter)
        
        cell.textLabel?.text = letter
        cell.detailTextLabel?.text = expressions.expressionListDescription()
        
        return cell
    }
}
