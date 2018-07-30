//
//  ViewController.swift
//  WatchKitSample
//
//  Created by msnr on 2018/07/15.
//  Copyright © 2018年 msnr. All rights reserved.
//

import UIKit
import WatchConnectivity


class ViewController: UIViewController, WCSessionDelegate {
    var session = WCSession.default
    private var countFromWatch: Int = 0

    @IBAction func countUp(_ sender: Any) {
        
        guard WCSession.isSupported() else {
            return
        }
        
        do{
            countFromWatch += 1
            self.countLabel.text = String(countFromWatch)
            try WCSession.default.updateApplicationContext(["WatchCountKey" : countFromWatch.description])
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
       
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext)
        if let count = applicationContext["WatchCountKey"],
             let countValue = Int(count as? String ?? "0") {
            countFromWatch = countValue
            DispatchQueue.main.async {
                self.countLabel.text = String(self.countFromWatch)
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    

    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if WCSession.isSupported() {   //<---
            self.session.delegate = self
            self.session.activate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

