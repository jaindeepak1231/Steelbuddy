//
//  ChatVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var strTitle = ""
    var timer = Timer()
    var arrChatData = NSMutableArray()
    var Chatdict: NSDictionary = [:]
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var txtMsg: UITextField!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var constraint_bottom_view: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblTitle.text = strTitle.capitalized
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        //==========================================================================================//
        //Table Cell Register
        tblView.register(UINib(nibName: "SenderTableCell", bundle: nil), forCellReuseIdentifier: "SenderTableCell")
        
        tblView.register(UINib(nibName: "ReceiverTableCell", bundle: nil), forCellReuseIdentifier: "ReceiverTableCell")
        
        tblView.estimatedRowHeight = 70.0
        tblView.rowHeight = UITableViewAutomaticDimension
        //=========================================================================================//
        print(Chatdict)
        app_Delegate.startLoadingview("")
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self,   selector: (#selector(self.CallApiForGetChatting)), userInfo: nil, repeats: true)
        //self.CallApiForGetChatting()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    
    // MARK: - Get Chat Api Call Method
    func CallApiForGetChatting() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetChat

        let param = ["iInqId"    : TO_STRING(Chatdict["iInqId"]),
                     "iSUserId"  : TO_STRING(Chatdict["iSUserId"]),
                     "iUserId"   :  TO_STRING(Chatdict["iUserId"])]

        print(myUrl, param)

        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetChat)
    }
    
    // MARK: - Send Chat Api Call Method
    func CallApiForSendChat() {
        // init paramters Dictionary
        let myUrl = kBasePath + kSendChat
        
        let param = ["iInqId"    : TO_STRING(Chatdict["iInqId"]),
                     "iSUserId"  : TO_STRING(Chatdict["iSUserId"]),
                     "iUserId"   :  TO_STRING(Chatdict["iUserId"]),
                     "tMessage"  : txtMsg.text!,
                     "iSendBy"   : _userDefault.integer(forKey: "user_id")] as [String : Any]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameSendChat)
    }
    
    

    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetChat {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    arrChatData.removeAllObjects()
                    
                    let resData = resposeObject["data"] as? NSDictionary
                    if resData != nil {
                        
                        if (resData?["sellerData"] as? NSDictionary) != nil{
                            arrChatData = (resData?["chatData"]! as! NSArray).mutableCopy() as! NSMutableArray
                            print(arrChatData)
                            
                            if arrChatData.count == 0 {
                            }
                            else {
                                tableViewScrollToBottom(animated: true)
                            }
                            
                            
                        }
                        else {
                            print("It is a String")
                        }
                        
                        tblView.reloadData()
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
        
        
        if name == ServerCallName.serverCallNameSendChat {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    txtMsg.text = ""
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
        // Dispose of any resources that can be recreated.\
        
    }
    
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.tblView.numberOfSections
            let numberOfRows = self.tblView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }

    //=====================================================================================//
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrChatData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var dict = NSDictionary()
        dict = arrChatData.object(at:indexPath.row) as! NSDictionary
        let senderID = TO_INT(dict["iSendBy"])
        if senderID == _userDefault.integer(forKey: "user_id") {
            let Sendercell = tableView.dequeueReusableCell(withIdentifier: "SenderTableCell", for: indexPath as IndexPath) as! SenderTableCell
            
            Sendercell.backgroundColor = UIColor.clear
            Sendercell.selectionStyle = .none
            Sendercell.separatorInset = UIEdgeInsets.zero
            
            Sendercell.lblMSg.text = TO_STRING(dict["tMessage"])
            let strTime = TO_STRING(dict["dCreatedDateTime"])
            //Set Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let Mindate = dateFormatter.date(from: strTime)
            dateFormatter.dateFormat = "hh:mm a"
            let strSetDate = dateFormatter.string(from: Mindate!)
            
            let arrTime = strTime.components(separatedBy: " ")
            if Constant.currentDateString() == arrTime.first {
                Sendercell.lbldate.text = strSetDate
            }
            else {
                Sendercell.lbldate.text = arrTime.first! + " " + strSetDate
            }
            
            return Sendercell
        }
        else {
            let Receivercell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableCell", for: indexPath as IndexPath) as! ReceiverTableCell
            
            Receivercell.backgroundColor = UIColor.clear
            Receivercell.selectionStyle = .none
            Receivercell.separatorInset = UIEdgeInsets.zero
            
            Receivercell.lblMSg.text = TO_STRING(dict["tMessage"])
            
            let strTime = TO_STRING(dict["dCreatedDateTime"])
            //Set Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let Mindate = dateFormatter.date(from: strTime)
            dateFormatter.dateFormat = "hh:mm a"
            let strSetDate = dateFormatter.string(from: Mindate!)
            
            let arrTime = strTime.components(separatedBy: " ")
            if Constant.currentDateString() == arrTime.first {
                Receivercell.lbldate.text = strSetDate
            }
            else {
                Receivercell.lbldate.text = arrTime.first! + " " + strSetDate
            }
            
            return Receivercell
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // Mark: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        constraint_bottom_view.constant = 0
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        constraint_bottom_view.constant = 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        constraint_bottom_view.constant = 245
    }
    
    
    
    
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToLeftMenuAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clkToSendChatMessageAction(_ sender: UIButton) {
        if txtMsg.text == "" {
            return
        }
        
        //self.view.endEditing(true)
        //let strMsg = txtMsg.text!
        app_Delegate.startLoadingview("")
        self.CallApiForSendChat()
    }

}













