//
//  ForgotPasswordVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController, UITextFieldDelegate, ServerCallDelegate {

    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var viewResrt: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //TextField Placeholder
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : Constant.WhiteColor()])
                
        viewResrt.layer.borderWidth = 1
        viewResrt.layer.cornerRadius = 5
        viewResrt.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - Forgot Password Api Call Method
    func CallApiForForgotPassword() {
        // init paramters Dictionary
        let myUrl = kBasePath + kForgotPass
        
        let param = ["email"     : txtEmail.text!]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameForgotPass)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameForgotPass {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    let alertController = UIAlertController(title: "", message: strMsg, preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        self.navigationController!.popViewController(animated: false)
                        NSLog("OK Pressed")
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
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
    

    // Mark: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        
        return true
    }
    
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if isValidData() == false {
            return
        }
        else{
            self.view.endEditing(true)
            //Call Api For Login
            app_Delegate.startLoadingview("")
            self.CallApiForForgotPassword()
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}












