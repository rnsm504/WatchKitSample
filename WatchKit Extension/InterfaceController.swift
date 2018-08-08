//
//  InterfaceController.swift
//  WatchKit Extension
//
//  Created by msnr on 2018/07/15.
//  Copyright © 2018年 msnr. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import UserNotifications

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    var session = WCSession.default

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext)
        if let countFromPhone = applicationContext["WatchCountKey"],
            let countValue = Int(countFromPhone as? String ?? "0") {
//            countFromWatch = countValue
            count = countValue
            DispatchQueue.main.async {
                self.counter.setText(countValue.description)
                
                let content = UNMutableNotificationContent()
                content.title = "countUp"
                content.body = countValue.description
                content.sound = UNNotificationSound.default()
                content.userInfo = ["customData": "fizzbuzz"]
                content.categoryIdentifier = "alarm"
                
                //let time = Date().timeIntervalSinceNow - 20.0
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: self.stringWithUUID(), content: content, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                
                center.removeAllPendingNotificationRequests()
                center.removeAllDeliveredNotifications()
                
                center.add(request)
            }
        }
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    private var count = 0

    @IBOutlet var counter: WKInterfaceLabel!
    
    @IBAction func countUp() {
        guard WCSession.isSupported() else {
            return
        }
        
        do{
            count += 1
            counter.setText(count.description)
            try WCSession.default.updateApplicationContext(["WatchCountKey" : count.description])
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {   //<---
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func stringWithUUID() -> String {
        let uuidObj = CFUUIDCreate(nil)
        let uuidString = CFUUIDCreateString(nil, uuidObj)!
        return uuidString as String
    }

}
