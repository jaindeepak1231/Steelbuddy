//
//  QuotationListVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit

class QuotationListVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {

    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    var strBooked = ""
    var indexSection = 0
    
    
    //let ContentViewTablebg = UIView()
    //var lblmainTitile = UILabel()
//    var lblunderline = UILabel()
//    var lblQuentityTitile = UILabel()
//    var lblSizeTitile = UILabel()
//    var lblGradeTitile = UILabel()
//    var lblMakeTitile = UILabel()
//    var lblStateTitile = UILabel()
//    var lblCityTitile = UILabel()
//    var lblDeliveryTitile = UILabel()
//    var lblLoadingTitile = UILabel()
//    var lblPaymentTitile = UILabel()
//    var lblGSTTitile = UILabel()
//    var lblFinalunderline = UILabel()
    
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    var arrTatalData = NSMutableArray()
    var arrOpenExpendCellSections = [IndexPath]()
    
    var seconds = 4
    var timer = Timer()
    var viewForSubmit = ViewSubmitBooking()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        strBooked = "NotBooking"
        arrOpenExpendCellSections.removeAll()
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        //=========================================================//
        //Table Cell Register
        tblView.register(UINib(nibName: "QuatationHeaderCell", bundle: nil), forCellReuseIdentifier: "QuatationHeaderCell")
        
        tblView.register(UINib(nibName: "ViewQuatatioTableCell", bundle: nil), forCellReuseIdentifier: "ViewQuatatioTableCell")
        
        tblView.estimatedRowHeight = 120.0
        tblView.rowHeight = UITableViewAutomaticDimension
        //============================================================================================//
        
        if _userDefault.string(forKey: "type") == "b" {
            app_Delegate.startLoadingview("")
            self.ApiCallForGetBuyerQuatation()
        }
        else if _userDefault.string(forKey: "type") == "s" {
        }
        
    }
    
    //For Timer
    func viewForSubmitInquiry() {
        app_Delegate.stopLoadingView()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self,   selector: (#selector(self.ApiCallForGetBuyerQuatation)), userInfo: nil, repeats: false)
        
        viewForSubmit = (Bundle.main.loadNibNamed("ViewSubmitBooking", owner: self, options: nil)?.first as? ViewSubmitBooking)!
        
        viewForSubmit.frame = CGRect(x: CGFloat(0), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
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
            viewForSubmit.removeFromSuperview()
        }
        
    }
    //=====================================================================================//
    
    
    
    // MARK: - Get Total Inquiry Api Call Method
    func ApiCallForGetBuyerQuatation() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetQuatation
        
        let param = ["iUserId"     : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetQuatation)
        
    }
    
    // MARK: - Get Total Inquiry Api Call Method
    func ApiCallForReadQuotation(InqIDs : String) {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetBuyerRead
        
        let param = ["iInqId"     : InqIDs]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameReadQuotation)
        
    }
    
    

    
    // MARK: - Get Total Inquiry Api Call Method
    func ApiCallForBookQuatation(inqID: String) {
        // init paramters Dictionary
        let myUrl = kBasePath + kBookQuatation
        
        let param = ["iInqId"    : inqID,
                     "vBooked"   : "Yes"]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameBookQuatation)
        
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
                        
                        var arrIDs = [String]()
                        for i in 0..<arrTatalData.count {
                            let dict = arrTatalData[i] as! NSDictionary
                            let strCatTitle = TO_STRING(dict["iInqId"])
                            arrIDs.append(strCatTitle)
                        }
                        
                        let strString = arrIDs.joined(separator: ",")
                        
                        //ForReadQuotation
                        self.ApiCallForReadQuotation(InqIDs: strString)
                        
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
        
        
        if name == ServerCallName.serverCallNameBookQuatation {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    Timer.scheduledTimer(timeInterval: 0.2, target: self,   selector: (#selector(self.viewForSubmitInquiry)), userInfo: nil, repeats: false)
                    
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
            
            let arrInnerDict = arrSubCat[0] as! NSDictionary
            let resultData = arrInnerDict["Data"] as? NSArray
            if resultData != nil {
                let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                let arrInnerDict = arrSubCat[0] as! NSDictionary
                let resulNEWtData = arrInnerDict["Data"] as? NSArray
                if resulNEWtData != nil {
                    return arrSubCat.count
                }
            }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewQuatatioTableCell", for: indexPath as IndexPath) as! ViewQuatatioTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        cell.viewExtraBG.isHidden = true
        cell.lblUnderKLine.isHidden = true
        cell.lblDate.isHidden = true
        cell.btnbook.isHidden = true
        cell.btnChat.isHidden = true
        cell.viewExtraBG.isHidden = true
        
        let dictCategory = arrTatalData[indexPath.section] as! NSDictionary
        print(dictCategory)
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            let arrInnerDict = arrSubCat[0] as! NSDictionary
            let resultData = arrInnerDict["Data"] as? NSArray
            if resultData != nil {
                let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                print(arrSubCat)
                
                let arrInnerDict = arrSubCat[indexPath.row] as! NSDictionary
                let resulNEWtData = arrInnerDict["Data"] as? NSArray
                if resulNEWtData != nil {
                    let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                    print(arrSubCat)
                    
            //============Set Value in Top View========================================================//
                    var arrTotal = [Int]()
                    for l in 0..<arrSubCat.count {
                        var dict: NSDictionary = [:]
                        dict = arrSubCat.object(at: l) as! NSDictionary
                        
                        let strQuentity = TO_STRING(dict["vQty"])
                        let INTQuentity = Int(strQuentity)
                        let strPric = TO_STRING(dict["vPrice"])
                        let INTPrice = Int(strPric)
                        
                        let total = INTQuentity! * INTPrice!
                        arrTotal.append(total)
                        
                        cell.lblTitle.text = TO_STRING(dict["company_name"])
                    }
                    let sumedArr = arrTotal.reduce(0, {$0 + $1})
                    print(sumedArr)
                    cell.lblSubTitle.text = sumedArr.description + " + GST"
            //=====================//===============//======================//=======================//
                    
                    var y_lblMainTitle = 10
                    var height = arrSubCat.count
                    height = height*382
                    cell.constraint_view_field_height.constant = CGFloat(height)
                    
                    var lblmainTitile = UILabel()
                    var lblQuentity = UILabel()
                    var lblQuentityTitile = UILabel()
                    var lblSize = UILabel()
                    var lblSizeTitile = UILabel()
                    
                    var i = cell.viewExtraBG.subviews.count - 1
                    while i >= 0 {
                        cell.viewExtraBG.subviews[i].removeFromSuperview()
                        i -= 1
                    }
                    
                    
                    if arrOpenExpendCellSections.contains(indexPath) {
                    for j in 0..<arrSubCat.count {
                        var dict: NSDictionary = [:]
                        dict = arrSubCat.object(at: j) as! NSDictionary
                        
                        
                        cell.lblDate.isHidden = false
                        cell.btnbook.isHidden = false
                        cell.btnChat.isHidden = false
                        cell.lblUnderKLine.isHidden = false
                        cell.viewExtraBG.isHidden = false

                        
                        //Content Background View in Main Title
                        lblmainTitile = UILabel()
                        lblmainTitile.frame = CGRect(x: 12, y: y_lblMainTitle, width: Int(screenWidth - 74), height: 19)
                        lblmainTitile.textColor = Constant.RedColor()
                        lblmainTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        let strMain = TO_STRING(dict["vMainName"])
                        let strSub = TO_STRING(dict["vSubName"])
                        lblmainTitile.text = strMain + "-" + strSub
                        cell.viewExtraBG.addSubview(lblmainTitile)
                        
                        //Underline in Main Title
                        let lblunderline = UILabel()
                        lblunderline.frame = CGRect(x: 0, y: y_lblMainTitle + 25, width: Int(screenWidth - 50), height: Int(1))
                        lblunderline.text = ""
                        lblunderline.backgroundColor = UIColor.black
                        cell.viewExtraBG.addSubview(lblunderline)
                        
        //=====================Content Background View in Quantity Title and Quentity================//
                        lblQuentityTitile = UILabel()
                        lblQuentityTitile.frame = CGRect(x: 15, y: y_lblMainTitle + 40, width: 80, height: 19)
                        lblQuentityTitile.textColor = Constant.blackColor()
                        lblQuentityTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        lblQuentityTitile.text = "Quantity :"
                        cell.viewExtraBG.addSubview(lblQuentityTitile)
                        
                        lblQuentity = UILabel()
                        lblQuentity.frame = CGRect(x: 97, y: y_lblMainTitle + 40, width: 80, height: 19)
                        lblQuentity.textColor = Constant.blackColor()
                        lblQuentity.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        let strQuentity = TO_STRING(dict["vQty"])
                        lblQuentity.text = strQuentity
                        cell.viewExtraBG.addSubview(lblQuentity)
                        
                        //Set MT
                        let lblMt = UILabel()
                        lblMt.frame = CGRect(x: Int(screenWidth - 130), y: y_lblMainTitle + 40, width: 50, height: 19)
                        lblMt.textColor = Constant.blackColor()
                        lblMt.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        lblMt.text = "Mt"
                        cell.viewExtraBG.addSubview(lblMt)
                        
                        
        //====================================//====================================================//
                        
                        
        //======================Content Background View in Size Title=============================//
                        lblSizeTitile = UILabel()
                        lblSizeTitile.frame = CGRect(x: 15, y: lblQuentityTitile.frame.origin.y + lblQuentityTitile.frame.size.height + 12, width: 80, height: 19)
                        lblSizeTitile.textColor = Constant.blackColor()
                        lblSizeTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        lblSizeTitile.text = "Size :"
                        cell.viewExtraBG.addSubview(lblSizeTitile)
                        
                        lblSize = UILabel()
                        lblSize.frame = CGRect(x: 97, y: lblQuentityTitile.frame.origin.y + lblQuentityTitile.frame.size.height + 12, width: screenWidth - 150, height: 19)
                        lblSize.textColor = Constant.blackColor()
                        lblSize.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        let strSize = TO_STRING(dict["vSize"])
                        lblSize.text = strSize
                        cell.viewExtraBG.addSubview(lblSize)
                        
        //====================================//====================================================//
                        
        //==============Content Background View in Grade Title=======================================//
                        let lblGradeTitile = UILabel()
                        lblGradeTitile.frame = CGRect(x: 15, y: lblSizeTitile.frame.origin.y + lblSizeTitile.frame.size.height + 12, width: 80, height: 19)
                        lblGradeTitile.textColor = Constant.blackColor()
                        lblGradeTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        lblGradeTitile.text = "Grade :"
                        cell.viewExtraBG.addSubview(lblGradeTitile)
                        
                        let lblGrade = UILabel()
                        lblGrade.frame = CGRect(x: 97, y: lblSizeTitile.frame.origin.y + lblSizeTitile.frame.size.height + 12, width: screenWidth - 150, height: 19)
                        lblGrade.textColor = Constant.blackColor()
                        lblGrade.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        lblGrade.text = TO_STRING(dict["vGrade"])
                        cell.viewExtraBG.addSubview(lblGrade)
        //====================================//====================================================//
                        
        //==============Content Background View in Make Title======================================//
                        let lblMakeTitile = UILabel()
                        lblMakeTitile.frame = CGRect(x: 15, y: lblGradeTitile.frame.origin.y + lblGradeTitile.frame.size.height + 12, width: 80, height: 19)
                        lblMakeTitile.textColor = Constant.blackColor()
                        lblMakeTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        lblMakeTitile.text = "Make :"
                        cell.viewExtraBG.addSubview(lblMakeTitile)
                        
                        let lblMake = UILabel()
                        lblMake.frame = CGRect(x: 97, y: lblGradeTitile.frame.origin.y + lblGradeTitile.frame.size.height + 12, width: screenWidth - 150, height: 19)
                        lblMake.textColor = Constant.blackColor()
                        lblMake.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        lblMake.text = TO_STRING(dict["vMake"])
                        cell.viewExtraBG.addSubview(lblMake)
        //====================================//====================================================//
                        
        //===============Content Background View in State Title==================================//
                        let lblStateTitile = UILabel()
                        lblStateTitile.frame = CGRect(x: 15, y: lblMakeTitile.frame.origin.y + lblMakeTitile.frame.size.height + 12, width: 80, height: 19)
                        lblStateTitile.textColor = Constant.blackColor()
                        lblStateTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        lblStateTitile.text = "State :"
                        cell.viewExtraBG.addSubview(lblStateTitile)
                        
                        let lblState = UILabel()
                        lblState.frame = CGRect(x: 97, y: lblMakeTitile.frame.origin.y + lblMakeTitile.frame.size.height + 12, width: screenWidth - 150, height: 19)
                        lblState.textColor = Constant.blackColor()
                        lblState.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        lblState.text = TO_STRING(dict["vState"])
                        cell.viewExtraBG.addSubview(lblState)
        //====================================//====================================================//
                        
        //==============Content Background View in City Title====================================//
                        let lblCityTitile = UILabel()
                        lblCityTitile.frame = CGRect(x: 15, y: lblStateTitile.frame.origin.y + lblStateTitile.frame.size.height + 12, width: 80, height: 19)
                        lblCityTitile.textColor = Constant.blackColor()
                        lblCityTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        lblCityTitile.text = "City :"
                        cell.viewExtraBG.addSubview(lblCityTitile)
                        
                        let lblCity = UILabel()
                        lblCity.frame = CGRect(x: 97, y: lblStateTitile.frame.origin.y + lblStateTitile.frame.size.height + 12, width: screenWidth - 150, height: 19)
                        lblCity.textColor = Constant.blackColor()
                        lblCity.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        lblCity.text = TO_STRING(dict["vCity"])
                        cell.viewExtraBG.addSubview(lblCity)
        //====================================//====================================================//
                        
        //==============Content Background View in Delivery Title==================================//
                        let lblDeliveryTitile = UILabel()
                        lblDeliveryTitile.frame = CGRect(x: 15, y: lblCityTitile.frame.origin.y + lblCityTitile.frame.size.height + 12, width: 80, height: 19)
                        lblDeliveryTitile.textColor = Constant.blackColor()
                        lblDeliveryTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        lblDeliveryTitile.text = "Delivery :"
                        cell.viewExtraBG.addSubview(lblDeliveryTitile)
                        
                        let lblDelivery = UILabel()
                        lblDelivery.frame = CGRect(x: 97, y: lblCityTitile.frame.origin.y + lblCityTitile.frame.size.height + 12, width: screenWidth - 150, height: 19)
                        lblDelivery.textColor = Constant.blackColor()
                        lblDelivery.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        lblDelivery.text = TO_STRING(dict["vDelivery"])
                        cell.viewExtraBG.addSubview(lblDelivery)
        //====================================//====================================================//
                        
        //==============Content Background View in Loading Title===================================//
                        let lblLoadingTitile = UILabel()
                        lblLoadingTitile.frame = CGRect(x: 15, y: lblDeliveryTitile.frame.origin.y + lblDeliveryTitile.frame.size.height + 12, width: 80, height: 19)
                        lblLoadingTitile.textColor = Constant.blackColor()
                        lblLoadingTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        lblLoadingTitile.text = "Loading :"
                        cell.viewExtraBG.addSubview(lblLoadingTitile)
                        
                        let lblLoading = UILabel()
                        lblLoading.frame = CGRect(x: 97, y: lblDeliveryTitile.frame.origin.y + lblDeliveryTitile.frame.size.height + 12, width: screenWidth - 150, height: 19)
                        lblLoading.textColor = Constant.blackColor()
                        lblLoading.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        lblLoading.text = TO_STRING(dict["vLoading"])
                        cell.viewExtraBG.addSubview(lblLoading)
        //====================================//====================================================//
                        
        //==============Content Background View in Payments Title==================================//
                        let lblPaymentTitile = UILabel()
                        lblPaymentTitile.frame = CGRect(x: 15, y: lblLoadingTitile.frame.origin.y + lblLoadingTitile.frame.size.height + 12, width: 80, height: 19)
                        lblPaymentTitile.textColor = Constant.blackColor()
                        lblPaymentTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        lblPaymentTitile.text = "Payments :"
                        cell.viewExtraBG.addSubview(lblPaymentTitile)
                        
                        let lblPayment = UILabel()
                        lblPayment.frame = CGRect(x: 97, y: lblLoadingTitile.frame.origin.y + lblLoadingTitile.frame.size.height + 12, width: screenWidth - 150, height: 19)
                        lblPayment.textColor = Constant.blackColor()
                        lblPayment.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        lblPayment.text = TO_STRING(dict["vPayments"])
                        cell.viewExtraBG.addSubview(lblPayment)
        //====================================//====================================================//
                        
        //==============Content Background View in GST Title=======================================//
                        let lblGSTTitile = UILabel()
                        lblGSTTitile.frame = CGRect(x: 15, y: lblPaymentTitile.frame.origin.y + lblPaymentTitile.frame.size.height + 12, width: 80, height: 19)
                        lblGSTTitile.textColor = Constant.blackColor()
                        lblGSTTitile.font = UIFont(name: Constant.Roboto_Reg, size: 16)
                        lblGSTTitile.text = "Gst :"
                        cell.viewExtraBG.addSubview(lblGSTTitile)
                        
                        let lblGST = UILabel()
                        lblGST.frame = CGRect(x: 97, y: lblPaymentTitile.frame.origin.y + lblPaymentTitile.frame.size.height + 12, width: screenWidth - 150, height: 19)
                        lblGST.textColor = Constant.blackColor()
                        lblGST.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        lblGST.text = "Extra as Applicable"
                        cell.viewExtraBG.addSubview(lblGST)
                    
        //====================================//====================================================//
                        
        //==============Price in Main Title=====================================================//
                        let lblPrice = UILabel()
                        lblPrice.frame = CGRect(x: 97, y: Int(lblGST.frame.origin.y + lblGST.frame.size.height + 15), width: Int(screenWidth - 160), height: Int(19))
                        lblPrice.textColor = Constant.blackColor()
                        lblPrice.font = UIFont(name: Constant.Roboto_Reg, size: 15)
                        lblPrice.text = TO_STRING(dict["vPrice"])
                        lblPrice.textAlignment = .right
                        cell.viewExtraBG.addSubview(lblPrice)
        //====================================//====================================================//
                        
        //==============Underline in Main Title=====================================================//
                        let lblFinalunderline = UILabel()
                        lblFinalunderline.frame = CGRect(x: 0, y: Int(lblPrice.frame.origin.y + lblPrice.frame.size.height + 15), width: Int(screenWidth - 50), height: Int(1))
                        lblFinalunderline.text = ""
                        lblFinalunderline.backgroundColor = UIColor.black
                        cell.viewExtraBG.addSubview(lblFinalunderline)
                        
                        let isCheck = indexPath.row + 1
                        if isCheck == arrSubCat.count {
                            lblFinalunderline.isHidden = true
                        }
                        else {
                            lblFinalunderline.isHidden = false
                        }
        //====================================//====================================================//
                        let getNewHeight = lblFinalunderline.frame.origin.y + lblFinalunderline.frame.size.height - 5
                        cell.constraint_view_field_height.constant = getNewHeight
                        
                        y_lblMainTitle = Int(lblFinalunderline.frame.origin.y) + Int(lblFinalunderline.frame.size.height) + 20
                    
                    let strBookStatus = TO_STRING(dict["vBooked"])
                    if strBookStatus == "yes" {
                        cell.btnbook.setTitle("Already Book", for: .normal)
                        cell.btnbook.isUserInteractionEnabled = false
                    }
                    else {
                        cell.btnbook.setTitle("Book", for: .normal)
                        cell.btnbook.isUserInteractionEnabled = true
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
                    
                    }
                    else {
                        cell.viewExtraBG.isHidden = true
                    }
                }
                
                
                
                cell.btnView.tag = indexPath.row
                cell.btnView.addTarget(self, action: #selector(self.clkToButtonViewQuatationDetailTaped), for: .touchUpInside)
                
                cell.btnChat.tag = indexPath.row
                cell.btnChat.addTarget(self, action: #selector(self.clkToButtonChatTaped), for: .touchUpInside)
                
                cell.btnbook.tag = indexPath.row
                cell.btnbook.addTarget(self, action: #selector(self.clkToButtonBookTaped), for: .touchUpInside)
            
                
                
            }
        }
        
    
        
   
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if arrOpenExpendCellSections.contains(indexPath) {
                let dictCategory = arrTatalData[indexPath.section] as! NSDictionary
                let resData = dictCategory["Data"] as? NSArray
                if resData != nil {
                    let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                    let arrInnerDict = arrSubCat[0] as! NSDictionary
                    let resultData = arrInnerDict["Data"] as? NSArray
                    if resultData != nil {
                        let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrSubCat)
                        let arrInnerDict = arrSubCat[indexPath.row] as! NSDictionary
                        let resulNEWtData = arrInnerDict["Data"] as? NSArray
                        if resulNEWtData != nil {
                            let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                            print(arrSubCat)
                            
                            var count = arrSubCat.count
                            count = count*382
                            count = count + 210
                            if arrSubCat.count == 3 {
                                count = count + 65
                            }
                            return CGFloat(count)
                        }
                    }
                }
                
                
                
                // return 565
            }
            else {
                return 80
            }
       
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if arrOpenExpendCellSections.contains(indexPath) {
            if let index = arrOpenExpendCellSections.index(of:indexPath) {
                arrOpenExpendCellSections.remove(at: index)
            }
        }
        else {
             arrOpenExpendCellSections.append(indexPath)
        }
        
        tblView.reloadData()
    }
    
    
    @IBAction func clkToButtonViewQuatationDetailTaped(_ sender: UIButton) {
        let btnDetail = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnDetail)!
        let dictCategory = arrTatalData[index.section] as! NSDictionary
        print(dictCategory)
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            let arrInnerDict = arrSubCat[0] as! NSDictionary
            let resultData = arrInnerDict["Data"] as? NSArray
            if resultData != nil {
                let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                print(arrSubCat)
                
                let arrInnerDict = arrSubCat[index.row] as! NSDictionary
                let resulNEWtData = arrInnerDict["Data"] as? NSArray
                if resulNEWtData != nil {
                    let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                    print(arrSubCat)
                    
                    let objDetail = self.storyboard?.instantiateViewController(withIdentifier: "QuatationDetailVC") as! QuatationDetailVC
                    objDetail.arrCompnayData = arrSubCat
                    self.navigationController?.pushViewController(objDetail, animated: true)
                    
                }
            }
        }
    
        
        
        
        
    }
    
    
    @IBAction func clkToButtonChatTaped(_ sender: UIButton) {
        let btnChat = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnChat)!
        let dictCategory = arrTatalData[index.section] as! NSDictionary
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            let arrInnerDict = arrSubCat[0] as! NSDictionary
            let resultData = arrInnerDict["Data"] as? NSArray
            if resultData != nil {
                let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                
                let arrInnerDict = arrSubCat[index.row] as! NSDictionary
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
    }

    
    @IBAction func clkToButtonBookTaped(_ sender: UIButton) {
        indexSection = sender.tag
        let btnBook = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnBook)!
        let dictCategory = arrTatalData[index.section] as! NSDictionary
        let resData = dictCategory["Data"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            let arrInnerDict = arrSubCat[0] as! NSDictionary
            let resultData = arrInnerDict["Data"] as? NSArray
            if resultData != nil {
                let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                
                let arrInnerDict = arrSubCat[index.row] as! NSDictionary
                let resulNEWtData = arrInnerDict["Data"] as? NSArray
                if resulNEWtData != nil {
                    let arrSubCat = (arrInnerDict["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    var dict: NSDictionary = [:]
                    dict = arrSubCat.object(at: 0) as! NSDictionary
                    
                    let strName = TO_STRING(dict["vBooked"])
                    if strName == "Yes" {
                        Constant.showAlert(title: "Steelbuddy", message: "Already Book This Quatation ")
                        return
                    }
                    else {
//                        if strBooked == "Booked" {
//                            Constant.showAlert(title: "Steelbuddy", message: "Already Book This Quatation ")
//                            return
//                        }
//                        else {
                            //strBooked = "Booked"
                            let strInqID = TO_STRING(dict["iInqId"])
                            app_Delegate.startLoadingview("")
                            self.ApiCallForBookQuatation(inqID: strInqID)
                       // }
                        
//                        let currentcell = tblView.cellForRow(at: index) as! QuatationTableCell
//                        currentcell.btnbook.isUserInteractionEnabled = false
                        
                    }
                    
                    
                }
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




