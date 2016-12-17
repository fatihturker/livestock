//
//  AppDelegate.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 31/05/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let bildirimler  = userDefaults.objectForKey("Bildirimler"){
            Global.Bildirimler = NSKeyedUnarchiver.unarchiveObjectWithData(bildirimler as! NSData) as! [Bildirim]
        }
        
        if let portfoyHisseKodlari  = userDefaults.objectForKey("PortfoyHisseKodlari"){
            Global.PortfoyHisseKodlari = NSKeyedUnarchiver.unarchiveObjectWithData(portfoyHisseKodlari as! NSData) as! [String]
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(scheduleTimer),
                                                         name: "valueUpdated",
                                                         object: nil)
        return true
    }
    
    func scheduleTimer(){
        dispatch_async(dispatch_get_main_queue(),{
            NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(self.updateData), userInfo: nil, repeats: false)
        });
    }
    
    func updateData(){
        let requestHelper = HttpRequestHelper()
        requestHelper.getRequest("http://tfwservice.com/BIST100Service/api/gethisseler")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var encodedData = NSKeyedArchiver.archivedDataWithRootObject(Global.Bildirimler)
        userDefaults.setObject(encodedData, forKey: "Bildirimler")
        encodedData = NSKeyedArchiver.archivedDataWithRootObject(Global.PortfoyHisseKodlari)
        userDefaults.setObject(encodedData, forKey: "PortfoyHisseKodlari")
        userDefaults.synchronize()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

