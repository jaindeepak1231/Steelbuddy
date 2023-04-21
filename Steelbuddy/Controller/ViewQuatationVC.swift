//
//  ViewQuatationVC.swift
//  Steelbuddy
//
//  Created by deepak jain on 16/10/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class ViewQuatationVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {

    var strScreenFrom = ""
    var indexSection = 0
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    var arrTatalData = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        //=========================================================//
        //Table Cell Register
        tblView.register(UINib(nibName: "QuatationHeaderCell", bundle: nil), forCellReuseIdentifier: "QuatationHeaderCell")
        
        tblView.register(UINib(nibName: "ViewQuatationTableCell", bundle: nil), forCellReuseIdentifier: "ViewQuatationTableCell")
        
        tblView.estimatedRowHeight = 220.0
        tblView.rowHeight = UITableViewAutomaticDimension
        //============================================================================================//
        
        if _userDefault.string(forKey: "type") == "s" {
            app_Delegate.startLoadingview("")
            self.ApiCallForGetSellerViewQuatation()
        }
        
        
    }
    
    // MARK: - Get Total View Quatation Api Call Method
    func ApiCallForGetSellerViewQuatation() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetSellerViewQuatation
        
        let param = ["iSUserID"     : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetQuatation)
        
    }
    
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetQuatation {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    arrTatalData.removeAllObjects()
                    
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrTatalData = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrTatalData)
                        
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
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //=====================================================================================//
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return arrTatalData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let dictCategory = arrTatalData[section] as! NSDictionary
        print(dictCategory)
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                return arrSubCat.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuatationHeaderCell") as? QuatationHeaderCell else {
            return UIView()
        }
        
        cell.contentView.backgroundColor = UIColor.white
        
        let dict = arrTatalData[section] as! NSDictionary
        let strCatTitle = TO_STRING(dict["iInqId"])
        if strCatTitle == "" {
            cell.viewBG.isHidden = true
            cell.lblTitle.text = ""
        }
        else {
            cell.viewBG.isHidden = false
            cell.lblTitle.text = "InquiryID-" + strCatTitle
        }
        
        let dictCategory = arrTatalData[section] as! NSDictionary
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            let arrInnerDict = arrSubCat[0] as! NSDictionary
            let resultData = arrInnerDict["Data"] as? NSArray
            if resultData != nil {
                let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                let arrInnerDict = arrSubCat[0] as! NSDictionary
                let resulNEWtData = arrInnerDict["Data"] as? NSArray
                if resulNEWtData != nil {
                    let strCatTitle = TO_STRING(dictCategory["iInqId"])
                    cell.viewBG.isHidden = false
                    cell.lblTitle.text = "InquiryID-" + strCatTitle
                }
                else {
                    cell.lblTitle.text = ""
                    cell.viewBG.isHidden = true
                }
            }
        }
        
        
        return cell.contentView
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewQuatationTableCell", for: indexPath as IndexPath) as! ViewQuatationTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        let dictCategory = arrTatalData[indexPath.section] as! NSDictionary
        print(dictCategory)
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            var dict: NSDictionary = [:]
            dict = arrSubCat.object(at: indexPath.row) as! NSDictionary

            let strMain = TO_STRING(dict["vMainName"])
            let strSub = TO_STRING(dict["vSubName"])
            cell.lblQuatationTitle.text = strSub + "-" + strMain
            
            cell.lblQuantity.text = TO_STRING(dict["vQty"])
            cell.lblSize.text = TO_STRING(dict["vSize"])
            cell.lblGrade.text = TO_STRING(dict["vGrade"])
            cell.lblMake.text = TO_STRING(dict["vMake"])
            cell.lblState.text = TO_STRING(dict["vState"])
            cell.lblCity.text = TO_STRING(dict["vCity"])
            cell.lblDelivery.text = TO_STRING(dict["vDelivery"])
            cell.lblPayment.text = TO_STRING(dict["vPayments"])
            
            let loading = TO_STRING(dict["vLoading"])
            if loading == "null" {
                cell.lblLoadingTitle.text = ""
                cell.lblLoading.text = ""
            }
            else {
                cell.lblLoadingTitle.text = "Loading :"
                cell.lblLoading.text = TO_STRING(dict["vLoading"])
            }
            
            let strPrice = TO_STRING(dict["vPrice"])
            if strPrice == "" {
                cell.lblPrice.text = ""
                cell.lblPrice.text = ""
            }
            else {
                cell.lblPriceTitle.text = "Price :"
                cell.lblPrice.text = TO_STRING(dict["vPrice"])
            }
            
            let indexCheck = indexPath.row + 1
            if indexCheck == arrSubCat.count {
                cell.viewExtraBg.isHidden = false
                cell.constrain_view_extra_height.constant = 92
            }
            else {
                cell.viewExtraBg.isHidden = true
                cell.constrain_view_extra_height.constant = 0
            }
            
            //Set Date
            let strDate = TO_STRING(dict["dCreatedDateTime"])
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let Mindate = dateFormatter.date(from: strDate)
            dateFormatter.dateFormat = "dd-MMM-yyy hh:mm a"
            let strSetDate = dateFormatter.string(from: Mindate!)
            cell.lblDate.text = strSetDate
        }
                
                
        cell.btnViewDetail.tag = indexPath.row
        cell.btnViewDetail.addTarget(self, action: #selector(self.clkToButtonViewDetailTaped), for: .touchUpInside)
                
        cell.btnChat.tag = indexPath.row
        cell.btnChat.addTarget(self, action: #selector(self.clkToButtonChatTaped), for: .touchUpInside)
                
                
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let current = tblView.cellForRow(at: indexPath) as! ViewQuatationTableCell
//        let dictCategory = arrTatalData[indexPath.section] as! NSDictionary
//        print(dictCategory)
//        let resData = dictCategory["Data"] as? NSArray
//        if resData != nil {
//            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
//            let indexCheck = indexPath.row + 1
//            if indexCheck == arrSubCat.count {
//                current.constrain_view_extra_height.constant = 92
//            }
//            else {
//                current.constrain_view_extra_height.constant = 0
//            }
//        }
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    @IBAction func clkToButtonViewDetailTaped(_ sender: UIButton) {
        let btnDetail = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnDetail)!
        let dictCategory = arrTatalData[index.section] as! NSDictionary
        print(dictCategory)
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            let objDetail = self.storyboard?.instantiateViewController(withIdentifier: "QuatationDetailVC") as! QuatationDetailVC
            objDetail.strScreenFrom = "seller"
            objDetail.arrCompnayData = arrSubCat
            self.navigationController?.pushViewController(objDetail, animated: true)
                    
        }
    }
    
    
    @IBAction func clkToButtonChatTaped(_ sender: UIButton) {
        let btnChat = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnChat)!
        let dictCategory = arrTatalData[index.section] as! NSDictionary
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            var dict: NSDictionary = [:]
            dict = arrSubCat.object(at: index.row) as! NSDictionary
                    
            let strName = TO_STRING(dict["name"])
            let objChat = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            objChat.strTitle = strName
            objChat.Chatdict = dict
            self.navigationController?.pushViewController(objChat, animated: true)
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
    
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}




