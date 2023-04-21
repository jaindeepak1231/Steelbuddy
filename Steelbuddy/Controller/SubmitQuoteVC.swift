//
//  SubmitQuoteVC.swift
//  Steelbuddy
//
//  Created by deepak jain on 15/10/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class SubmitQuoteVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, ServerCallDelegate {
    
    var strCheck = ""
    var strCurrentDateTimeString = ""
    var strCompleted = ""
    var selecIndex = 0
    var selectedIndex = IndexPath()
    var arrForSelected = [String]()
    var arrForLoading = [String]()
    var strSelectedPicker = ""
    var toolBar = UIToolbar()
    var pickerView: UIPickerView = UIPickerView()
    var arrPickerData = [String]()
    var btnCancel = UIButton()
    var btnDone = UIButton()
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    var arrSendQuoteData = NSMutableArray()
    var arrSendDataForAPI = NSMutableArray()
    
    @IBOutlet var constraint_bottom_tbl_View: NSLayoutConstraint!
    var seconds = 4
    var timer = Timer()
    var viewForSubmit = ViewSubmitInquiry()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        strCurrentDateTimeString = _userDefault.integer(forKey: "user_id").description + Constant.currentTimeString()

        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        //=========================================================================//
        arrForSelected.removeAll()
        arrForLoading.removeAll()
        arrPickerData = ["Against Delivery", "7 Days", "15 Days", "1 Month"]
        //=======================================================================================//
        //Set Picker
        pickerView.delegate  = self
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor.black
        toolBar.barStyle = UIBarStyle.default
        toolBar.barTintColor = Constant.themeColor()
        
        btnCancel = UIButton(type: .custom)
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(60), height: CGFloat(25))
        btnCancel.addTarget(self, action: #selector(self.cancelPressed), for: .touchUpInside)
        let cancelButton = UIBarButtonItem(customView: btnCancel)
        
        btnDone = UIButton(type: .custom)
        btnDone.setTitle("Done", for: .normal)
        btnDone.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(60), height: CGFloat(25))
        btnDone.addTarget(self, action: #selector(self.donePressed), for: .touchUpInside)
        let doneButton = UIBarButtonItem(customView: btnDone)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        //=========================================================================================//
        
        //=========================================================//
        //Table Cell Register
        tblView.register(UINib(nibName: "SubmitQuoteTableCell", bundle: nil), forCellReuseIdentifier: "SubmitQuoteTableCell")
        
        tblView.estimatedRowHeight = 420.0
        tblView.rowHeight = UITableViewAutomaticDimension
        //============================================================================================//
        
        //
        self.SetArrayForWebService()
        print(arrSendQuoteData)
        tblView.reloadData()
    }
    
    //========================================================================================//
    //========================================================================================//
    //========================================================================================//
    
    func viewForSubmitInquiry() {
        app_Delegate.stopLoadingView()
        viewForSubmit = (Bundle.main.loadNibNamed("ViewSubmitInquiry", owner: self, options: nil)?.first as? ViewSubmitInquiry)!
        
        viewForSubmit.frame = CGRect(x: CGFloat(0), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        viewForSubmit.lblSubmitQuotation.text = "SUBMIT YOUR QUOTATION"
        
        seconds = 4
        runTimer()
        
        self.view.addSubview(viewForSubmit)
        self.view.bringSubview(toFront: viewForSubmit)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        seconds -= 1
        viewForSubmit.lblTimer.text = String(seconds)
        if seconds == 0 {
            timer.invalidate()
            app_Delegate.stopLoadingView()
            viewForSubmit.removeFromSuperview()
            let home = self.storyboard?.instantiateViewController(withIdentifier: "InqueryOptionsVC") as! InqueryOptionsVC
            self.navigationController?.pushViewController(home, animated: true)
        }
        
    }
    //========================================================================================//
    //========================================================================================//
    //========================================================================================//
    
    func SetArrayForWebService() {
        arrSendDataForAPI.removeAllObjects()
        for i in 0..<arrSendQuoteData.count {
            var dict: NSDictionary = [:]
            dict = arrSendQuoteData.object(at: i) as! NSDictionary
            
            let param = ["iSUserId"   : _userDefault.integer(forKey: "user_id"),
                         "iInquiryId" : TO_INT(dict["iInquiryId"]),
                         "vQty"       : "true",
                         "vSize"      : "true",
                         "vGrade"     : "true",
                         "vMake"      : "true",
                         "vState"     : "true",
                         "vCity"      : "true",
                         "vGst"       : "Gst",
                         "vPrice"     : "",
                         "vDelivery"  : "For",
                         "vLoading"   : "null",
                         "vPayments"  : "Against Delivery",
                         "vQuotId"    : strCurrentDateTimeString] as [String : Any]
            arrSendDataForAPI.add(param)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    // MARK: - Send Quatation Api Call Method
    func apiCallForSendQuatationFromApp(param: [String : Any]) {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetAddQuatation
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameAddQuatation)
    }
    
    
    
    
  
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameAddQuatation {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    if strCompleted == "First" {
                        strCompleted = "resonSexomd"
                        Timer.scheduledTimer(timeInterval: 0.4, target: self,   selector: (#selector(self.viewForSubmitInquiry)), userInfo: nil, repeats: false)
                    }
                }
                else {
                    Constant.showAlert(title: "Steelbuddy", message: strMsg)
                    return
                }
            }
            else {
                let strerrMsg = TO_STRING(dicData["error"])
                Constant.showAlert(title: "", message:strerrMsg)
            }
        }
        app_Delegate.stopLoadingView()
    }
    
    
    // MARK: - Server Failed Delegate
    func ServerCallFailed(_ errorObject: String, name: ServerCallName) {
        app_Delegate.stopLoadingView()
        Constant.showAlert(title: "", message:errorObject)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //=====================================================================================//
    // MARK: - PickerView Delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return arrPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        strSelectedPicker = arrPickerData[row]
    }
    
    
    //=====================================================================================//
    
    
    
    
    //=====================================================================================//
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrSendQuoteData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitQuoteTableCell", for: indexPath as IndexPath) as! SubmitQuoteTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero

        let indecheck = indexPath.row + 1
        if indecheck == arrSendQuoteData.count {
            cell.btnSubmit.isHidden = false
            cell.constraint_btn_height.constant = 40
        }
        else {
            cell.btnSubmit.isHidden = true
            cell.constraint_btn_height.constant = 0
        }
        
        var dict: NSDictionary = [:]
        dict = arrSendQuoteData.object(at: indexPath.row) as! NSDictionary
        
        var Pricedict: NSDictionary = [:]
        Pricedict = arrSendDataForAPI.object(at: indexPath.row) as! NSDictionary
        cell.txtPayments.text = TO_STRING(Pricedict["vPayments"])
        cell.txtPrice.text = TO_STRING(Pricedict["vPrice"])
        
            
        let strMain = TO_STRING(dict["vMainName"])
        let strSub = TO_STRING(dict["vSubName"])
        cell.lblTitle.text = strSub + "-" + strMain
        
        cell.lblQuentity.text = TO_STRING(dict["vQty"])
        cell.lblSize.text = TO_STRING(dict["vSize"])
        cell.lblGrade.text = TO_STRING(dict["vGrade"])
        cell.lblMake.text = TO_STRING(dict["vMake"])
        cell.lblState.text = TO_STRING(dict["vState"])
        cell.lblCity.text = TO_STRING(dict["vCity"])
        //cell.lblGST.text = TO_STRING(dict["vgst"])

        cell.btnExtra.isSelected = true
        cell.btnInclude.isSelected = false
        cell.btnEx.isSelected = false
        cell.btnFor.isSelected = true
        cell.viewLoading.isHidden = true
        cell.constraint_view_height.constant = 0
        
        let strINQ_ID = TO_STRING(dict["iInquiryId"])
        if arrForSelected.contains(strINQ_ID) {
            cell.btnEx.isSelected = true
            cell.btnFor.isSelected = false
            cell.viewLoading.isHidden = false
            cell.constraint_view_height.constant = 50
        }
        if arrForLoading.contains(strINQ_ID) {
            cell.btnExtra.isSelected = false
            cell.btnInclude.isSelected = true
        }
        
        cell.txtPrice.delegate = self
        cell.txtPayments.delegate = self
        cell.txtPayments.tag = indexPath.row
        cell.txtPayments.addTarget(self, action: #selector(self.txtPaymentClickSet), for: .editingDidBegin)
        
        cell.txtPrice.tag = indexPath.row
        cell.txtPrice.addTarget(self, action: #selector(self.txtPriceKeyboardChane), for: .editingDidBegin)
        
        cell.txtPrice.tag = indexPath.row
        cell.txtPrice.addTarget(self, action: #selector(self.txtPriceSet), for: .editingChanged)
        
        //Button Click
        cell.btnEx.tag = indexPath.row
        cell.btnEx.addTarget(self, action: #selector(self.clkToButtonExTaped), for: .touchUpInside)
        
        cell.btnFor.tag = indexPath.row
        cell.btnFor.addTarget(self, action: #selector(self.clkToButtonForTaped), for: .touchUpInside)
        
        cell.btnExtra.tag = indexPath.row
        cell.btnExtra.addTarget(self, action: #selector(self.clkToButtonExtraTaped), for: .touchUpInside)
        
        cell.btnInclude.tag = indexPath.row
        cell.btnInclude.addTarget(self, action: #selector(self.clkToButtonIncludeTaped), for: .touchUpInside)
        
        cell.btnSubmit.tag = indexPath.row
        cell.btnSubmit.addTarget(self, action: #selector(self.clkToButtonSubmitQuoteTaped), for: .touchUpInside)
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func txtPaymentClickSet(_ sender: UITextField) {
        let btnAdd = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        selectedIndex = tblView.indexPathForRow(at: btnAdd)!
        selecIndex = selectedIndex.row
        strSelectedPicker = arrPickerData[0]
        strCheck = "Picker"
        btnCancel.isHidden = false
        sender.inputAccessoryView = toolBar
        sender.inputView = pickerView
        //pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.reloadAllComponents()
        sender.becomeFirstResponder()
        toolBar.barTintColor = Constant.themeColor()
        constraint_bottom_tbl_View.constant = 235
        btnDone.setTitleColor(UIColor.white, for: .normal)
    }
    
    func txtPriceKeyboardChane(_ sender: UITextField) {
        strCheck = "Number"
        btnCancel.isHidden = true
        sender.inputAccessoryView = toolBar
        sender.becomeFirstResponder()
        sender.keyboardType = .numberPad
        toolBar.barTintColor = UIColor.white
        constraint_bottom_tbl_View.constant = 235
        btnDone.setTitleColor(UIColor.black, for: .normal)
    }
    
    
    func txtPriceSet(_ sender: UITextField) {
        print(sender)
        let btnAdd = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnAdd)!
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrSendDataForAPI.object(at: index.row) as! Dictionary<String, Any>
        dictiTextChange.updateValue(sender.text ?? 0, forKey: "vPrice")
        arrSendDataForAPI.replaceObject(at: index.row, with: dictiTextChange)
        print(arrSendDataForAPI)
        //tblView.reloadData()
    }
    
    @IBAction func clkToButtonExTaped(_ sender: UIButton) {
        self.view.endEditing(true)
        let btnTap = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnTap)!
        let dictCategory = arrSendQuoteData[index.row] as! NSDictionary
        let strID = TO_STRING(dictCategory["iInquiryId"])
        arrForSelected.append(strID)
        //
        print(sender)
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrSendDataForAPI.object(at: index.row) as! Dictionary<String, Any>
        dictiTextChange.updateValue("Ex", forKey: "vDelivery")
        dictiTextChange.updateValue("Extra", forKey: "vLoading")
        arrSendDataForAPI.replaceObject(at: index.row, with: dictiTextChange)
        print(arrSendDataForAPI)
        //
        tblView.reloadData()
    }
    
    @IBAction func clkToButtonForTaped(_ sender: UIButton) {
        self.view.endEditing(true)
        let btnTap = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnTap)!
        let dictCategory = arrSendQuoteData[index.row] as! NSDictionary
        let strID = TO_STRING(dictCategory["iInquiryId"])
        if arrForSelected.contains(strID) {
            if let index = arrForSelected.index(of:strID) {
                arrForSelected.remove(at: index)
            }
        }
        print(sender)
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrSendDataForAPI.object(at: index.row) as! Dictionary<String, Any>
        dictiTextChange.updateValue("For", forKey: "vDelivery")
        dictiTextChange.updateValue("null", forKey: "vLoading")
        arrSendDataForAPI.replaceObject(at: index.row, with: dictiTextChange)
        print(arrSendDataForAPI)
        
        tblView.reloadData()
    }
    
    @IBAction func clkToButtonExtraTaped(_ sender: UIButton) {
        self.view.endEditing(true)
        let btnTap = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnTap)!
        let dictCategory = arrSendQuoteData[index.row] as! NSDictionary
        let strID = TO_STRING(dictCategory["iInquiryId"])
        if arrForLoading.contains(strID) {
            if let index = arrForLoading.index(of:strID) {
                arrForLoading.remove(at: index)
            }
        }
        //
        print(sender)
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrSendDataForAPI.object(at: index.row) as! Dictionary<String, Any>
        dictiTextChange.updateValue("Extra", forKey: "vLoading")
        arrSendDataForAPI.replaceObject(at: index.row, with: dictiTextChange)
        print(arrSendDataForAPI)
        //
        tblView.reloadData()
    }
    
    @IBAction func clkToButtonIncludeTaped(_ sender: UIButton) {
        self.view.endEditing(true)
        let btnTap = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnTap)!
        let dictCategory = arrSendQuoteData[index.row] as! NSDictionary
        let strID = TO_STRING(dictCategory["iInquiryId"])
        arrForLoading.append(strID)
        //
        print(sender)
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrSendDataForAPI.object(at: index.row) as! Dictionary<String, Any>
        dictiTextChange.updateValue("Include", forKey: "vLoading")
        arrSendDataForAPI.replaceObject(at: index.row, with: dictiTextChange)
        print(arrSendDataForAPI)
        //
        tblView.reloadData()
    }
    
    
    @IBAction func clkToButtonSubmitQuoteTaped(_ sender: UIButton) {
        self.view.endEditing(true)
//        for i in 0..<arrSendDataForAPI.count {
//            var dict: NSDictionary = [:]
//            dict = arrSendDataForAPI.object(at: i) as! NSDictionary
//            
//            let strPrice = TO_STRING(dict["vPrice"])
//            if strPrice == "" {
//                Constant.showAlert(title: "Steelbuddy", message: "Please enter Price")
//                return
//            }
//        }
        strCompleted = "First"
        print(arrSendDataForAPI)
        app_Delegate.startLoadingview("")
        for j in 0..<arrSendDataForAPI.count {
            var dict: NSDictionary = [:]
            dict = arrSendDataForAPI.object(at: j) as! NSDictionary
            self.apiCallForSendQuatationFromApp(param: dict as! [String : Any])
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
        
    // MARK:-  Picker Done Cancel Action Method
    // MARK: - ToolBar Button Action
    func donePressed(){
        self.view.endEditing(true)
        if strCheck == "Number" {
        }
        else {
            print(selectedIndex.row)
            print(selecIndex)
            //let currentCell = tblView.cellForRow(at: selectedIndex) as! SubmitQuoteTableCell
            //currentCell.txtPayments.text = strSelectedPicker
            
            //
            var dictiTextChange: Dictionary<String,Any> = [:]
            dictiTextChange = arrSendDataForAPI.object(at: selectedIndex.row) as! Dictionary<String, Any>
            dictiTextChange.updateValue(strSelectedPicker, forKey: "vPayments")
            arrSendDataForAPI.replaceObject(at: selectedIndex.row, with: dictiTextChange)
            print(arrSendDataForAPI)
            tblView.reloadData()
        }
        constraint_bottom_tbl_View.constant = 0
    }
    
    func cancelPressed(){
        constraint_bottom_tbl_View.constant = 0
        self.view.endEditing(true) // or do something
    }
    
    //=====================================================================================//
    
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToBackAction(_ sender: UIButton) {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}





