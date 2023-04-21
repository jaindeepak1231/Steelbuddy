//
//  OTPVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit
import APAddressBook

class OTPVC: UIViewController, ServerCallDelegate {

    var StrType = ""
    var strOpt = ""
    var contacts = [APContact]()
    let addressBook = APAddressBook()
    var arrContactData = NSMutableArray()
    @IBOutlet var viewOTP: UIView!
    @IBOutlet var viewSubmit: UIView!
    @IBOutlet var txtOTP: UITextField!
    @IBOutlet var btnSubmit: UIButton!
    
    
    // MARK: - life cycle
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        addressBook.fieldsMask = [APContactField.default, APContactField.thumbnail]
        addressBook.sortDescriptors = [NSSortDescriptor(key: "name.firstName", ascending: true),
                                       NSSortDescriptor(key: "name.lastName", ascending: true)]
        addressBook.filterBlock =
            {
                (contact: APContact) -> Bool in
                if let phones = contact.phones
                {
                    return phones.count > 0
                }
                return false
        }
        addressBook.startObserveChanges
            {
                [unowned self] in
                self.loadContacts()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        
        //For Load Contacts
        loadContacts()
        
        
        print(strOpt)
        
        
        //TextField Placeholder
        txtOTP.attributedPlaceholder = NSAttributedString(string: "Enter OTP", attributes: [NSForegroundColorAttributeName : Constant.WhiteColor()])
        
        viewOTP.layer.borderWidth = 1
        viewOTP.layer.cornerRadius = 5
        viewOTP.layer.borderColor = UIColor.white.cgColor
        
        viewSubmit.layer.borderWidth = 1
        viewSubmit.layer.cornerRadius = 5
        viewSubmit.layer.borderColor = UIColor.black.cgColor
    }

    // MARK: - Register OTP Api Call Method
    func CallApiForRegisterOTP() {
        // init paramters Dictionary
        let myUrl = kBasePath + kCheckOTP
        
        let param = ["id" : _userDefault.integer(forKey: "user_id")]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameRegisterOTP)
    }
    
    
    // MARK: - Register OTP Api Call Method
    func APICallForUploadContact() {
        // init paramters Dictionary
        //===============JSA Ques Data=============//
        var arrJSonString = ""
        if !(arrContactData.count == 0) {
            
            arrJSonString = Constant.convertArrayToJsonString(from: arrContactData)!
        }
        print(arrJSonString)
        //==========================================//
        
        let myUrl = kBasePath + kUploadContacts
        
        let param = ["contact_datalist" : arrJSonString]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameUploadContacts)
    }
    
    
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameRegisterOTP {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    
                    let resData = resposeObject["data"] as? NSDictionary
                    let UserID = TO_INT(resData?["id"])
                    StrType = TO_STRING(resData?["type"])
                    _userDefault.set(UserID, forKey: "user_id")
                    _userDefault.set(StrType, forKey: "type")
                    _userDefault.set(true, forKey: "loginUser")
                    _userDefault.set(true, forKey: "Contacts")
                    
//                    if _userDefault.bool(forKey: "Contacts") == true {
//                    }
//                    else {
                        self.APICallForUploadContact()
                   // }
                    
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
                        let objInquiry = self.storyboard?.instantiateViewController(withIdentifier: "InqueryOptionsVC") as! InqueryOptionsVC
                        self.navigationController?.pushViewController(objInquiry, animated: true)
                    }
                    
                    
                    
                    
                }
                else {
                    Constant.showAlert(title: "Steelbuddy", message: strMsg)
                    return
                }
            }
            else {
                let strerrMsg = TO_STRING(dicData["error"])
                //Constant.showAlert(title: "", message:strerrMsg)
            }
        }
        
        
        else if name == ServerCallName.serverCallNameUploadContacts {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                //let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    _userDefault.set(true, forKey: "Contacts")
                }
            }
            else {
               // let strerrMsg = TO_STRING(dicData["error"])
               // Constant.showAlert(title: "", message:strerrMsg)
            }
        }
        app_Delegate.stopLoadingView()
    }
    
    
    // MARK: - Server Failed Delegate
    func ServerCallFailed(_ errorObject: String, name: ServerCallName) {
        app_Delegate.stopLoadingView()
        //Constant.showAlert(title: "", message:errorObject)
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
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        print(txtOTP.text!)
        print(strOpt)
        if txtOTP.text! == strOpt {
            self.view.endEditing(true)
            //Call Api For Active OTP
            app_Delegate.startLoadingview("")
            self.CallApiForRegisterOTP()
            
//            _userDefault.set(true, forKey: "loginUser")
//            app_Delegate.DisplayViewControllerProcess()
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: LoginVC.self) {
//                    self.navigationController!.popToViewController(controller, animated: false)
//                    break
//                }
//            }
        }
        else {
            Constant.showAlert(title: "Steelbuddy", message: "Please Enter Correct OTP")
            return
        }
    }
    
    
    
    
    //Mark:  = For Load All Contacts
    // MARK: - private
    
    func loadContacts()
    {
        
        DispatchQueue.global(qos: .background).async {
            
            self.addressBook.loadContacts
                {
                    [unowned self] (contacts: [APContact]?, error: Error?) in
                    self.contacts = [APContact]()
                    if let contacts = contacts {
                        self.contacts = contacts
                        for i in 0..<contacts.count {
                            self.update(with: contacts[i])
                        }
                    }
                    else if let error = error {
                        print(error)
                    }
            }
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
        }
        
        
    }
    
    
    func update(with model: APContact) {
        let strName = contactName(model)
        let strMobile = contactPhones(model)
        print(strName)
        print(strMobile)
        
        let param = ["name" : strName,
                     "phonenumber" : strMobile]
        arrContactData.add(param)
    }
    
    
    // MARK: - prviate
    
    func contactName(_ contact :APContact) -> String {
        if let firstName = contact.name?.firstName, let lastName = contact.name?.lastName {
            return "\(firstName) \(lastName)"
        }
        else if let firstName = contact.name?.firstName {
            return "\(firstName)"
        }
        else if let lastName = contact.name?.lastName {
            return "\(lastName)"
        }
        else {
            return "Unnamed contact"
        }
    }
    
    func contactPhones(_ contact :APContact) -> String {
        if let phones = contact.phones {
            var phonesString = ""
            for phone in phones {
                if let number = phone.number {
                    phonesString = number
                }
            }
            return phonesString
        }
        return "No phone"
    }

}





