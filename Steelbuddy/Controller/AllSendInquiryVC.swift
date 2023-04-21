//
//  AllSendInquiryVC.swift
//  Steelbuddy
//
//  Created by Gaurang Mistry on 11/10/17.
//  Copyright © 2017 deepak jain. All rights reserved.
//

import UIKit

class AllSendInquiryVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {

    var strINSID = ""
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    var arrTatalData = NSMutableArray()
    var arrAllInquiryData = NSMutableArray()

    
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
        
        tblView.register(UINib(nibName: "AllInquiryTableCell", bundle: nil), forCellReuseIdentifier: "AllInquiryTableCell")
        
        tblView.estimatedRowHeight = 120.0
        tblView.rowHeight = UITableViewAutomaticDimension
        //============================================================================================//
        
        app_Delegate.startLoadingview("")
        self.ApiCallForGetTotalInquiry()
    }
    
    // MARK: - Get Total Inquiry Api Call Method
    func ApiCallForGetTotalInquiry() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetInquiry
        
        let param = ["iUserId"     : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetInquiry)
        
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetInquiry {
            
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
                        //Set Data
                       // self.SetTotalDataInTableView()
                        
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
    
    
//    func SetTotalDataInTableView() {
//        arrAllInquiryData.removeAllObjects()
//        var arrSubCat = NSMutableArray()
//        
//        for i in 0..<arrTatalData.count {
//            let dictCategory = arrTatalData[i] as! NSDictionary
//            let resData = dictCategory["Data"] as? NSArray
//            if resData != nil {
//                arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
//                for j in 0..<arrSubCat.count {
//                    let dictSubCategory = arrSubCat[j] as! NSDictionary
//                    arrAllInquiryData.add(dictSubCategory)
//                }
//            }
//        }
//        print(arrAllInquiryData)
//        tblView.reloadData()
//        
//    }

    
    //=====================================================================================//
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return arrTatalData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let dictCategory = arrTatalData[section] as! NSDictionary
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllInquiryTableCell", for: indexPath as IndexPath) as! AllInquiryTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        
        let dictCategory = arrTatalData[indexPath.section] as! NSDictionary
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            var dict: NSDictionary = [:]
            dict = arrSubCat.object(at:indexPath.row) as! NSDictionary
            
            cell.lblCity.text = TO_STRING(dict["vCity"])
            cell.lblMake.text = TO_STRING(dict["vMake"])
            cell.lblSize.text = TO_STRING(dict["vSize"])
            cell.lblGrade.text = TO_STRING(dict["vGrade"])
            cell.lblState.text = TO_STRING(dict["vState"])
            cell.lblQuantity.text = TO_STRING(dict["vQty"])
            let strMainName = TO_STRING(dict["vMainName"])
            cell.lblTitle.text = TO_STRING(dict["vSubName"]) + " - " + strMainName
            let indecoun = indexPath.row + 1
            if indecoun == arrSubCat.count {
                cell.lblUnderLine.isHidden = false
                let strdate = TO_STRING(dict["dCreatedDateTime"])
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let Mindate = dateFormatter.date(from: strdate)
                dateFormatter.dateFormat = "dd-MMM-yyy hh:mm a"
                let strSetDate = dateFormatter.string(from: Mindate!)
                cell.lblDate.text = strSetDate
            }
            else {
                cell.lblDate.text = ""
                cell.lblUnderLine.isHidden = true
            }
        }
        
        
        
        
            
        
        
        //var dict: NSDictionary = [:]
        //dict = arrAllInquiryData.object(at:indexPath.row) as! NSDictionary
        
        
//        if indexPath.row == 0 {
//            cell.constraint_top_space.constant = 12
//        }
//        let check = indexPath.row + 1
//        if check == arrAllInquiryData.count {
//            //cell.constraint_bottom_space.constant = 12
//        }
        
        
//        let InqID = TO_STRING(dict["iInqId"])
//        if InqID == strINSID {
//            print("Existing")
//            cell.lblDate.isHidden = false
//            cell.lblUnderLine.isHidden = false
//            cell.Contraint_botton_view_height.constant = 8
//            cell.contraint_bootom_white_space.constant = 45
//        }
//        else {
//            strINSID = InqID
//            print("New")
//            cell.lblDate.isHidden = true
//            cell.lblUnderLine.isHidden = true
//            cell.contraint_bootom_white_space.constant = 0
//            cell.Contraint_botton_view_height.constant = 0
//        }
        

        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let dictCategory = arrTatalData[indexPath.section] as! NSDictionary
//        let resData = dictCategory["Data"] as? NSArray
//        if resData != nil {
//            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
//            
//            let indecoun = indexPath.row + 1
//            if indecoun == arrSubCat.count {
//                return 300
//            }
//            else {
//                return 270
//            }
//        }
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
    
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}



