//
//  NotificationVC.swift
//  Steelbuddy
//
//  Created by Gaurang Mistry on 31/10/17.
//  Copyright © 2017 deepak jain. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {

    var arrNotifications = NSMutableArray()
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblNoResult: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var btnClearNotification: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblNoResult.isHidden = true
        btnClearNotification.isHidden = true
        
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        //=========================================================//
        
        
        tblView.register(UINib(nibName: "NotificationTableCell", bundle: nil), forCellReuseIdentifier: "NotificationTableCell")
        tblView.estimatedRowHeight = 75
        tblView.rowHeight = UITableViewAutomaticDimension
        
        
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.CallApiForGetNotificationData), userInfo: self, repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCountThedata), name: NSNotification.Name(rawValue: "CountReload"), object: nil)
    }

    
    func setCountThedata() {
        self.CallApiForGetNotificationData()
    }
    
    // MARK: - CallApiForGetNotification Api Call Method
    func CallApiForGetNotificationData() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetNotificationData

        let param = ["iUserid"     : _userDefault.integer(forKey: "user_id")]
        



        print(myUrl, param)

        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetNotification)
    }
    
    
    // MARK: - CallApiForReadNotification Api Call Method
    func CallApiForReadNotification() {
        // init paramters Dictionary
        let myUrl = kBasePath + kReadNotification
        
        let param = ["iUserid"     : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameReadNotification)
        
    }
    
    
    // MARK: - CallApiForDeleteAllNotifications Api Call Method
    func CallApiForDeleteAllNotifications() {
        // init paramters Dictionary
        let myUrl = kBasePath + kDeleteNotification
        
        let param = ["iUserid"     : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameDeleteNotification)
        
    }
    
    
    
    
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetNotification {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    arrNotifications.removeAllObjects()
                    
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrNotifications = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrNotifications)
                        
                        if arrNotifications.count == 0 {
                            tblView.isHidden = true
                            lblNoResult.isHidden = false
                            btnClearNotification.isHidden = true
                        }
                        else {
                            tblView.isHidden = false
                            lblNoResult.isHidden = true
                            btnClearNotification.isHidden = false
                        }
                        
                    }
                    tblView.reloadData()
                    
                    self.CallApiForReadNotification()
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
        
        
            
        else if name == ServerCallName.serverCallNameDeleteNotification {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                if strResponse {
                    app_Delegate.stopLoadingView()
                    arrNotifications.removeAllObjects()
                    
                    if arrNotifications.count == 0 {
                        tblView.isHidden = true
                        lblNoResult.isHidden = false
                        btnClearNotification.isHidden = true
                    }
                    else {
                        tblView.isHidden = false
                        lblNoResult.isHidden = true
                        btnClearNotification.isHidden = false
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
            
            
        else if name == ServerCallName.serverCallNameReadNotification {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                if strResponse {
                    app_Delegate.stopLoadingView()
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
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrNotifications.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Addcell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell", for: indexPath as IndexPath) as! NotificationTableCell
        
        Addcell.backgroundColor = UIColor.clear
        Addcell.selectionStyle = .none
        Addcell.separatorInset = UIEdgeInsets.zero
        
        // Add a bottomBorder.
        Addcell.viewBG.layer.cornerRadius = 8
        Addcell.viewBG.layer.masksToBounds = false
        Addcell.viewBG.layer.shadowColor = UIColor.black.cgColor
        Addcell.viewBG.layer.shadowOpacity = 2.5
        Addcell.viewBG.layer.shadowOffset = CGSize(width: -1, height: 1)
        Addcell.viewBG.layer.shadowRadius = 2
        //=========================================================//
        
        
        var dict: NSDictionary = [:]
        dict = arrNotifications.object(at:indexPath.row) as! NSDictionary
        
        let strTitle = TO_STRING(dict["vTitle"])
        Addcell.lblTitle.text = strTitle
        
        let strDesc = TO_STRING(dict["tDescription"])
        Addcell.lblDescription.text = strDesc
        
        //Set Date
        let strDate = TO_STRING(dict["dCreatedDateTime"])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let Mindate = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = "dd-MMM-yyy hh:mm a"
        let strSetDate = dateFormatter.string(from: Mindate!)
        Addcell.lbldate.text = strSetDate
        
        
        
        
        return Addcell
        
        
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
    
    
    
    
    @IBAction func clkToClearAllNotificationAction(_ sender: UIButton) {
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.CallApiForDeleteAllNotifications), userInfo: self, repeats: false)
    }
    
    
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
