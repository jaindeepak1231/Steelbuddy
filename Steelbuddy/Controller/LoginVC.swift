//
//  LoginVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 30/09/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate, ServerCallDelegate {

    var strUDID = ""
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnNewUser: UIButton!
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var viewNew: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if _userDefault.bool(forKey: "loginUser") == true {
            let objHome = self.storyboard?.instantiateViewController(withIdentifier: "InqueryOptionsVC") as! InqueryOptionsVC
            self.navigationController?.pushViewController(objHome, animated: true)
        }
        
        //TextField Placeholder
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : Constant.WhiteColor()])
        
        txtPass.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
        
        viewLogin.layer.borderWidth = 1
        viewLogin.layer.cornerRadius = 5
        viewLogin.layer.borderColor = UIColor.black.cgColor
        
        viewNew.layer.borderWidth = 1
        viewNew.layer.cornerRadius = 5
        viewNew.layer.borderColor = UIColor.black.cgColor
        
        
//        if _userDefault.string(forKey: "fcm") != nil {
//            txtEmail.text = _userDefault.string(forKey: "fcm")
//        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        txtEmail.text = ""
        txtPass.text = ""
        strUDID = OpenUDID.value()
        print(strUDID);
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Login Api Call Method
    func CallApiForLogin() {
        // init paramters Dictionary
        let myUrl = kBasePath + kLogin
        
        let param = ["email"     : txtEmail.text,
                     "password"  : txtPass.text]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameLogin)
    }
    
    
    // MARK: - Login Api Call Method
    func CallApiForUpdateFCM() {
        
        var fcmToken = "1234567890IOS"
        if _userDefault.string(forKey: "fcm") != nil {
            fcmToken = _userDefault.string(forKey: "fcm")!
        }
        
        // init paramters Dictionary
        let myUrl = kBasePath + kUpdateFcm
        
        let param = ["fcmid"       : fcmToken,
                     "vmobiletype" : "ios",
                     "id"          : _userDefault.integer(forKey: "user_id")] as [String : Any]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameUpdateFCM)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameUpdateFCM {
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                }
                else {
                    Constant.showAlert(title: "Steelbuddy", message: strMsg)
                    return
                }
            }
        } 
        
        else if name == ServerCallName.serverCallNameLogin {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                   app_Delegate.stopLoadingView()
                    
                    let resData = resposeObject["data"] as? NSDictionary
                    let Otp = TO_INT(resData?["otp"])
                    let UserID = TO_INT(resData?["id"])
                    let StrType = TO_STRING(resData?["type"])
                    let StrStatus = TO_STRING(resData?["status"])
                    _userDefault.set(UserID, forKey: "user_id")
                    _userDefault.set(StrType, forKey: "type")
                    
                    if StrStatus == "inactive" {
                        let objOTP = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                        objOTP.strOpt = Otp.description
                        self.navigationController?.pushViewController(objOTP, animated: true)
                    }
                    else {
                        _userDefault.set(true, forKey: "loginUser")
                        if StrType == "s" {
                            if _userDefault.bool(forKey: "CategorySaved") == true {
                                let objInquiry = self.storyboard?.instantiateViewController(withIdentifier: "InqueryOptionsVC") as! InqueryOptionsVC
                                self.navigationController?.pushViewController(objInquiry, animated: true)
                            }
                            else {
                                let objCategory = self.storyboard?.instantiateViewController(withIdentifier: "SellerCategotyVC") as! SellerCategotyVC
                                objCategory.strScreenCheck = "FirstTime"
                                self.navigationController?.pushViewController(objCategory, animated: true)
                            }
                        }
                        else {
                            _userDefault.set(true, forKey: "loginUser")
                            let objInquiry = self.storyboard?.instantiateViewController(withIdentifier: "InqueryOptionsVC") as! InqueryOptionsVC
                            self.navigationController?.pushViewController(objInquiry, animated: true)
                        }
                    }
                    self.CallApiForUpdateFCM()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // Mark: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.font = UIFont(name: Constant.Roboto_Reg, size: 15)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            textField.resignFirstResponder()
            txtPass.becomeFirstResponder()
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Validation function
    func isValidData() -> Bool{
        if !(txtEmail?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetEmail)
            return false;
        }
        else if !(txtEmail?.text!.isEmail())!{
            Constant.showAlert(title: "", message:kEntetValidEmail)
            return false;
        }
        else if !(txtPass?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetPassword )
            return false;
        }
        
        return true
    }
    
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        if isValidData() == false {
            return
        }
        else{
            self.view.endEditing(true)
            //Call Api For Login
            app_Delegate.startLoadingview("")
            self.CallApiForLogin()
        }
    }

    @IBAction func btnNewUserAction(_ sender: UIButton) {
        let objRegister = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(objRegister, animated: true)
    }
    
    @IBAction func btnForgotPassAction(_ sender: UIButton) {
        let objRegister = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(objRegister, animated: true)
    }
}








    
  
    

