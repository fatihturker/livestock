//
//  BildirimlerViewController.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 19/06/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import UIKit

class BildirimlerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navTitleLabel: UILabel!
    var formatter: NSDateFormatter!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitleLabel.textColor = Colors.LightDeepOrange
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "bildirimCell")
        self.formatter = NSDateFormatter()
        self.formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        self.formatter.timeStyle = NSDateFormatterStyle.NoStyle
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(),{
            self.tableView!.reloadData()
            self.updateTableHeaderView()
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableHeaderView(){
        if Global.Bildirimler.count <= 0{
            let message = UILabel()
            message.frame = CGRectMake(10, 0, 300, 40)
            message.text = "Henüz bir bildirim eklenmemiş."
            message.lineBreakMode = .ByWordWrapping
            message.numberOfLines = 0
            message.textAlignment = .Center
            message.font = UIFont.boldSystemFontOfSize(11)
            let borderBottom = CALayer()
            borderBottom.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
            borderBottom.borderWidth = 0.5
            borderBottom.frame = CGRectMake(15, message.layer.frame.size.height, (self.tableView?.layer.frame.size.width)! + 10, 0.5)
            message.layer.addSublayer(borderBottom)
            self.tableView?.tableHeaderView = message
        }else{
            self.tableView?.tableHeaderView = nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.Bildirimler.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("bildirimCell")! as UITableViewCell
        
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        let bildirim = Global.Bildirimler[indexPath.row]
        
        let hisseKodu = UILabel()
        hisseKodu.frame = CGRectMake(10, 12.5, 70, 30)
        hisseKodu.text = bildirim.HisseKodu
        hisseKodu.font = UIFont.boldSystemFontOfSize(13)
        cell.contentView.addSubview(hisseKodu)
        
        let degerTitle = UILabel()
        degerTitle.frame = CGRectMake(100, 5, 50, 30)
        degerTitle.text = "Değer"
        degerTitle.font = UIFont.boldSystemFontOfSize(10)
        cell.contentView.addSubview(degerTitle)
        
        let tarihAraligiTitle = UILabel()
        tarihAraligiTitle.frame = CGRectMake(150, 5, 170, 30)
        tarihAraligiTitle.text = "Tarih Aralığı"
        tarihAraligiTitle.font = UIFont.boldSystemFontOfSize(10)
        cell.contentView.addSubview(tarihAraligiTitle)
        
        let deger = UILabel()
        deger.frame = CGRectMake(100, 20, 50, 30)
        deger.text = String(format:"%.2f", bildirim.HisseFiyati)
        deger.font = UIFont.boldSystemFontOfSize(10)
        cell.contentView.addSubview(deger)
        
        let tarihAraligi = UILabel()
        tarihAraligi.frame = CGRectMake(150, 20, 170, 30)
        tarihAraligi.text = self.formatter.stringFromDate(bildirim.TarihBaslangic) + " - " + self.formatter.stringFromDate(bildirim.TarihBitis)
        tarihAraligi.font = UIFont.boldSystemFontOfSize(10)
        cell.contentView.addSubview(tarihAraligi)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let bildirimiKaldir = BGTableViewRowActionWithImage.rowActionWithStyle(UITableViewRowActionStyle.Normal, title: "Bildirimi Kaldır", backgroundColor: Colors.LightRed, image: UIImage(named: "trash")!, forCellHeight: 45, andFittedWidth:true, handler: { (argRowAction, argIndexPath) in
            self.bildirimiSil(argRowAction, indexPath: argIndexPath)
        })

        return [bildirimiKaldir]
    }
    
    func bildirimiSil(rowAction: UITableViewRowAction, indexPath: NSIndexPath){
        let bildirim = Global.Bildirimler[indexPath.row]
        Global.Bildirimler.removeObject(bildirim)
        self.tableView?.beginUpdates()
        tableView!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView?.endUpdates()
        updateTableHeaderView()
        let toast = JLToast.makeText(bildirim.HisseKodu + " için oluşturduğunuz bildirim kaldırıldı.", duration: JLToastDelay.ShortDelay)
        toast.show()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
