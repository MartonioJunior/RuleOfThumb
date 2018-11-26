//
//  NotificationManager.swift
//  RuleOfThumb
//
//  Created by Matheus Costa on 23/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject {
    
    private var notificationCenter = UNUserNotificationCenter.current()
    
    /// Requests authorization for notifications
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        center.requestAuthorization(options: options) { (granted, error) in
            print("granted: \(granted)")
        }
    }
    
}
