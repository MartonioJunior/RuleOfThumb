//
//  InterfaceController.swift
//  VeeHomeWatch Extension
//
//  Created by Débora Oliveira on 09/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    var rules : [[String : String]]?
    
    var lastMessage = 0.0

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        sendiOSMessage()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    @IBAction func seeRulesAction() {
        presentController(withName: "RuleInterfaceController", context: rules)
    }
}

extension InterfaceController : WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        self.rules = message["message"] as! [[String:String]]
    }
    
    func sendiOSMessage() {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        // if less than half a second has passed, bail out
        if lastMessage + 0.5 > currentTime {
            return
        }
        
        // send a message to the watch if it's reachable
        if (WCSession.default.isReachable) {
            // this is a meaningless message, but it's enough for our purposes
            let message = ["message": "get_allRules"]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        
        // update our rate limiting property
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
}
