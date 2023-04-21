//
//  ChatListVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit

class ChatListVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var strTitle = ""
    var arrChatData = NSMutableArray()
    var Chatdict: NSDictionary = [:]
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblTitle.text = "Chat"
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        //==========================================================================================//
        //Table Cell Register
        tblView.register(UINib(nibName: "QuatationHeaderCell", bundle: nil), forCellReuseIdentifier: "QuatationHeaderCell")
        
        tblView.register(UINib(nibName: "ChatTableCell", bundle: nil), forCellReuseIdentifier: "ChatTableCell")
        
        tblView.estimatedRowHeight = 70.0
        tblView.rowHeight = UITableViewAutomaticDimension
        //=========================================================================================//
        print(Chatdict)
        app_Delegate.startLoadingview("")
        self.CallApiForGetChatting()
    }
    
    
    // MARK: - Get Chat Api Call Method
    func CallApiForGetChatting() {
        // init paramters Dictionary
        var myUrl = ""
        
        var param = [String : Any]()
        
        if _userDefault.string(forKey: "type") == "b" {
            myUrl = kBasePath + kGetQuatation
            
            param = ["iUserId"     : _userDefault.integer(forKey: "user_id")]
        }
        else if _userDefault.string(forKey: "type") == "s" {
            myUrl = kBasePath + kGetSellerViewQuatation
            
            param = ["iSUserID"     : _userDefault.integer(forKey: "user_id")]
        }
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetChat)
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
                    
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrChatData = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrChatData)
                        
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
    
    
    
    
    
    
    //=====================================================================================//
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return arrChatData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let dictCategory = arrChatData[section] as! NSDictionary
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            var arrTemp = [String]()
            if _userDefault.string(forKey: "type") == "b" {
                let arrInnerDict = arrSubCat[0] as! NSDictionary
                let resultData = arrInnerDict["Data"] as? NSArray
                if resultData != nil {
                    let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                    let arrInnerDict = arrSubCat[0] as! NSDictionary
                    let resulNEWtData = arrInnerDict["Data"] as? NSArray
                    if resulNEWtData != nil {
                        for i in 0..<arrSubCat.count {
                            var dict: NSDictionary = [:]
                            dict = arrSubCat.object(at: i) as! NSDictionary
                            let strName = TO_STRING(dict["name"])
                            if arrTemp.contains(strName) {
                            }
                            else {
                                arrTemp.append(strName)
                            }
                        }
                    }
                    
                    return arrTemp.count
                }
            }
                
            else if _userDefault.string(forKey: "type") == "s" {
                for i in 0..<arrSubCat.count {
                    var dict: NSDictionary = [:]
                    dict = arrSubCat.object(at: i) as! NSDictionary
                    let strName = TO_STRING(dict["name"])
                    if arrTemp.contains(strName) {
                    }
                    else {
                        arrTemp.append(strName)
                    }
                }
                return arrTemp.count
            }
        }
        

        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuatationHeaderCell") as? QuatationHeaderCell else {
            return UIView()
        }
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.viewBG.isHidden = true
        
        return cell.contentView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableCell", for: indexPath as IndexPath) as! ChatTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        let dictCategory = arrChatData[indexPath.section] as! NSDictionary
        print(dictCategory)
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            
            if _userDefault.string(forKey: "type") == "b" {
                
                let arrInnerDict = arrSubCat[0] as! NSDictionary
                let resultData = arrInnerDict["Data"] as? NSArray
                if resultData != nil {
                    let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                    print(arrSubCat)
                        
                    let arrInnerDict = arrSubCat[indexPath.row] as! NSDictionary
                    let resulNEWtData = arrInnerDict["Data"] as? NSArray
                    if resulNEWtData != nil {
                        let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        
                        var dict: NSDictionary = [:]
                        dict = arrSubCat.object(at: indexPath.row) as! NSDictionary
                        cell.lblTitle.text = TO_STRING(dict["name"])
                        
                        var arrTemp = [String]()
                        for i in 0..<arrSubCat.count {
                            var dict: NSDictionary = [:]
                            dict = arrSubCat.object(at: i) as! NSDictionary
                            let strName = TO_STRING(dict["name"])
                            if strName == cell.lblTitle.text {
                                let strMain = TO_STRING(dict["vMainName"])
                                let strSub = TO_STRING(dict["vSubName"])
                                let str = strSub + "-" + strMain
                                arrTemp.append(str)
                            }
                        }
                        cell.lblSubTitle.text = arrTemp.joined(separator: ",")
                        
                    }
                }
            }
            else if _userDefault.string(forKey: "type") == "s" {
                var dict: NSDictionary = [:]
                dict = arrSubCat.object(at: indexPath.row) as! NSDictionary
                cell.lblTitle.text = TO_STRING(dict["name"])
                
                var arrTemp = [String]()
                for i in 0..<arrSubCat.count {
                    var dict: NSDictionary = [:]
                    dict = arrSubCat.object(at: i) as! NSDictionary
                    let strName = TO_STRING(dict["name"])
                    if strName == cell.lblTitle.text {
                        let strMain = TO_STRING(dict["vMainName"])
                        let strSub = TO_STRING(dict["vSubName"])
                        let str = strSub + "-" + strMain
                        arrTemp.append(str)
                    }
                }
                cell.lblSubTitle.text = arrTemp.joined(separator: ",")
            }
            
            
        }
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictCategory = arrChatData[indexPath.section] as! NSDictionary
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            if _userDefault.string(forKey: "type") == "b" {
                let arrInnerDict = arrSubCat[0] as! NSDictionary
                let resultData = arrInnerDict["Data"] as? NSArray
                if resultData != nil {
                    let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                    let arrInnerDict = arrSubCat[indexPath.row] as! NSDictionary
                    let resulNEWtData = arrInnerDict["Data"] as? NSArray
                    if resulNEWtData != nil {
                        let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        
                        var dict: NSDictionary = [:]
                        dict = arrSubCat.object(at: 0) as! NSDictionary
                        
                        let strName = TO_STRING(dict["name"])
                        let objChat = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                        objChat.strTitle = strName
                        objChat.Chatdict = dict
                        self.navigationController?.pushViewController(objChat, animated: true)
                    }
                }
            }
                
            else if _userDefault.string(forKey: "type") == "s" {
                var dict: NSDictionary = [:]
                dict = arrSubCat.object(at: indexPath.row) as! NSDictionary
                
                let strName = TO_STRING(dict["name"])
                let objChat = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                objChat.strTitle = strName
                objChat.Chatdict = dict
                self.navigationController?.pushViewController(objChat, animated: true)
            }
        }
    }
        
    
    
                
    //============================================================================================//
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToLeftMenuAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

    
}














