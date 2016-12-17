//
//  PortfoyumViewController.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 11/06/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import UIKit

class PortfoyumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    var hisseTableViewAdapter: HisseTableViewAdapter!
    var bildirimEkleModalViewAdapter: BildirimEkleModalViewAdapter!
    
    @IBOutlet weak var navTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitleLabel.textColor = Colors.LightDeepOrange
        hisseTableViewAdapter = HisseTableViewAdapter()
        hisseTableViewAdapter.initTableView(self.tableView!, argDelegate: self, argDataSource: self)
        bildirimEkleModalViewAdapter = BildirimEkleModalViewAdapter()
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
        if self.tableView?.numberOfRowsInSection(0) <= 0{
            var msgstr = "Portföyünüze henüz bir hisse eklenmemiş."
            if Global.PortfoyHisseKodlari.count > 0 && Global.Hisseler.count <= 0 {
                msgstr = "Portfoyünüzdeki hisseler getirilirken hata oluştu. Listeyi aşağı kaydırarak yenileyebilirsiniz."
            }
            let message = UILabel()
            message.frame = CGRectMake(10, 0, 300, 40)
            message.text = msgstr
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if Global.Hisseler.count > 0 {
            count = Global.PortfoyHisseKodlari.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("hisseCell")! as UITableViewCell
        
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        let hisse = Global.Hisseler.filter({$0.HisseKodu == Global.PortfoyHisseKodlari[indexPath.row] }).first
        if hisse != nil {
            hisseTableViewAdapter.fillCell(hisse!, argCell: cell)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let portfoyumdenKaldir = BGTableViewRowActionWithImage.rowActionWithStyle(UITableViewRowActionStyle.Normal, title: "Portföyümden Çıkar", backgroundColor: Colors.LightRed, image: UIImage(named: "trash")!, forCellHeight: 45, andFittedWidth:true, handler: { (argRowAction, argIndexPath) in
            self.portfoyumdenKaldir(argRowAction, indexPath: argIndexPath)
        })
        let bildirimEkle = BGTableViewRowActionWithImage.rowActionWithStyle(UITableViewRowActionStyle.Normal, title: "Bildirim Ekle", backgroundColor: Colors.Orange, image: UIImage(named: "notify")!, forCellHeight: 45, andFittedWidth:true, handler: { (argRowAction, argIndexPath) in
            self.tableView?.beginUpdates()
            self.tableView?.reloadRowsAtIndexPaths([argIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView?.endUpdates()
            let hisseIndex = Global.Hisseler.indexOf({$0.HisseKodu == Global.PortfoyHisseKodlari[argIndexPath.row]})
            self.bildirimEkleModalViewAdapter.bildirimEkle(argRowAction, index: hisseIndex!, argViewController: self)
        })
        return [portfoyumdenKaldir, bildirimEkle]
    }
    
    func portfoyumdenKaldir(rowAction: UITableViewRowAction, indexPath: NSIndexPath){
        let hisse = Global.Hisseler.filter({$0.HisseKodu == Global.PortfoyHisseKodlari[indexPath.row] }).first
        let hisseKodu = (hisse?.HisseKodu)!
        if Global.PortfoyHisseKodlari.contains(hisseKodu){
            Global.PortfoyHisseKodlari.removeObject(hisseKodu)
            self.tableView?.beginUpdates()
            tableView!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView?.endUpdates()
            updateTableHeaderView()
            let toast = JLToast.makeText(hisseKodu + " portföyünüzden çıkarıldı.", duration: JLToastDelay.ShortDelay)
            toast.show()
        }
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
