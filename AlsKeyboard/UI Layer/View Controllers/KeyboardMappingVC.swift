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
        let allKeys = Array(ALSEngine.shared().keyboardEngine.commandMapping.keys)
        return allKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MappingCell", for: indexPath)
        
        var allKeys = Array(ALSEngine.shared().keyboardEngine.commandMapping.keys)
        let currentKey = allKeys[indexPath.row]
        let currentValue = ALSEngine.shared().keyboardEngine.commandMapping[currentKey]
        
        cell.textLabel?.text = currentKey.expressionListDescription()
        cell.detailTextLabel?.text = currentValue
        
        return cell
    }
}
