//
//  BildirimEkleModalViewAdapter.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 19/06/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import Foundation
class BildirimEkleModalViewAdapter{
    
    func bildirimEkle(rowAction: UITableViewRowAction, index: Int, argViewController: UIViewController){
        showBildirimEkleModal(Global.Hisseler[index].HisseKodu, argViewController: argViewController)
    }
    
    func showBildirimEkleModal(argHisseKodu: String, argViewController: UIViewController) {
        argViewController.presentViewController(BildirimEkleModalViewController(argHisseKodu: argHisseKodu), animated: true, completion: nil)
    }
    
}