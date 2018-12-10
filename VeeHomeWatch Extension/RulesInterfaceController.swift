//
//  RulesInterfaceController.swift
//  VeeHomeWatch Extension
//
//  Created by Débora Oliveira on 06/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class RulesInterfaceController: WKInterfaceController {

    @IBOutlet weak var rulesTable: WKInterfaceTable!
    
    var rules : [[String : String]]?
    
    var ruleSelected : [String : String]?
        
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        self.rules = context as! [[String : String]]?
        
        // Populate TableView
        rulesTable.setNumberOfRows(rules?.count ?? 0, withRowType: "RulesRow")
        
        //Complete TableRows data
        for index in 0..<rulesTable.numberOfRows {
            guard let controller = rulesTable.rowController(at: index) as? RulesRowController else { continue }
            controller.ruleName = rules?[index]["name"]
        }

    }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if (table.rowController(at: rowIndex) as? RulesRowController) != nil {
            
            self.ruleSelected = rules?[rowIndex]
            presentController(withName: "DetailsInterfaceController", context: ruleSelected)
        }
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
