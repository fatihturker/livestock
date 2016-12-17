//
//  BildirimEkleModalViewController.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 14/06/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import UIKit

class BildirimEkleModalViewController: UIViewController, UITextFieldDelegate {
    var transitioner : CAVTransitioner

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var hisseKoduLabel: UILabel!
    @IBOutlet weak var degerTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    var formatter: NSDateFormatter
    var hisseKodu: String
    
    @IBOutlet weak var endDateTitleLabel: UILabel!
    @IBOutlet weak var startDateTitleLabel: UILabel!
    @IBOutlet weak var degerTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        hisseKoduLabel?.text = self.hisseKodu
        self.view.backgroundColor = Colors.LightGrey
        self.saveButton.backgroundColor = Colors.LightBlue
        self.exitButton.backgroundColor = Colors.LightRed
        self.saveButton.setTitleColor(Colors.White, forState: UIControlState.Normal)
        self.exitButton.setTitleColor(Colors.White, forState: UIControlState.Normal)
        self.hisseKoduLabel.textColor = Colors.Grey
        self.degerTextField.textColor = Colors.Grey
        self.startDateTextField.textColor = Colors.Grey
        self.endDateTextField.textColor = Colors.Grey
        self.degerTitleLabel.textColor = Colors.Grey
        self.startDateTitleLabel.textColor = Colors.Grey
        self.endDateTitleLabel.textColor = Colors.Grey
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.formatter = NSDateFormatter()
        self.formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        self.formatter.timeStyle = NSDateFormatterStyle.NoStyle
        hisseKodu = ""
        self.transitioner = CAVTransitioner()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self.transitioner
    }
    
    convenience init(argHisseKodu: String) {
        self.init(nibName:"BildirimEkleModalView", bundle:nil)
        self.hisseKodu = argHisseKodu
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    @IBAction func doDismiss(sender:AnyObject?) {
        dismissController()
    }
    
    @IBAction func save(sender:AnyObject?) {
        let errorMessage = checkFields()
        if errorMessage.characters.count > 0 {
            let alertController = UIAlertController(title: "Kaydetme İşlemi Yapılamıyor", message:
                errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        saveBildirim()
        dismissController()
    }
    
    func saveBildirim(){
        let bildirim = Bildirim()
        bildirim.HisseFiyati = Double(degerTextField.text!)!
        bildirim.HisseKodu = hisseKoduLabel.text!
        bildirim.TarihBaslangic = self.formatter.dateFromString(startDateTextField.text!)!
        bildirim.TarihBitis = self.formatter.dateFromString(endDateTextField.text!)!
        if !Global.Bildirimler.contains(bildirim){
            Global.Bildirimler.append(bildirim)
        }
    }
    
    func checkFields() -> String{
        var errorMessage: String = ""
        if degerTextField.text?.characters.count <= 0{
            errorMessage += "Lütfen bir değer giriniz!"
        }
        if startDateTextField.text?.characters.count <= 0{
            errorMessage += getNewLineIfNeeded(errorMessage) + "Lütfen bir başlangıç tarihi giriniz!"
        }
        if endDateTextField.text?.characters.count <= 0{
            errorMessage += getNewLineIfNeeded(errorMessage) + "Lütfen bir bitiş tarihi giriniz!"
        }
        if startDateTextField.text?.characters.count > 0 && endDateTextField.text?.characters.count > 0
            && self.formatter.dateFromString(endDateTextField.text!)?.compare(self.formatter.dateFromString(startDateTextField.text!)!) == NSComparisonResult.OrderedAscending{
            errorMessage += getNewLineIfNeeded(errorMessage) + "Başlangıç tarihi bitiş tarihinden büyük olamaz!"
        }
        return errorMessage
    }
    
    func getNewLineIfNeeded(argErrorMessage: String) -> String{
        var newLine = ""
        if argErrorMessage != "" {
            newLine = "\n"
        }
        return newLine
    }
    
    func dismissController(){
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func startDateEditing(sender: UITextField) {
        textFieldEditing(sender, selector: #selector(startDatePickerValueChanged), dateText: startDateTextField.text!)
    }
    
    @IBAction func endDateEditing(sender: UITextField) {
        textFieldEditing(sender, selector: #selector(endDatePickerValueChanged), dateText: endDateTextField.text!)
    }
    
    func textFieldEditing(sender: UITextField, selector: Selector, dateText: String) {
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        var selectedDate = NSDate()
        if dateText.characters.count > 0
        {
            selectedDate = self.formatter.dateFromString(dateText)!
        }
        datePickerView.minimumDate = NSDate()
        datePickerView.setDate(selectedDate, animated: true)
        inputView.addSubview(datePickerView)
        
        let doneButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width, 40))
        doneButton.titleLabel?.textAlignment = NSTextAlignment.Center
        doneButton.setTitle("Bitti", forState: UIControlState.Normal)
        doneButton.setTitle("Bitti", forState: UIControlState.Highlighted)
        doneButton.backgroundColor = Colors.LightBlue
        doneButton.setTitleColor(Colors.White, forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        doneButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        inputView.addSubview(doneButton)
        doneButton.HandeledTextField = sender
        doneButton.HandeledDatePicker = datePickerView
        doneButton.addTarget(self, action: #selector(doneButtonEvent), forControlEvents: UIControlEvents.TouchUpInside)
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: selector, forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func doneButtonEvent(sender:UIButton)
    {
        datePickerValueChanged(sender.HandeledDatePicker, dateTextField: sender.HandeledTextField)
        sender.HandeledTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func startDatePickerValueChanged(sender:UIDatePicker) {
        datePickerValueChanged(sender, dateTextField: startDateTextField)
    }
    
    func endDatePickerValueChanged(sender:UIDatePicker) {
        datePickerValueChanged(sender, dateTextField: endDateTextField)
    }
    func datePickerValueChanged(sender:UIDatePicker, dateTextField: UITextField) {
        dateTextField.text = self.formatter.stringFromDate(sender.date)
    }
}
