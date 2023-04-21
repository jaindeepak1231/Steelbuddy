//
//  ContactusVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit

class ContactusVC: UIViewController, ServerCallDelegate {

    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraint_ViewBottomHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblDetail.text = ""
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        //=========================================================//
        
        app_Delegate.startLoadingview("")
        self.APICallForGetContactUS()
    }
    
    
    // MARK: - Contact Api Call Method
    func APICallForGetContactUS() {
        // init paramters Dictionary
        let myUrl = kBasePath + kAboutUs
        
        print(myUrl)
        
        ServerCall.sharedInstance.requestWithURL(.GET, urlString: myUrl, delegate: self, name: .serverCallNameContactUs)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameContactUs {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    let resData = resposeObject["data"] as? NSDictionary
                    let StrDetail = TO_STRING(resData?["vDetails"])
                    lblDetail.text = StrDetail
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
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToLeftMenuAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
















