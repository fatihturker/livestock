//
//  Hisse.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 31/05/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import Foundation
class Hisse{
    var HisseKodu: String
    var HisseArtisIndex: Int?
    var Son: Double?
    var Alis: Double?
    var Satis: Double?
    var Fark: Double?
    var EnDusuk: Double?
    var EnYuksek: Double?
    var AgirlikliOrtalama: Double?
    var HacimLot: Double?
    var HacimTL: Double?
    var SonIslemTarihi: String?
    var OldIndex: Int?
    var OldFark: Double?
    init(argJsonData: NSDictionary) {
        self.HisseKodu = (argJsonData["k"] as? String)!
        self.HisseArtisIndex = (argJsonData["i"] as? Int)!
        self.Son = (argJsonData["s"] as? Double)!
        self.Alis = (argJsonData["a"] as? Double)!
        self.Satis = (argJsonData["p"] as? Double)!
        self.Fark = (argJsonData["f"] as? Double)!
        self.EnDusuk = (argJsonData["d"] as? Double)!
        self.EnYuksek = (argJsonData["y"] as? Double)!
        self.AgirlikliOrtalama = (argJsonData["o"] as? Double)!
        self.HacimLot = (argJsonData["l"] as? Double)!
        self.HacimTL = (argJsonData["h"] as? Double)!
        self.SonIslemTarihi = (argJsonData["t"] as? String)!
        self.OldIndex = nil
        self.OldFark = nil
    }
}