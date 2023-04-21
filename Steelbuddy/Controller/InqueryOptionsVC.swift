//
//  InqueryOptionsVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit



class InqueryOptionsVC: BaseViewController, PHPageScrollViewDataSource, PHPageScrollViewDelegate {
    @available(iOS 2.0, *)
    public func pageScrollView(_ pageScrollView: PHPageScrollView!, viewForRowAt index: Int32) -> UIView! {
        let imgBanner = UIImageView(frame: CGRect(x: 0, y: 0, width: self.pageScrollView.frame.size.width, height: self.pageScrollView.frame.size.height))
        
        imgBanner.contentMode = .scaleAspectFill
        imgBanner.clipsToBounds = true
        
        var dict: NSDictionary = [:]
        dict = arrBannerImage.object(at: Int(index)) as! NSDictionary
        
        let strImage = TO_STRING(dict["vImage"])
        let url = URL(string:strImage)
        imgBanner.sd_setImage(with: url, placeholderImage: nil)
        return imgBanner
    }
    
    


    var bannerImage = [Any]()
    var count: Int = 0
    
    @IBOutlet var viewNotificationBG: UIView!
    @IBOutlet var lblNotificationCounter: UILabel!
    @IBOutlet var viewNavigation: UIView!
    var aDictResponse = [AnyHashable: Any]()
    var arrSellerUnreadCount = [Int]()
    var arrBookedUnreadCount = [String]()
    var arrBannerImage = NSMutableArray()
    var arrSelectedID = NSMutableArray()
    @IBOutlet var pageScrollView: PHPageScrollView!
    @IBOutlet var btnPostInq: UIButton!
    @IBOutlet var btnViewQuatation: UIButton!
    @IBOutlet var btnBookedOrder: UIButton!
    @IBOutlet var ViewBookedQuatation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ViewBookedQuatation.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        viewNotificationBG.isHidden = true
        viewNotificationBG.layer.borderWidth = 2
        viewNotificationBG.layer.cornerRadius = 11
        lblNotificationCounter.textColor = UIColor.white
        viewNotificationBG.backgroundColor = UIColor.clear
        viewNotificationBG.layer.borderColor = UIColor.white.cgColor
        
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        //=========================================================//
        
        
        if _userDefault.string(forKey: "type") == "s" {
            ViewBookedQuatation.isHidden = false
            //=========================================================================//
            let dataarrCategory: Data? = _userDefault.data(forKey: "arrSelectedID")
            arrSelectedID = NSKeyedUnarchiver.unarchiveObject(with: dataarrCategory!) as! NSMutableArray
            //============================================================================//
            
            self.ApiCallForGetSelleInquiry()
            btnPostInq.setTitle("VIEW INQUIRY", for: .normal)
        }
        else {
            ViewBookedQuatation.isHidden = true
            self.ApiCallForBuyerReadUnreadCount()
            btnPostInq.setTitle("POST INQUIRY", for: .normal)
        }
        
        
        
        
        
        //For Slide Navigation
        //--------------Swipe to Left menu---------------//
        let frameTapGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.didTapLeftMenuButton))
        frameTapGesture.direction = .right
        self.view.addGestureRecognizer(frameTapGesture)
        
        
        pageScrollView.delegate = self
        pageScrollView.dataSource = self
        pageScrollView.reloadData()
        count = 0
        pageScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300)
        
        //GetBannerList
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.CallApiForGetBanner), userInfo: self, repeats: false)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if _userDefault.string(forKey: "type") == "s" {
            btnPostInq.setTitle("VIEW INQUIRY", for: .normal)
            btnBookedOrder.setTitle("VIEW BOOKED ORDER", for: .normal)
        }
        else {
            btnPostInq.setTitle("POST INQUIRY", for: .normal)
        }
        btnViewQuatation.setTitle("VIEW QUOTATION", for: .normal)
        
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.CallApiForGetNotificationCount), userInfo: self, repeats: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.OpenProfileScreenButtonTapped), name: NSNotification.Name(rawValue: "ProfileTaped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCountThedata), name: NSNotification.Name(rawValue: "CountReload"), object: nil)
    }
    
    func setCountThedata() {
        if _userDefault.string(forKey: "type") == "s" {
            self.ApiCallForGetSelleInquiry()
        }
        else {
            self.ApiCallForBuyerReadUnreadCount()
        }
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.CallApiForGetNotificationCount), userInfo: self, repeats: false)
    }
    
    
    
    // MARK: - Get Total Inquiry Api Call Method
    func ApiCallForGetSelleInquiry() {
        let strID = arrSelectedID.componentsJoined(by: ",")
        // init paramters Dictionary
        let myUrl = kBasePath + kGetSellerInquiry
        
        let param = ["iSUserID"     : _userDefault.integer(forKey: "user_id"),
                     "iSub_Cart_Id" : strID] as [String : Any]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetQuatation)
        
    }
    
    
    // MARK: - Get Total View Quatation Api Call Method
    func ApiCallForGetSellerViewQuatation() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetSellerViewQuatation
        
        let param = ["iSUserID"     : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetSellerQuatation)
        
    }
    
    // MARK: - ApiCallForBuyerReadUnreadCount Api Call Method
    func ApiCallForBuyerReadUnreadCount() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetReadUnread
        
        let param = ["iUserId"     : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameUnreadCount)
        
    }
    
    
    // MARK: - CallApiForGetNotificationCount Api Call Method
    func CallApiForGetNotificationCount() {
        // init paramters Dictionary
        let myUrl = kBasePath + kNotificationCount
        
        let param = ["iUserid"     : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameNotificationCount)
        
    }
    
    
    
    
    
    
    
    // MARK: - Get Banner Api Call Method
    func CallApiForGetBanner() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetBanner
        
        let param = ["vFor"     : _userDefault.string(forKey: "type")!]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetBanner)
    }
    
    
    // MARK: - Server Call Delegate
    override func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetBanner {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    arrBannerImage.removeAllObjects()
                    
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrBannerImage = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrBannerImage)
                        
                        self.pageScrollView.reloadData()
                        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.bannerImageSlide), userInfo: self, repeats: true)
                        
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
        
        else if name == ServerCallName.serverCallNameGetQuatation {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        let arrTatalData = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrTatalData)
                        
                        arrSellerUnreadCount.removeAll()
                        
                        for i in 0..<arrTatalData.count {
                            let dictCategory = arrTatalData[i] as! NSDictionary
                            let strID = TO_INT(dictCategory["iInqId"])
                            if arrSellerUnreadCount.contains(strID) {
                            }
                            else {
                                arrSellerUnreadCount.append(strID)
                            }
                        }
                        
                        if arrTatalData.count == 0 {
                        }
                        else {
                            if _userDefault.data(forKey: "arrSellerUnreadCount") != nil {
                                let datary: Data? = _userDefault.data(forKey: "arrSellerUnreadCount")
                                let arrIDs = NSKeyedUnarchiver.unarchiveObject(with: datary!) as! [Int]
                                if arrIDs.count == arrTatalData.count {
                                    btnPostInq.setTitle("VIEW INQUIRY", for: .normal)
                                }
                                else {
                                    let strTolCount = arrTatalData.count - arrIDs.count
                                    if strTolCount == 0 {
                                        btnPostInq.setTitle("VIEW INQUIRY", for: .normal)
                                    }
                                    else {
                                        btnPostInq.setTitle("VIEW INQUIRY" + " (" + strTolCount.description + ")", for: .normal)
                                    }
                                }
                            }
                            else {
                                //let strCount = arrSellerUnreadCount.count.description
                                //if strCount == "0" {
                                    btnPostInq.setTitle("VIEW INQUIRY", for: .normal)
//                                }
//                                else {
//                                    btnPostInq.setTitle("VIEW INQUIRY" + " (" + strCount + ")", for: .normal)
//                                }
                            }
                        }
                        
                        self.ApiCallForGetSellerViewQuatation()
                        
                        
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
            
            
        else if name == ServerCallName.serverCallNameGetSellerQuatation {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        let arrTatalBookData = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrTatalBookData)
                        
                        arrBookedUnreadCount.removeAll()
                        
                        for i in 0..<arrTatalBookData.count {
                            let dictCategory = arrTatalBookData[i] as! NSDictionary
                            let resData = dictCategory["Data"] as? NSArray
                            if resData != nil {
                                let arrSubCat = (dictCategory["Data"]! as! NSArray).mutableCopy() as! NSMutableArray
                                let dict = arrSubCat.object(at: 0) as! NSDictionary
                                let strBooked = TO_STRING(dict["vBooked"])
                                if strBooked == "Yes" {
                                    arrBookedUnreadCount.append(strBooked)
                                }
                            }
                        }
                        
                        
                        if _userDefault.data(forKey: "arrBookedUnreadCount") != nil {
                            let datary: Data? = _userDefault.data(forKey: "arrBookedUnreadCount")
                            let arrBIDs = NSKeyedUnarchiver.unarchiveObject(with: datary!) as! [String]
                            if arrBIDs.count == arrBookedUnreadCount.count {
                                btnBookedOrder.setTitle("VIEW BOOKED ORDER", for: .normal)
                            }
                            else {
                                let strTolCount = arrBookedUnreadCount.count - arrBIDs.count
                                if strTolCount == 0 {
                                    btnBookedOrder.setTitle("VIEW BOOKED ORDER", for: .normal)
                                }
                                else {
                                    btnBookedOrder.setTitle("VIEW BOOKED ORDER" + " (" + strTolCount.description + ")", for: .normal)
                                }
                            }
                        }
                            
                        else {
                            //let strBookedCount = arrBookedUnreadCount.count.description
                            //if strBookedCount == "0" {
                                btnBookedOrder.setTitle("VIEW BOOKED ORDER", for: .normal)
//                            }
//                            else {
//                                btnBookedOrder.setTitle("VIEW BOOKED ORDER" + " (" + strBookedCount + ")", for: .normal)
//                            }
                        }
                        
                        
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

            
        
        else if name == ServerCallName.serverCallNameUnreadCount {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    let resData = resposeObject["data"] as? NSDictionary
                    if resData != nil {
                        let unreadCount = TO_INT(resData?["Count"])
                        btnViewQuatation.setTitle("VIEW QUOTATION" + " (" + unreadCount.description + ")", for: .normal)
                    }
                }
                else {
                }
            }
            else {
                let strerrMsg = TO_STRING(dicData["error"])
                Constant.showAlert(title: "", message:strerrMsg)
            }
        }
        
        
        else if name == ServerCallName.serverCallNameNotificationCount {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    let resData = resposeObject["data"] as? NSDictionary
                    if resData != nil {
                        let unreadCount = TO_INT(resData?["unreadcount"])
                        if unreadCount == 0 {
                            lblNotificationCounter.text = "0"
                            viewNotificationBG.isHidden = true
                        }
                        else {
                            viewNotificationBG.isHidden = false
                            lblNotificationCounter.text = unreadCount.description
                        }
                        
                    }
                }
                else {
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
    override func ServerCallFailed(_ errorObject: String, name: ServerCallName) {
        app_Delegate.stopLoadingView()
        Constant.showAlert(title: "", message:errorObject)
    }
    

    func bannerImageSlide() {
        pageScrollView.scroll(toPage: UInt(count), animation: true)
        count += 1
        let strImageCount = "\(UInt(arrBannerImage.count))"
        let strCount = "\(UInt(count))"
        if (strImageCount == strCount) {
            count = 0
        }
    }
    
    
    func numberOfPage(in pageScrollView: PHPageScrollView) -> Int {
        return arrBannerImage.count
    }
    
    func sizeCell(for pageScrollView: PHPageScrollView) -> CGSize {
        return CGSize(width: self.pageScrollView.frame.size.width, height: self.pageScrollView.frame.size.height)
    }
    
    func pageScrollView(_ pageScrollView: PHPageScrollView, viewForRowAt index: Int) -> UIView {
        //bannerImage=[[aDictResponse objectForKey:@"result"]valueForKey:@"image"];
        let imgBanner = UIImageView(frame: CGRect(x: 0, y: 0, width: self.pageScrollView.frame.size.width, height: self.pageScrollView.frame.size.height))
        let strImage = (arrBannerImage[index] as AnyObject).value(forKey: "bimage") as? String
        //NSString *strImage = [NSString stringWithFormat:@"%@",bannerImage[index]];
        let strimgURL = "\(strImage)"
        imgBanner.setImageWith(URL(string: strimgURL), placeholderImage: nil)
        return imgBanner
    }
    
    func pageScrollView(_ pageScrollView: PHPageScrollView, didScrollToPageAt index: Int) {
        let array = "\(UInt(arrBannerImage.count))"
        let currentPageIndex = "\(self.pageScrollView.currentPageIndex + 1)"
        if (array == currentPageIndex) {
            
        }
        else {
            
        }
        if (currentPageIndex == "1") {
            
        }
    }
    
    func pageScrollView(_ pageScrollView: PHPageScrollView, didTapPageAt index: Int) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func OpenProfileScreenButtonTapped() {
        let ObjProfile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(ObjProfile, animated: true)
    }
    
    
    
    
    //-------------------Swipe To Left side-----------------//
    func didTapLeftMenuButton(_ sender: UIGestureRecognizer) {
        print("swipe left")
        let btnLeft = UIButton(type: UIButtonType.system)
        onSlideMenuButtonPressed(btnLeft)
    }
    

    // MARK: - Left Menu Display Button Method
    @IBAction func clkToLeftMenuAction(_ sender: UIButton) {
        self.onSlideMenuButtonPressed(sender)
    }
    
    
    @IBAction func clkToPostInquiryAction(_ sender: UIButton) {
        if _userDefault.string(forKey: "type") == "s" {
            let dataSave = NSKeyedArchiver.archivedData(withRootObject: arrSellerUnreadCount)
            _userDefault.set(dataSave, forKey: "arrSellerUnreadCount")
            
            let objSellerInq = self.storyboard?.instantiateViewController(withIdentifier: "SellerViewInquiryVC") as! SellerViewInquiryVC
            self.navigationController?.pushViewController(objSellerInq, animated: true)
        }
        else {
            let objCat = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
            self.navigationController?.pushViewController(objCat, animated: true)
        }
        
        
    }
    
    @IBAction func clkToViewQuatationAction(_ sender: UIButton) {
        if _userDefault.string(forKey: "type") == "s" {
            let objQuatation = self.storyboard?.instantiateViewController(withIdentifier: "ViewQuatationVC") as! ViewQuatationVC
            self.navigationController?.pushViewController(objQuatation, animated: true)
        }
        else {
            let objQuatation = self.storyboard?.instantiateViewController(withIdentifier: "QuotationListVC") as! QuotationListVC
            self.navigationController?.pushViewController(objQuatation, animated: true)
        }
    }
    
    
    @IBAction func clkToButtonNotificationAction(_ sender: UIButton) {
        lblNotificationCounter.text = "0"
        viewNotificationBG.isHidden = true
        let objNotification = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objNotification, animated: true)
    }
    
    @IBAction func clkToButtonViewBookedQuatationAction(_ sender: UIButton) {
        let dataSave = NSKeyedArchiver.archivedData(withRootObject: arrBookedUnreadCount)
        _userDefault.set(dataSave, forKey: "arrBookedUnreadCount")
        
        let objOrder = self.storyboard?.instantiateViewController(withIdentifier: "BookedOrderVC") as! BookedOrderVC
        self.navigationController?.pushViewController(objOrder, animated: true)
    }
    
    
    // MARK: - Slide Navigation Method
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    
}













  
