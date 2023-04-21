//
//  SellerViewInquiryVC.swift
//  Steelbuddy
//
//  Created by deepak jain on 15/10/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class SellerViewInquiryVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    var ProfileDict: NSDictionary = [:]
    var arrSelectedID = NSMutableArray()
    var arrViewInqData = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        
        //=========================================================================//
            let dataarrCategory: Data? = _userDefault.data(forKey: "arrSelectedID")
            arrSelectedID = NSKeyedUnarchiver.unarchiveObject(with: dataarrCategory!) as! NSMutableArray
        //============================================================================//
        
        //=========================================================//
        //Table Cell Register
        tblView.register(UINib(nibName: "QuatationHeaderCell", bundle: nil), forCellReuseIdentifier: "QuatationHeaderCell")
        
        tblView.register(UINib(nibName: "QuatationTableCell", bundle: nil), forCellReuseIdentifier: "QuatationTableCell")
        
        tblView.estimatedRowHeight = 120.0
        tblView.rowHeight = UITableViewAutomaticDimension
        //============================================================================================//
        
        if _userDefault.string(forKey: "type") == "s" {
            app_Delegate.startLoadingview("")
            self.CallApiForGetProfileData()
        }
        
        
    }
    
    // MARK: - Get Profile Data Api Call Method
    func CallApiForGetProfileData() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetProfile
        
        let param = ["id"     : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetProfile)
    }
    
    
    // MARK: - Get Total Inquiry Api Call Method
    func ApiCallForGetSelleInquiry() {
        let strID = arrSelectedID.componentsJoined(by: ",")
        // init paramters Dictionary
        let myUrl = kBasePath + kGetSellerInquiry
        
        let param = ["iSUserID"     : _userDefault.integer(forKey: "user_id"),
                     "iSub_Cart_Id" : strID] as [String : Any]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameSellerInquiry)
        
    }
    
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameSellerInquiry {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    arrViewInqData.removeAllObjects()
                    
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrViewInqData = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrViewInqData)
                        
                        tblView.reloadData()
                        
                    }
                }
                else {
                    app_Delegate.stopLoadingView()
                    Constant.showAlert(title: "Steelbuddy", message: strMsg)
                    return
                }
            }
            else {
                app_Delegate.stopLoadingView()
                let strerrMsg = TO_STRING(dicData["error"])
                Constant.showAlert(title: "", message:strerrMsg)
            }
        }
        
        else if name == ServerCallName.serverCallNameGetProfile {
            
            if ((dicData["status"]) != nil) {
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    
                    ProfileDict = (resposeObject["data"] as? NSDictionary)!
                    
                    self.ApiCallForGetSelleInquiry()
                    
                }
                else {
                    app_Delegate.stopLoadingView()
                    Constant.showAlert(title: "Steelbuddy", message: strMsg)
                    return
                }
            }
            else {
                app_Delegate.stopLoadingView()
                let strerrMsg = TO_STRING(dicData["error"])
                Constant.showAlert(title: "", message:strerrMsg)
            }
        }
            
        
        else if name == ServerCallName.serverCallNameBookQuatation {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                }
                else {
                    app_Delegate.stopLoadingView()
                    Constant.showAlert(title: "Steelbuddy", message: strMsg)
                    return
                }
            }
            else {
                app_Delegate.stopLoadingView()
                let strerrMsg = TO_STRING(dicData["error"])
                Constant.showAlert(title: "", message:strerrMsg)
            }
        }
        
        
        
        
        
        
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
        return arrViewInqData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let dictCategory = arrViewInqData[section] as! NSDictionary
        print(dictCategory)
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                print(arrSubCat.count)
                return arrSubCat.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuatationHeaderCell") as? QuatationHeaderCell else {
            return UIView()
        }
        
        cell.contentView.backgroundColor = UIColor.white
        
        let dict = arrViewInqData[section] as! NSDictionary
        let strCatTitle = TO_STRING(dict["iInqId"])
        if strCatTitle == "" {
            cell.viewBG.isHidden = true
            cell.lblTitle.text = ""
        }
        else {
            cell.viewBG.isHidden = false
            cell.lblTitle.text = "InquiryID-" + strCatTitle
        }
        
        let dictCategory = arrViewInqData[section] as! NSDictionary
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuatationTableCell", for: indexPath as IndexPath) as! QuatationTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        cell.lblUnderKLine.isHidden = true
        cell.viewBG.isHidden = true
        cell.lblDeliveryTitle.isHidden = true
        cell.lblDelivery.isHidden = true
        cell.lblLoadingTitle.isHidden = true
        cell.lblLoading.isHidden = true
        cell.lblPaymentTitle.isHidden = true
        cell.lblPayment.isHidden = true
        cell.lblGSTTitle.isHidden = true
        cell.lblGST.isHidden = true
        cell.lblThirdUnderLine.isHidden = false
        cell.lblSecondUnderLine.isHidden = true
        cell.viewExtraBg.backgroundColor = UIColor.clear
        cell.Constraint_TopView_height.constant = 0
        cell.constrain_view_top.constant = -15
        cell.constraint_top.constant = 0
        cell.constraint_view_bottom.constant = 0
        cell.constrain_view_extra_height.constant = 235
        cell.constraint_title_top.constant = 22
        cell.constraint_date_top.constant = 18
        cell.constraint_button_top.constant = 12
        cell.btnChat.backgroundColor = Constant.RedColor()
        cell.btnbook.backgroundColor = Constant.RedColor()
        cell.btnChat.setTitle("VIEW DETAILS", for: .normal)
        
        
        //if indexPath.row == 0 {
            cell.lblDate.isHidden = true
            cell.btnbook.isHidden = true
            cell.btnChat.isHidden = true
            cell.lblSecondUnderLine.isHidden = true
        //}
        
        let dictCategory = arrViewInqData[indexPath.section] as! NSDictionary
        let strQuote = TO_STRING(dictCategory["Quote"])
        if strQuote == "no" {
            cell.btnbook.setTitle("QUOTE", for: .normal)
        }
        else {
            cell.btnbook.setTitle("REVISE QUOTE", for: .normal)
        }
        
        
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            let indeCheck = indexPath.row + 1
            if indeCheck == arrSubCat.count {
                cell.lblDate.isHidden = false
                cell.btnbook.isHidden = false
                cell.btnChat.isHidden = false
            }
            
            var dict: NSDictionary = [:]
            dict = arrSubCat.object(at: indexPath.row) as! NSDictionary
                    
            cell.lblTitle.text = TO_STRING(dict["company_name"])
                    
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
            cell.lblLoading.text = TO_STRING(dict["vLoading"])
            cell.lblPayment.text = TO_STRING(dict["vPayments"])
            cell.lblGST.text = "Extra as Applicable"
            cell.lblPrice.text = TO_STRING(dict["vPrice"])
            
            //Set Date
            let strDate = TO_STRING(dict["dCreatedDateTime"])
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let Mindate = dateFormatter.date(from: strDate)
            dateFormatter.dateFormat = "dd-MMM-yyy hh:mm a"
            let strSetDate = dateFormatter.string(from: Mindate!)
            cell.lblDate.text = strSetDate
        }
                
                
        cell.btnView.isHidden = true

        cell.btnChat.tag = indexPath.row
        cell.btnChat.addTarget(self, action: #selector(self.clkToButtonViewDetailTaped), for: .touchUpInside)
        
        cell.btnbook.tag = indexPath.row
        cell.btnbook.addTarget(self, action: #selector(self.clkToButtonSendQuoteTaped), for: .touchUpInside)
                
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dictCategory = arrViewInqData[indexPath.section] as! NSDictionary
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            let indexChe = indexPath.row + 1
            if indexChe == arrSubCat.count {
                return 315
            }
        }
        return 235
    }
    
    
    
    @IBAction func clkToButtonViewDetailTaped(_ sender: UIButton) {
        let btnDetail = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnDetail)!
        let dictCategory = arrViewInqData[index.section] as! NSDictionary
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            print(arrSubCat)
            let dicPaidData = arrSubCat.object(at: 0) as! NSDictionary
            let strPaid = TO_STRING(ProfileDict["vSelerType"])
            if strPaid == "unpaid" {
                let strMsg = TO_STRING(dicPaidData["vMessage"])
                Constant.showAlert(title: "Steelbuddy", message: strMsg)
                return
            }
            else {
                let objDetail = self.storyboard?.instantiateViewController(withIdentifier: "QuatationDetailVC") as! QuatationDetailVC
                objDetail.strScreenFrom = "seller"
                objDetail.arrCompnayData = arrSubCat
                self.navigationController?.pushViewController(objDetail, animated: true)
            }
        }
    }
    
    
    
    @IBAction func clkToButtonSendQuoteTaped(_ sender: UIButton) {
        let btnSend = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnSend)!
        let dictCategory = arrViewInqData[index.section] as! NSDictionary
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            print(arrSubCat)
        
            let dicPaidData = arrSubCat.object(at: 0) as! NSDictionary
            let strPaid = TO_STRING(ProfileDict["vSelerType"])
            if strPaid == "unpaid" {
                let strMsg = TO_STRING(dicPaidData["vMessage"])
                Constant.showAlert(title: "Steelbuddy", message: strMsg)
                return
            }
            else {
                let objDetail = self.storyboard?.instantiateViewController(withIdentifier: "SubmitQuoteVC") as! SubmitQuoteVC
                objDetail.arrSendQuoteData = arrSubCat
                self.navigationController?.pushViewController(objDetail, animated: true)
            }
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










