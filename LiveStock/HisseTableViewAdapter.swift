//
//  HisseTableViewAdapter.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 11/06/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import Foundation
class HisseTableViewAdapter{
    
    func initTableView(argTableView: UITableView, argDelegate: UITableViewDelegate, argDataSource: UITableViewDataSource){
        argTableView.dataSource = argDataSource
        argTableView.delegate = argDelegate
        argTableView.estimatedRowHeight = 60.0
        argTableView.rowHeight = UITableViewAutomaticDimension
        argTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "hisseCell")
    }
    
    func checkIfCellLoaded(argCell: UITableViewCell?) -> Bool{
        let val = argCell?.contentView.subviews.filter({$0.tag == 1}).first as? UILabel
        return val != nil
    }
    
    func fillCell(argHisse: Hisse, argCell: UITableViewCell){
        //sizelar constantlardan gelecek cihaza göre
        let hisseKodu = UILabel()
        hisseKodu.frame = CGRectMake(10, 12.5, 70, 30)
        hisseKodu.text = argHisse.HisseKodu
        hisseKodu.font = UIFont.boldSystemFontOfSize(13)
        argCell.contentView.addSubview(hisseKodu)
        
        let sonTitle = UILabel()
        sonTitle.frame = CGRectMake(80, 5, 50, 30)
        sonTitle.text = "Son"
        sonTitle.font = UIFont.boldSystemFontOfSize(10)
        argCell.contentView.addSubview(sonTitle)
        
        let alisTitle = UILabel()
        alisTitle.frame = CGRectMake(130, 5, 60, 30)
        alisTitle.text = "Alış"
        alisTitle.font = UIFont.boldSystemFontOfSize(10)
        argCell.contentView.addSubview(alisTitle)
        
        let satisTitle = UILabel()
        satisTitle.frame = CGRectMake(180, 5, 50, 30)
        satisTitle.text = "Satış"
        satisTitle.font = UIFont.boldSystemFontOfSize(10)
        argCell.contentView.addSubview(satisTitle)
        
        let yuzdeTitle = UILabel()
        yuzdeTitle.frame = CGRectMake(230, 5, 50, 30)
        yuzdeTitle.text = "%"
        yuzdeTitle.font = UIFont.boldSystemFontOfSize(10)
        argCell.contentView.addSubview(yuzdeTitle)
        
        let son = UILabel()
        son.frame = CGRectMake(80, 20, 50, 30)
        son.tag = 1
        son.text = String(format:"%.2f", argHisse.Son!)
        son.font = UIFont.boldSystemFontOfSize(10)
        argCell.contentView.addSubview(son)
        
        let alis = UILabel()
        alis.frame = CGRectMake(130, 20, 50, 30)
        alis.tag = 2
        alis.text = String(format:"%.2f", argHisse.Alis!)
        alis.font = UIFont.boldSystemFontOfSize(10)
        argCell.contentView.addSubview(alis)
        
        let satis = UILabel()
        satis.frame = CGRectMake(180, 20, 50, 30)
        satis.tag = 3
        satis.text = String(format:"%.2f", argHisse.Satis!)
        satis.font = UIFont.boldSystemFontOfSize(10)
        argCell.contentView.addSubview(satis)
        
        let yuzde = UILabel()
        yuzde.frame = CGRectMake(230, 20, 50, 30)
        yuzde.tag = 4
        yuzde.text = String(format:"%.2f", argHisse.Fark!)
        yuzde.font = UIFont.boldSystemFontOfSize(10)
        argCell.contentView.addSubview(yuzde)
        
        let indexImage : UIImage
        if argHisse.HisseArtisIndex == 1 {
            indexImage = UIImage(named: "IndexUp")!
        }else if argHisse.HisseArtisIndex == -1 {
            indexImage = UIImage(named: "IndexDown")!
        }else{
            indexImage = UIImage(named: "IndexNotr")!
        }
        let stockIndex = UIImageView(image: indexImage)
        stockIndex.tag = 5
        stockIndex.frame = CGRectMake(280,20,10,10)
        dispatch_async(dispatch_get_main_queue(),{
            argCell.contentView.addSubview(stockIndex)
        });
    }
    
    func updateCellValue(argHisse: Hisse, argCell: UITableViewCell?){
        let son = argCell?.contentView.subviews.filter({$0.tag == 1}).first as? UILabel
        son?.text = String(format:"%.2f", argHisse.Son!)
        
        let alis = argCell?.contentView.subviews.filter({$0.tag == 2}).first as? UILabel
        alis?.text = String(format:"%.2f", argHisse.Alis!)
        
        let satis = argCell?.contentView.subviews.filter({$0.tag == 3}).first as? UILabel
        satis?.text = String(format:"%.2f", argHisse.Satis!)
        
        let yuzde = argCell?.contentView.subviews.filter({$0.tag == 4}).first as? UILabel
        yuzde?.text = String(format:"%.2f", argHisse.Fark!)
        
        let indexImage : UIImage
        if argHisse.HisseArtisIndex == 1 {
            indexImage = UIImage(named: "IndexUp")!
        }else if argHisse.HisseArtisIndex == -1 {
            indexImage = UIImage(named: "IndexDown")!
        }else{
            indexImage = UIImage(named: "IndexNotr")!
        }
        let stockIndex = argCell?.contentView.subviews.filter({$0.tag == 2}).first as? UIImageView
        dispatch_async(dispatch_get_main_queue(),{
            stockIndex?.image = indexImage
        });
    }
}