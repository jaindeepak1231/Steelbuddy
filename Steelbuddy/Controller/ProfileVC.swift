//
//  ProfileVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, ServerCallDelegate {

    var strPassword = ""
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblCompanyName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblCuntry: UILabel!
    @IBOutlet var lblMobile: UILabel!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtCompanyName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtgstNo: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var txtCuntry: UITextField!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var viewRegister: UIView!
    @IBOutlet var btnEditProfile: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraint_ViewBottomHeight: NSLayoutConstraint!
    var arrProfileData = NSMutableArray()
    
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
        
        
        lblName.isHidden = true
        lblCompanyName.isHidden = true
        lblEmail.isHidden = true
        lblAddress.isHidden = true
        lblCity.isHidden = true
        lblState.isHidden = true
        lblCuntry.isHidden = true
        lblMobile.isHidden = true
        txtName.isUserInteractionEnabled = false
        txtCompanyName.isUserInteractionEnabled = false
        txtEmail.isUserInteractionEnabled = false
        txtgstNo.isUserInteractionEnabled = false
        txtAddress.isUserInteractionEnabled = false
        txtCity.isUserInteractionEnabled = false
        txtState.isUserInteractionEnabled = false
        txtCuntry.isUserInteractionEnabled = false
        txtMobile.isUserInteractionEnabled = false
        
        //GetProfileData
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.CallApiForGetProfileData), userInfo: self, repeats: false)
    }

    // MARK: - Get Profile Data Api Call Method
    func CallApiForGetProfileData() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetProfile
        
        let param = ["id"     : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetProfile)
    }
    
    
    // MARK: - Update Profile Data Api Call Method
    func CallApiForUpdateProfileData() {
        // init paramters Dictionary
        let myUrl = kBasePath + kUpdateProfile
        
        let param = ["name"         : txtName.text!,
                     "company_name" : txtCompanyName.text!,
                     "address"      : txtAddress.text!,
                     "city"         : txtCity.text!,
                     "state"        : txtState.text!,
                     "country"      : txtCuntry.text!,
                     "password"     : strPassword,
                     "mobile"       : txtMobile.text!,
                     "vGstNo"       : txtgstNo.text!,
                     "id"           : _userDefault.integer(forKey: "user_id")] as [String : Any]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameUpdateProfile)
    }
    
    
    
    
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetProfile {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    arrProfileData.removeAllObjects()
                    
                    let resData = resposeObject["data"] as? NSDictionary
                    if resData != nil {
                        lblName.isHidden = false
                        lblCompanyName.isHidden = false
                        lblEmail.isHidden = false
                        lblAddress.isHidden = false
                        lblCity.isHidden = false
                        lblState.isHidden = false
                        lblCuntry.isHidden = false
                        lblMobile.isHidden = false
                        
                        txtName.text = TO_STRING(resData?["name"])
                        txtCompanyName.text = TO_STRING(resData?["company_name"])
                        txtEmail.text = TO_STRING(resData?["email"])
                        txtAddress.text = TO_STRING(resData?["address"])
                        txtCity.text = TO_STRING(resData?["city"])
                        txtState.text = TO_STRING(resData?["state"])
                        txtCuntry.text = TO_STRING(resData?["country"])
                        txtMobile.text = TO_STRING(resData?["mobile"])
                        txtgstNo.text = TO_STRING(resData?["vGstNo"])
                        strPassword = TO_STRING(resData?["password"])
                        
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
        
        if name == ServerCallName.serverCallNameUpdateProfile {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    Constant.showAlert(title: "Steelbuddy", message: strMsg)
                    btnEditProfile.setTitle("EDIT PROFILE", for: .normal)
                    txtName.isUserInteractionEnabled = false
                    txtCompanyName.isUserInteractionEnabled = false
                    txtEmail.isUserInteractionEnabled = false
                    txtAddress.isUserInteractionEnabled = false
                    txtCity.isUserInteractionEnabled = false
                    txtState.isUserInteractionEnabled = false
                    txtCuntry.isUserInteractionEnabled = false
                    txtMobile.isUserInteractionEnabled = false
                    txtgstNo.isUserInteractionEnabled = false
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
    
    

    
    @IBAction func btnEditProfileAction(_ sender: UIButton) {
        if btnEditProfile.titleLabel?.text == "EDIT PROFILE" {
            btnEditProfile.setTitle("Save", for: .normal)
            txtName.isUserInteractionEnabled = true
            txtCompanyName.isUserInteractionEnabled = true
            txtAddress.isUserInteractionEnabled = true
            txtCity.isUserInteractionEnabled = true
            txtState.isUserInteractionEnabled = true
            txtCuntry.isUserInteractionEnabled = true
            txtMobile.isUserInteractionEnabled = true
            txtgstNo.isUserInteractionEnabled = true
            txtName.becomeFirstResponder()
        }
        else {
            app_Delegate.startLoadingview("")
            self.CallApiForUpdateProfileData()
        }
    }
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}






    




