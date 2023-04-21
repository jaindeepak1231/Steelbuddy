//
//  ViewAddedInquiryVC.swift
//  Steelbuddy
//
//  Created by Gaurang Mistry on 10/10/17.
//  Copyright © 2017 deepak jain. All rights reserved.
//

import UIKit

class ViewAddedInquiryVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ServerCallDelegate {

    var strCreatedID = ""
    var strCompleted = ""
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    var arrSelectedCategory = NSMutableArray()
    
    var seconds = 4
    var timer = Timer()
    var viewForSubmit = ViewSubmitInquiry()
    
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
        tblView.register(UINib(nibName: "ViewAddedInqTableCell", bundle: nil), forCellReuseIdentifier: "ViewAddedInqTableCell")
        
        tblView.estimatedRowHeight = 120.0
        tblView.rowHeight = UITableViewAutomaticDimension
        
        print(arrSelectedCategory)
        tblView.reloadData()
    }
    
    
    func viewForSubmitInquiry() {
        app_Delegate.stopLoadingView()
        viewForSubmit = (Bundle.main.loadNibNamed("ViewSubmitInquiry", owner: self, options: nil)?.first as? ViewSubmitInquiry)!
        
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
            let home = self.storyboard?.instantiateViewController(withIdentifier: "InqueryOptionsVC") as! InqueryOptionsVC
            self.navigationController?.pushViewController(home, animated: true)
        }
        
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
        return arrSelectedCategory.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAddedInqTableCell", for: indexPath as IndexPath) as! ViewAddedInqTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        
        var dict = NSMutableDictionary()
        dict = arrSelectedCategory.object(at:indexPath.row) as! NSMutableDictionary
        if let arrSubCat = dict["addDetail"] as? NSMutableArray {
            var dictCat: NSDictionary = [:]
            if arrSubCat.count == 1 {
                dictCat = arrSubCat.object(at:0) as! NSDictionary
            }
            else {
                dictCat = arrSubCat.object(at: indexPath.row) as! NSDictionary
            }
            cell.lblCity.text = TO_STRING(dictCat["city"])
            cell.lblMake.text = TO_STRING(dictCat["make"])
            cell.lblSize.text = TO_STRING(dictCat["size"])
            cell.lblGrade.text = TO_STRING(dictCat["grade"])
            cell.lblState.text = TO_STRING(dictCat["state"])
            cell.lblQuantity.text = TO_STRING(dictCat["quantity"])
        }
        
        let strMainCategoryName = _userDefault.string(forKey: "MainCatName")
        cell.lblTitle.text = TO_STRING(dict["vSubName"]) + " - " + strMainCategoryName!
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.clkToDeleteTaped), for: .touchUpInside)
        
        return cell
            
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    
    @IBAction func clkToDeleteTaped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "You want to remove", preferredStyle: .alert)
        
        // Create the actions
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        //
        let DeleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) {
            UIAlertAction in
            NSLog("Delete Pressed")
            self.arrSelectedCategory.removeObject(at: sender.tag)
            self.tblView.reloadData()
        }
        // Add the actions
        alertController.addAction(CancelAction)
        alertController.addAction(DeleteAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    //=============================================================================================//
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
    
    
    @IBAction func clkTobtnSubmitAction(_ sender: UIButton) {
        print(arrSelectedCategory)
        if arrSelectedCategory.count == 0 {
            Constant.showAlert(title: "Steelbuddy", message: "Please select atleast one Quatation")
            return;
        }
        strCompleted = "First"
        app_Delegate.startLoadingview("")
        self.APICallForSubmitInquiry()
        
        
        //self.viewForSubmitInquiry()
        
    }
    
    func APICallForSubmitInquiry() {
        // init paramters Dictionary
        let myUrl = kBasePath + kCreateInquiry
            
        let param = ["iUserid"     : _userDefault.integer(forKey: "user_id")]
            
        print(myUrl, param)
            
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameCreateInquiry)
            
    }
    
    func APICallForInsetQuatation(MainCat_id: String, MainCat_Name: String, SubCat_Name: String, SubCat_id: String, Quantity: String, Quentity_unit: String, Size: String, Grade: String, Make: String, State: String, City: String, Inq_id: String) {
        
        // init paramters Dictionary
        let myUrl = kBasePath + kAddInquiry
        
        let param = ["iSub_Cart_Id" : SubCat_id,
                     "iInqId"       : Inq_id,
                     "vMainName"    : MainCat_Name,
                     "vSubName"     : SubCat_Name,
                     "vQty"         : Quantity,
                     "vQty_Unit"    : Quentity_unit,
                     "vSize"        : Size,
                     "vGrade"       : Grade,
                     "vMake"        : Make,
                     "vState"       : State,
                     "vCity"        : City,
                     "iUserId"      : _userDefault.string(forKey: "user_id")!]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameAddInquiry)
        
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameCreateInquiry {
            
            if ((dicData["status"]) != nil) {
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    
                    let resData = resposeObject["data"] as? NSDictionary
                    strCreatedID = TO_STRING(resData?["iId"])
                    
                    for i in 0..<arrSelectedCategory.count {
                        let dictCategory = arrSelectedCategory[i] as! NSDictionary
                        let MainCatID = _userDefault.string(forKey:  "MainCatID")
                        let MainCatNAme = _userDefault.string(forKey: "MainCatName")
                        let strSubCatID = TO_STRING(dictCategory["iId"])
                        let strSubCatName = TO_STRING(dictCategory["vSubName"])
                        if let arrSubCat = dictCategory["addDetail"] as? NSMutableArray {
                            for j in 0..<arrSubCat.count {
                                var dictiTextChange: Dictionary<String,Any> = [:]
                                dictiTextChange = arrSubCat.object(at: j) as! Dictionary<String, Any>
                                let quantity = TO_STRING(dictiTextChange["quantity"])
                                let size = TO_STRING(dictiTextChange["size"])
                                let grade = TO_STRING(dictiTextChange["grade"])
                                let make = TO_STRING(dictiTextChange["make"])
                                let state = TO_STRING(dictiTextChange["state"])
                                let city = TO_STRING(dictiTextChange["city"])
                                
                                self.APICallForInsetQuatation(MainCat_id: MainCatID!, MainCat_Name: MainCatNAme!, SubCat_Name: strSubCatName, SubCat_id: strSubCatID, Quantity: quantity, Quentity_unit: "Mt", Size: size, Grade: grade, Make: make, State: state, City: city, Inq_id: strCreatedID)
                                
                                
                            }
                        }
                    }
                    
                }
                else {
                    app_Delegate.stopLoadingView()
                    Constant.showAlert(title: "Steelbuddy", message: strMsg)
                    return
                }
            }
        }
        
        
        if name == ServerCallName.serverCallNameAddInquiry {
            if ((dicData["status"]) != nil) {
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                //let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    
                    if strCompleted == "First" {
                        strCompleted = "resonSexomd"
                        Timer.scheduledTimer(timeInterval: 0.4, target: self,   selector: (#selector(self.viewForSubmitInquiry)), userInfo: nil, repeats: false)
                    }
                }
                else {
//                    app_Delegate.stopLoadingView()
//                    Constant.showAlert(title: "Steelbuddy", message: strMsg)
//                    return
                
                }
            }
        }
        
        
    }
    
    
    // MARK: - Server Failed Delegate
    func ServerCallFailed(_ errorObject: String, name: ServerCallName) {
        app_Delegate.stopLoadingView()
        Constant.showAlert(title: "", message:errorObject)
    }
}


