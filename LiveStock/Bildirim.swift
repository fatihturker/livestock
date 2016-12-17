//
//  Bildirim.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 08/06/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import Foundation
class Bildirim: NSObject, NSCoding{
    var HisseKodu: String = ""
    var HisseFiyati: Double = 0.0
    var TarihBaslangic: NSDate = NSDate()
    var TarihBitis: NSDate = NSDate()
    override init(){}
    init(argHisseFiyati: Double, argHisseKodu: String, argTarihBaslangic: NSDate, argTarihBitis: NSDate){
        self.HisseKodu = argHisseKodu
        self.HisseFiyati = argHisseFiyati
        self.TarihBaslangic = argTarihBaslangic
        self.TarihBitis = argTarihBitis
    }
    
    required convenience init(coder argDecoder: NSCoder) {
        let hisseFiyati = argDecoder.decodeDoubleForKey("HisseFiyati")
        let hisseKodu = argDecoder.decodeObjectForKey("HisseKodu") as! String
        let tarihBaslangic = argDecoder.decodeObjectForKey("TarihBaslangic") as! NSDate
        let tarihBitis = argDecoder.decodeObjectForKey("TarihBitis") as! NSDate
        self.init(argHisseFiyati: hisseFiyati, argHisseKodu: hisseKodu, argTarihBaslangic: tarihBaslangic, argTarihBitis: tarihBitis)
    }
    
    func encodeWithCoder(argCoder: NSCoder) {
        argCoder.encodeObject(HisseKodu, forKey: "HisseKodu")
        argCoder.encodeDouble(HisseFiyati, forKey: "HisseFiyati")
        argCoder.encodeObject(TarihBaslangic, forKey: "TarihBaslangic")
        argCoder.encodeObject(TarihBitis, forKey: "TarihBitis")
    }
}
func == (lhs: Bildirim, rhs: Bildirim) -> Bool {
    return lhs.HisseKodu == rhs.HisseKodu && lhs.HisseFiyati == rhs.HisseFiyati && lhs.TarihBitis.compare(rhs.TarihBitis) == NSComparisonResult.OrderedSame && lhs.TarihBaslangic.compare(rhs.TarihBaslangic) == NSComparisonResult.OrderedSame
}