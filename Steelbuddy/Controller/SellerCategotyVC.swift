//
//  SellerCategotyVC.swift
//  Steelbuddy
//
//  Created by deepak jain on 11/10/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class SellerCategotyVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {

    var strScreenCheck = ""
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var constraint_btnBack_width: NSLayoutConstraint!
    var arrSelectedID = NSMutableArray()
    var arrCategories = NSMutableArray()
    var arrSelectedIndex = [Int]()
    var arrOpenExpendCellSections = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        
        //=========================================================================================//
        
        if strScreenCheck == "FirstTime" {
            lblTitle.text = "CATEGORIES"
            constraint_btnBack_width.constant = 0
            arrSelectedIndex.removeAll()
            arrSelectedID.removeAllObjects()
            arrOpenExpendCellSections.removeAll()
            
        }
        else {
            lblTitle.text = "Edit Category"
            constraint_btnBack_width.constant = 32
            let dataarrCategory: Data? = _userDefault.data(forKey: "arrSelectedID")
            arrSelectedID = NSKeyedUnarchiver.unarchiveObject(with: dataarrCategory!) as! NSMutableArray
            
            let dataIndexCategory: Data? = _userDefault.data(forKey: "arrSelectedIndex")
            arrOpenExpendCellSections = NSKeyedUnarchiver.unarchiveObject(with: dataIndexCategory!) as! [Int]
        }
        
        //=========================================================================================//
        
        
        //Table Cell Register
        tblView.register(UINib(nibName: "MainCategotyTableCell", bundle: nil), forCellReuseIdentifier: "MainCategotyTableCell")
        
        tblView.register(UINib(nibName: "SubCategoryTableCell", bundle: nil), forCellReuseIdentifier: "SubCategoryTableCell")
        
        
        
        tblView.estimatedRowHeight = 120.0
        tblView.rowHeight = UITableViewAutomaticDimension
        
        //=======================================================================================//
        
        
        app_Delegate.startLoadingview("")
        self.ApiCallForGetCategories()
    }
    
    // MARK: - Get Categories Api Call Method
    func ApiCallForGetCategories() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetCategory
        
        print(myUrl)
        
        ServerCall.sharedInstance.requestWithURL(.POST, urlString: myUrl, delegate: self, name: .serverCallNameGetCategories)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetCategories {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    arrCategories.removeAllObjects()
                    
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrCategories = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrCategories)
                        
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
    
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return arrCategories.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if arrOpenExpendCellSections.contains(section) {
            let dictCategory = arrCategories[section] as! NSDictionary
            let resData = dictCategory["vSubName"] as? NSArray
            if resData != nil {
                let arrSubCat = (dictCategory["vSubName"]! as! NSArray).mutableCopy() as! NSMutableArray
                return arrSubCat.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCategotyTableCell") as? MainCategotyTableCell else {
            return UIView()
        }
        
        cell.contentView.backgroundColor = UIColor.white
        
        let dict = arrCategories[section] as! NSDictionary
        cell.viewBG.layer.masksToBounds = false
        cell.viewBG.layer.shadowColor = UIColor.black.cgColor
        cell.viewBG.layer.shadowOpacity = 2.5
        cell.viewBG.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.viewBG.layer.shadowRadius = 2
        
        let strCatTitle = TO_STRING(dict["vMainName"])
        cell.lblCat.text = strCatTitle
        
        
        cell.btnOpenCat.tag = section
        cell.btnOpenCat.addTarget(self, action: #selector(self.clkToDropDownOpenSelection), for: .touchUpInside)
        
        
        
        return cell.contentView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableCell", for: indexPath as IndexPath) as! SubCategoryTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        let dictCategory = arrCategories[indexPath.section] as! NSDictionary
        let resData = dictCategory["vSubName"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["vSubName"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            var dict: NSDictionary = [:]
            dict = arrSubCat.object(at:indexPath.row) as! NSDictionary
            cell.lblTitle.text = TO_STRING(dict["vSubName"])
            
            let strCatID = TO_INT(dict["iId"])
            if arrSelectedID.contains(strCatID) {
                cell.btnCheck.isSelected = true
            }
            else {
                cell.btnCheck.isSelected = false
            }
            
        }
        
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(self.clkToButtonCheckTaped), for: .touchUpInside)
        
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    @IBAction func clkToDropDownOpenSelection(_ sender: UIButton) {
        if arrOpenExpendCellSections.contains(sender.tag) {
            if let index = arrOpenExpendCellSections.index(of:sender.tag) {
                arrOpenExpendCellSections.remove(at: index)
            }
        }
        else {
            arrOpenExpendCellSections.append(sender.tag)
        }
        
        tblView.reloadData()
    }
    
    @IBAction func clkToButtonCheckTaped(_ sender: UIButton) {
        let btnCheck = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnCheck)!
        let dictCategory = arrCategories[index.section] as! NSDictionary
        let resData = dictCategory["vSubName"] as? NSArray
        if resData != nil {
            let arrSubCat = (dictCategory["vSubName"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            var dict: NSDictionary = [:]
            dict = arrSubCat.object(at:index.row) as! NSDictionary
            let strSelectedID = TO_INT(dict["iId"])
            
            if sender.isSelected == true {
                sender.isSelected = false
                arrSelectedID.remove(strSelectedID)
            }
            else {
                sender.isSelected = true
                arrSelectedID.add(strSelectedID)
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
    @IBAction func btnBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clkTobtnSelectAction(_ sender: UIButton) {
        if arrSelectedID.count == 0 {
            Constant.showAlert(title: "Steelbuddy", message: "Please select atleast one category")
            return;
        }
        
        for i in 0..<arrCategories.count {
            let dictCategory = arrCategories[i] as! NSDictionary
            let resData = dictCategory["vSubName"] as? NSArray
            if resData != nil {
                let arrSubCat = (dictCategory["vSubName"]! as! NSArray).mutableCopy() as! NSMutableArray
                
                for j in 0..<arrSubCat.count {
                    var dict: NSDictionary = [:]
                    dict = arrSubCat.object(at: j) as! NSDictionary
                    let strCatID = TO_INT(dict["iId"])
                    
                    if arrSelectedID.contains(strCatID) {
                        if arrSelectedIndex.contains(i) {
                        }
                        else {
                            arrSelectedIndex.append(i)
                        }
                    }
                }
            }
        }
        print(arrSelectedIndex)
        
        _userDefault.set(true, forKey: "CategorySaved")
        
        let dataSave = NSKeyedArchiver.archivedData(withRootObject: arrSelectedID)
        _userDefault.set(dataSave, forKey: "arrSelectedID")
        
        let dataIndex = NSKeyedArchiver.archivedData(withRootObject: arrSelectedIndex)
        _userDefault.set(dataIndex, forKey: "arrSelectedIndex")
        
        if strScreenCheck == "FirstTime" {
            let objHome = self.storyboard?.instantiateViewController(withIdentifier: "InqueryOptionsVC") as! InqueryOptionsVC
            self.navigationController?.pushViewController(objHome, animated: true)
        }
        else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

}









  
    







