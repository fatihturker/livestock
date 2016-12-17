//
//  HttpRequestHelper.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 31/05/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import Foundation
class HttpRequestHelper{
    func getRequest(argUrlAddress: String) {
        //timeout ekle
        let url = NSURL(string: argUrlAddress)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(argData, argResponse, argError) in
            if argError != nil {
                if argError?.code ==  NSURLErrorTimedOut {
                    print("Time Out")
                    //Call your method here.
                }
            } else {
                print("NO ERROR")
            }
            let oldHisseler = Global.Hisseler
            //print(NSString(data: argData!, encoding: NSUTF8StringEncoding))
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(argData!, options: .AllowFragments)
                if let hisseler = json as? [AnyObject] {
                    var hisseListesi = [Hisse]()
                    for hisse in hisseler {
                        hisseListesi.append(Hisse(argJsonData: hisse as! NSDictionary))
                    }
                    hisseListesi.sortInPlace({ $0.Fark > $1.Fark })
                    Global.Hisseler = []
                    var index = 0
                    for hisse in hisseListesi {
                        var oldHisseIndex = oldHisseler.indexOf({$0.HisseKodu == hisse.HisseKodu && $0.Fark != hisse.Fark})
                        var oldFark = hisse.Fark
                        let oldHisse = oldHisseler.filter({$0.HisseKodu == hisse.HisseKodu}).first
                        if oldHisse != nil {
                            oldFark = oldHisse?.Fark
                        }
                        if oldHisseIndex == nil {
                            oldHisseIndex = index
                        }
                        hisse.OldIndex = oldHisseIndex
                        hisse.OldFark = oldFark
                        Global.Hisseler.append(hisse)
                        index += 1
                    }
                    let valueUpdatedNotification = NSNotification(name: "valueUpdated", object: nil)
                    NSNotificationCenter.defaultCenter().postNotification(valueUpdatedNotification)
                    //print(Global.Hisseler)
                }
            } catch {
                print("error serializing JSON")
                if Global.Hisseler.count != 0 {
                    Global.Hisseler = oldHisseler
                }
                let valueUpdatedNotification = NSNotification(name: "valueUpdated", object: nil)
                NSNotificationCenter.defaultCenter().postNotification(valueUpdatedNotification)
            }
        }
        task.resume()
    }
}
