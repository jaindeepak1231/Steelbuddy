//
//  CategoriesVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController, ServerCallDelegate {

    var strCatID = ""
    var strCatName = ""
    @IBOutlet var lblCat1: UILabel!
    @IBOutlet var lblCat2: UILabel!
    @IBOutlet var lblCat3: UILabel!
    
    @IBOutlet var btnCat1: UIButton!
    @IBOutlet var btnCat2: UIButton!
    @IBOutlet var btnCat3: UIButton!
    
    @IBOutlet var viewCat1: UIView!
    @IBOutlet var viewCat2: UIView!
    @IBOutlet var viewCat3: UIView!
    @IBOutlet var viewNavigation: UIView!
    var arrCategories = NSMutableArray()
    var arrSubCategories = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _userDefault.removeObject(forKey: "MainCatID")
        _userDefault.removeObject(forKey: "MainCatName")
        
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        
        viewCat1.layer.cornerRadius = 8
        viewCat1.layer.masksToBounds = true
        viewCat1.layer.shadowColor = UIColor.black.cgColor
        viewCat1.layer.shadowOpacity = 2.5
        viewCat1.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewCat1.layer.shadowRadius = 2
        
        viewCat2.layer.cornerRadius = 8
        viewCat2.layer.masksToBounds = true
        viewCat2.layer.shadowColor = UIColor.black.cgColor
        viewCat2.layer.shadowOpacity = 2.5
        viewCat2.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewCat2.layer.shadowRadius = 2
        
        viewCat3.layer.cornerRadius = 8
        viewCat3.layer.masksToBounds = true
        viewCat3.layer.shadowColor = UIColor.black.cgColor
        viewCat3.layer.shadowOpacity = 2.5
        viewCat3.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewCat3.layer.shadowRadius = 2
        //=========================================================//
        
        viewCat1.isHidden = true
        viewCat2.isHidden = true
        viewCat3.isHidden = true
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
                        
                        var dict: NSDictionary = [:]
                        dict = arrCategories.object(at: Int(0)) as! NSDictionary
                        lblCat1.text = TO_STRING(dict["vMainName"]).uppercased()
                        
                        dict = arrCategories.object(at: Int(1)) as! NSDictionary
                        lblCat2.text = TO_STRING(dict["vMainName"]).uppercased()
                        
                        dict = arrCategories.object(at: Int(2)) as! NSDictionary
                        lblCat3.text = TO_STRING(dict["vMainName"]).uppercased()
                        
                        viewCat1.isHidden = false
                        viewCat2.isHidden = false
                        viewCat3.isHidden = false
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Category Button Method
    @IBAction func clkToCat1Action(_ sender: UIButton) {
        btnCat1.isSelected = true
        btnCat2.isSelected = false
        btnCat3.isSelected = false
        var dict: NSDictionary = [:]
        dict = arrCategories.object(at: Int(0)) as! NSDictionary
        strCatID = TO_STRING(dict["iId"])
        strCatName = TO_STRING(dict["vMainName"])
        arrSubCategories = (dict["vSubName"]! as! NSArray).mutableCopy() as! NSMutableArray
        
    }
    
    @IBAction func clkToCat2Action(_ sender: UIButton) {
        btnCat1.isSelected = false
        btnCat2.isSelected = true
        btnCat3.isSelected = false
        var dict: NSDictionary = [:]
        dict = arrCategories.object(at: Int(1)) as! NSDictionary
        strCatID = TO_STRING(dict["iId"])
        strCatName = TO_STRING(dict["vMainName"])
        arrSubCategories = (dict["vSubName"]! as! NSArray).mutableCopy() as! NSMutableArray
    }
    
    @IBAction func clkToCat3Action(_ sender: UIButton) {
        btnCat1.isSelected = false
        btnCat2.isSelected = false
        btnCat3.isSelected = true
        var dict: NSDictionary = [:]
        dict = arrCategories.object(at: Int(2)) as! NSDictionary
        strCatID = TO_STRING(dict["iId"])
        strCatName = TO_STRING(dict["vMainName"])
        arrSubCategories = (dict["vSubName"]! as! NSArray).mutableCopy() as! NSMutableArray
    }
    
    @IBAction func clkTobtnSelectAction(_ sender: UIButton) {
        if strCatID == "" {
            Constant.showAlert(title: "Steelbuddy", message: "Please select category")
            return
        }
        else {
            _userDefault.set(strCatID, forKey: "MainCatID")
            _userDefault.set(strCatName, forKey: "MainCatName")
            let objSubCategory = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoriesVC") as! SubCategoriesVC
            objSubCategory.strTitle = strCatName
            objSubCategory.arrSubCategory = arrSubCategories
            self.navigationController?.pushViewController(objSubCategory, animated: true)
        }
    }
    
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}













