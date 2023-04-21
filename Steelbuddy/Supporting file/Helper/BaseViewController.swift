//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import StoreKit

class BaseViewController: UIViewController, SlideMenuDelegate, UIAlertViewDelegate, ServerCallDelegate {
    
    var navigationControler: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        //let topViewController : UIViewController = self.navigationController!.topViewController!
        //print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Profile\n", terminator: "")
            self.openViewControllerBasedOnIdentifier("ProfileVC")
            break
            
        case 1:
            print("Send Inquiry\n", terminator: "")
            if _userDefault.string(forKey: "type") == "b" {
                self.openViewControllerBasedOnIdentifier("AllSendInquiryVC")
            }
            else if _userDefault.string(forKey: "type") == "s" {
                self.openViewControllerBasedOnIdentifier("SellerCategotyVC")
            }
            break
        case 2:
            print("View Quotation\n", terminator: "")
            if _userDefault.string(forKey: "type") == "b" {
                self.openViewControllerBasedOnIdentifier("QuotationListVC")
            }
            else if _userDefault.string(forKey: "type") == "s" {
                self.openViewControllerBasedOnIdentifier("ViewQuatationVC")
            }
            
            break
            
        case 3:
            print("Chat\n", terminator: "")
            self.openViewControllerBasedOnIdentifier("ChatListVC")
            break
            
        case 4:
            print("Contact Us\n", terminator: "")
            if _userDefault.string(forKey: "type") == "b" {
                self.openViewControllerBasedOnIdentifier("ContactusVC")
            }
            else if _userDefault.string(forKey: "type") == "s" {
                self.openViewControllerBasedOnIdentifier("BookedOrderVC")
            }
            break
            
        case 5:
            print("Log Out\n", terminator: "")
            if _userDefault.string(forKey: "type") == "b" {
                self.CallApiForUpdateFCM()
                _userDefault.set(false, forKey: "loginUser")
                _userDefault.set(false, forKey: "CategorySaved")
                self.openViewControllerBasedOnIdentifier("LoginVC")
            }
            else if _userDefault.string(forKey: "type") == "s" {
                self.openViewControllerBasedOnIdentifier("ContactusVC")
            }
            break
        case 6:
            print("Log Out\n", terminator: "")
            if _userDefault.string(forKey: "type") == "b" {
            }
            else if _userDefault.string(forKey: "type") == "s" {
                self.CallApiForUpdateFCM()
                _userDefault.set(false, forKey: "loginUser")
                _userDefault.set(false, forKey: "CategorySaved")
                _userDefault.removeObject(forKey: "arrSellerUnreadCount")
                _userDefault.removeObject(forKey: "arrBookedUnreadCount")
                self.openViewControllerBasedOnIdentifier("LoginVC")
            }
            break
            
            
        default:
            print("default\n", terminator: "")
        }
    }
    
    
    
    // MARK: - Login Api Call Method
    func CallApiForUpdateFCM() {
    
        // init paramters Dictionary
        let myUrl = kBasePath + kUpdateFcm
        
        let param = ["fcmid"       : "",
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
        
        app_Delegate.stopLoadingView()
    }
    
    
    // MARK: - Server Failed Delegate
    func ServerCallFailed(_ errorObject: String, name: ServerCallName) {
        app_Delegate.stopLoadingView()
        Constant.showAlert(title: "", message:errorObject)
    }

    
    
    func openHomeViewControllerBasedOnIdentifier(_ strIdentifier:String){

        let storyboard = self.storyboard!
        let PassOBj = storyboard.instantiateViewController(withIdentifier: strIdentifier)
        self.preseb(PassOBj, animated: true, completion: { _ in })
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
            self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
       
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            //self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : LeftMenuVC = self.storyboard!.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
        
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.providesPresentationContextTransitionStyle = true
        menuVC.definesPresentationContext = true
        menuVC.view.backgroundColor=UIColor.clear
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
    }
    
    
    
    
    
//    func ButtonLoginLogOutTapped() {
//    
//        if (UserDefaults.standard.value(forKeyPath: "user_id") != nil) {
//            print("LogOut button tapped")
//            if AppSingleton.connectedToNetwork() {
//                Global.sharedInstance.showLoader()
//                Global.sharedInstance.getSQLDatabaseTableDataData()
//                //Global.sharedInstance.WebserviceForPostData()
//                UserDefaults.standard.setValue(nil, forKey: "user_id")
//                UserDefaults.standard.set(false, forKey: "loginUser")
//                let isDeleteQuote = ModelManager.getInstance().deleteQuoteListTable()
//                let isDeleteImageAlbum = ModelManager.getInstance().deleteImageAlbumTable()
//                let isDeleteQuoteTitle = ModelManager.getInstance().deleteQuoteTitleTable()
//                let isDeleteOnlineQuote = ModelManager.getInstance().deleteGetOnlineQuoteTable()
//                let isDeleteTableData   = ModelManager.getInstance().DeleteActionTableData()
//                let isDeleteRandomTableData   = ModelManager.getInstance().DeleteRandomTableData()
//                let isDeleteReminderTableData   = ModelManager.getInstance().DeleteReminderTableData()
//                print(isDeleteQuote)
//                print(isDeleteImageAlbum)
//                print(isDeleteQuoteTitle)
//                print(isDeleteOnlineQuote)
//                print(isDeleteTableData)
//                print(isDeleteRandomTableData)
//                print(isDeleteReminderTableData)
//                self.openViewControllerBasedOnIdentifier("LoginVC")
//                Global.sharedInstance.hideLoader()
//            }
//            else {
//                Global.sharedInstance.showToast(toastMessage: "Please check your internet connection.")
//            }
//        }
//        else {
//            UserDefaults.standard.set(false, forKey: "loginUser")
//            let isDeleteQuote = ModelManager.getInstance().deleteQuoteListTable()
//            let isDeleteImageAlbum = ModelManager.getInstance().deleteImageAlbumTable()
//            let isDeleteQuoteTitle = ModelManager.getInstance().deleteQuoteTitleTable()
//            let isDeleteOnlineQuote = ModelManager.getInstance().deleteGetOnlineQuoteTable()
//            let isDeleteTableData   = ModelManager.getInstance().DeleteActionTableData()
//            let isDeleteRandomTableData   = ModelManager.getInstance().DeleteRandomTableData()
//            let isDeleteReminderTableData   = ModelManager.getInstance().DeleteReminderTableData()
//            print(isDeleteQuote)
//            print(isDeleteImageAlbum)
//            print(isDeleteQuoteTitle)
//            print(isDeleteOnlineQuote)
//            print(isDeleteTableData)
//            print(isDeleteRandomTableData)
//            print(isDeleteReminderTableData)
//            print("login button Tapped")
//            Global.sharedInstance.showLoader()
//            UserDefaults.standard.setValue(nil, forKey: "user_id")
//            self.openViewControllerBasedOnIdentifier("LoginVC")
//            Global.sharedInstance.hideLoader()
//        }
//    }
    
    
//    func ButtonUnlimitedCollectionTapped() {
//        let utf8str = "unlmted_cln".data(using: String.Encoding.utf8)
//        let str = (utf8str?.base64EncodedString())!
//        print("Encoded:  \(str)")
//        let strshere = (UserDefaults.standard.value(forKey: "activation_code") as! String)
//        let strURL = strshere+":"+str
//        if AppSingleton.connectedToNetwork() {
//            let strURL = ShareLink+strURL
//            
//            let shareItems: [Any] = [strURL]
//            let avc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
//            //if iPhone
//            if UI_USER_INTERFACE_IDIOM() == .phone {
//                self.present(avc, animated: true, completion: { _ in })
//            }
//            else {
//                // Change Rect to position Popover
//                let popup = UIPopoverController(contentViewController: avc)
//                popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
//            }
//        }
//        else {
//            Global.sharedInstance.showToast(toastMessage: "Please check your internet connection.")
//        }
//    }
//    
//    func ButtonUnlimitedImageTapped() {
//        let utf8str = "unlmted_img".data(using: String.Encoding.utf8)
//        let str = (utf8str?.base64EncodedString())!
//        print("Encoded:  \(str)")
//        let strshere = (UserDefaults.standard.value(forKey: "activation_code") as! String)
//        let strURL = strshere+":"+str
//        if AppSingleton.connectedToNetwork() {
//            let strURL = ShareLink+strURL
//            
//            let shareItems: [Any] = [strURL]
//            let avc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
//            //if iPhone
//            if UI_USER_INTERFACE_IDIOM() == .phone {
//                self.present(avc, animated: true, completion: { _ in })
//            }
//            else {
//                // Change Rect to position Popover
//                let popup = UIPopoverController(contentViewController: avc)
//                popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
//            }
//        }
//        else {
//            Global.sharedInstance.showToast(toastMessage: "Please check your internet connection.")
//        }
//    }
//    
//    
//    func ButtonUndoLastQuoteTapped() {
//        let utf8str = "undo_lst_qot".data(using: String.Encoding.utf8)
//        let str = (utf8str?.base64EncodedString())!
//        print("Encoded:  \(str)")
//        let strshere = (UserDefaults.standard.value(forKey: "activation_code") as! String)
//        let strURL = strshere+":"+str
//        if AppSingleton.connectedToNetwork() {
//            let strURL = ShareLink+strURL
//            
//            let shareItems: [Any] = [strURL]
//            let avc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
//            //if iPhone
//            if UI_USER_INTERFACE_IDIOM() == .phone {
//                self.present(avc, animated: true, completion: { _ in })
//            }
//            else {
//                // Change Rect to position Popover
//                let popup = UIPopoverController(contentViewController: avc)
//                popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
//            }
//        }
//        else {
//            Global.sharedInstance.showToast(toastMessage: "Please check your internet connection.")
//        }
//    }
    
    
    
    
    
    
}


