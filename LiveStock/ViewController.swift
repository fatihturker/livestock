//
//  ViewController.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 31/05/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet
    var tableView: UITableView?
    var IsFirstLoad = true
    var hisseTableViewAdapter: HisseTableViewAdapter!
    var bildirimEkleModalViewAdapter: BildirimEkleModalViewAdapter!
    var hisseler: [Hisse]!
    @IBOutlet weak var navTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableview aşağı çekilince update ekle
        self.navTitleLabel.textColor = Colors.LightDeepOrange
        hisseler = [Hisse]()
        hisseTableViewAdapter = HisseTableViewAdapter()
        hisseTableViewAdapter.initTableView(self.tableView!, argDelegate: self, argDataSource: self)
        bildirimEkleModalViewAdapter = BildirimEkleModalViewAdapter()
        initActivityIndicator("Veriler yükleniyor..")
        startIndicator()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(refreshTheList),
            name: "valueUpdated",
            object: nil)
        let requestHelper = HttpRequestHelper()
        requestHelper.getRequest("http://tfwservice.com/BIST100Service/api/gethisseler")
    }
    
    func updateTableHeaderView(){
        if self.tableView?.numberOfRowsInSection(0) <= 0{
            let message = UILabel()
            message.frame = CGRectMake(10, 0, 300, 40)
            message.text = "Hisseler getirilirken hata oluştu. Listeyi aşağı kaydırarak yenileyebilirsiniz."
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
    
    func refreshTheList(){
        print("value updated")
        hisseler = Global.Hisseler
        IsFirstLoad = self.tableView?.numberOfRowsInSection(0) <= 0
        if !IsFirstLoad {
            //var indexPaths = [NSIndexPath]()
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView!.reloadData()
                for index in 0..<self.hisseler.count {
                    let hisse = self.hisseler[index]
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    let cell = self.tableView?.cellForRowAtIndexPath(indexPath)
                    if(hisse.OldFark != nil && hisse.Fark != hisse.OldFark){
                        self.tableView?.beginUpdates()
                        self.hisseTableViewAdapter.updateCellValue(hisse, argCell: cell)
                        self.tableView?.endUpdates()
                    }
                    if cell != nil {
                        if hisse.OldIndex != nil && hisse.OldIndex != index{
                            var changeBackground = Colors.LightGreen.colorWithAlphaComponent(0.8)
                            if(hisse.OldFark > hisse.Fark){
                                changeBackground = Colors.LightRed.colorWithAlphaComponent(0.8)
                            }
                            let currentBackground = cell?.backgroundColor
                            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                                cell?.backgroundColor = changeBackground
                                }, completion: { (finished: Bool) -> Void in
                                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                                        cell?.backgroundColor = currentBackground
                                        }, completion: { (finished: Bool) -> Void in
                                    })
                            })
                        }
                    }
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView!.reloadData()
                self.updateTableHeaderView()
                self.stopIndicator()
            });
        }
        
        //cell i yeniden oluşturmak yerine sadece data update yapmak lazım
    }
    
    var messageFrame = UIView()
    
    func initActivityIndicator(msg:String) {
        let strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = Colors.Grey
        strLabel.font = UIFont.boldSystemFontOfSize(13)
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 100, y: view.frame.midY - 25 , width: 200, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = Colors.LightGrey
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.startAnimating()
        messageFrame.addSubview(indicator)
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    func startIndicator(){
        makeReadOnlyAndBlurView(self.tableView!)
        makeReadOnly((self.tabBarController?.view)!)
        self.messageFrame.hidden = false
    }
    
    func stopIndicator(){
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), { ()->() in
            self.messageFrame.removeFromSuperview()
            self.makeEnabledAndOpaqueView(self.tableView!)
            self.makeEnabled((self.tabBarController?.view)!)
        })
    }
    
    func makeReadOnlyAndBlurView(argView: UIView){
        argView.alpha = 0.5
        makeReadOnly(argView)
    }
    
    func makeReadOnly(argView: UIView){
        argView.userInteractionEnabled = false
    }
    
    func makeEnabledAndOpaqueView(argView: UIView){
        argView.alpha = 1
        makeEnabled(argView)
    }
    
    func makeEnabled(argView: UIView){
        argView.userInteractionEnabled = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hisseler.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.cellForRowAtIndexPath(indexPath)
        
        //cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        if hisseler.count > 0 && hisseler.count > indexPath.row {
            let hisse = hisseler[indexPath.row]
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "hisseCell")
                self.hisseTableViewAdapter.fillCell(hisse, argCell: cell)
            }else{
                hisseTableViewAdapter.updateCellValue(hisse, argCell: cell)
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        //hacim falan tıklayınca gelecek, popupview çıkarılabilir
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let hisse = hisseler[indexPath.row]
        let hisseKodu = hisse.HisseKodu
        var actions = [UITableViewRowAction]()
        if !Global.PortfoyHisseKodlari.contains(hisseKodu){
            let portfoyumeEkle = BGTableViewRowActionWithImage.rowActionWithStyle(UITableViewRowActionStyle.Normal, title: "Portföyüme Ekle", backgroundColor: Colors.LightBlue, image: UIImage(named: "plus")!, forCellHeight: 45, andFittedWidth:true, handler: { (argRowAction, argIndexPath) in
                self.portfoyumeEkle(argRowAction, indexPath: argIndexPath)
            })
            actions.append(portfoyumeEkle)
        }
        
        let bildirimEkle = BGTableViewRowActionWithImage.rowActionWithStyle(UITableViewRowActionStyle.Normal, title: "Bildirim Ekle", backgroundColor: Colors.Orange, image: UIImage(named: "notify")!, forCellHeight: 45, andFittedWidth:true, handler: { (argRowAction, argIndexPath) in
            self.tableView?.beginUpdates()
            self.tableView?.reloadRowsAtIndexPaths([argIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView?.endUpdates()
            self.bildirimEkleModalViewAdapter.bildirimEkle(argRowAction, index: argIndexPath.row, argViewController: self)
            })
        actions.append(bildirimEkle)
        return actions
    }
    
    func portfoyumeEkle(rowAction: UITableViewRowAction, indexPath: NSIndexPath){
        let hisseKodu = hisseler[indexPath.row].HisseKodu
        if !Global.PortfoyHisseKodlari.contains(hisseKodu){
            Global.PortfoyHisseKodlari.append(hisseKodu)
            self.tableView?.beginUpdates()
            self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView?.endUpdates()
            let toast = JLToast.makeText(hisseKodu + " portföyünüze eklendi.", duration: JLToastDelay.ShortDelay)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

