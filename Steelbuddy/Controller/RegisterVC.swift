//
//  RegisterVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit


class RegisterVC: UIViewController, UITextFieldDelegate, ServerCallDelegate, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var strAddress = ""
    var strAcceptTerms = ""
    var strBuyerSeller = ""
    var arrMain = [String]()
    @IBOutlet var tblView: UITableView!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtCompanyName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtgstNo: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var txtCuntry: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var btnTermsConditionNewUser: UIButton!
    @IBOutlet var viewRegister: UIView!
    @IBOutlet var btnCheck: UIButton!
    @IBOutlet var btnBuyer: UIButton!
    @IBOutlet var viewBuyer: UIView!
    @IBOutlet var viewSeller: UIView!
    @IBOutlet var btnSeller: UIButton!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraint_ViewBottomHeight: NSLayoutConstraint!
    @IBOutlet var constraint_bottom_Constant: NSLayoutConstraint!
    
    var viewForDisplayPDF = ViewPDF()
    
    
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        strAcceptTerms = "Blank"
        
        
        //TextField Placeholder
        txtName.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
        
        txtCompanyName.attributedPlaceholder = NSAttributedString(string: "Company Name", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
        
        txtgstNo.attributedPlaceholder = NSAttributedString(string: "GST Number", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
        
        txtAddress.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
        
        txtCity.attributedPlaceholder = NSAttributedString(string: "City", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
        
        txtState.attributedPlaceholder = NSAttributedString(string: "STATE", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
        
        txtCuntry.attributedPlaceholder = NSAttributedString(string: "COUNTRY", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
        
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
        
        txtMobile.attributedPlaceholder = NSAttributedString(string: "Mobile No", attributes: [NSForegroundColorAttributeName: Constant.WhiteColor()])
      
//====================================================================================================//
        // Add a bottomBorder.
        viewBuyer.layer.masksToBounds = false
        viewBuyer.layer.shadowColor = UIColor.black.cgColor
        viewBuyer.layer.shadowOpacity = 2.5
        viewBuyer.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewBuyer.layer.shadowRadius = 2
        
        viewSeller.layer.masksToBounds = false
        viewSeller.layer.shadowColor = UIColor.black.cgColor
        viewSeller.layer.shadowOpacity = 2.5
        viewSeller.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewSeller.layer.shadowRadius = 2
        
        tblView.layer.masksToBounds = false
        tblView.layer.shadowColor = UIColor.black.cgColor
        tblView.layer.shadowOpacity = 2.5
        tblView.layer.shadowOffset = CGSize(width: -1, height: 1)
        tblView.layer.shadowRadius = 2
//====================================================================================================//
        
        viewRegister.layer.borderWidth = 1
        viewRegister.layer.cornerRadius = 5
        viewRegister.layer.borderColor = UIColor.black.cgColor
        
        strBuyerSeller = ""
        
        tblView.isHidden = true
        
        //For Search
        txtCity.delegate = self
        txtCity.addTarget(self, action: #selector(self.txtSearchCityData), for: .editingChanged)
        
        txtState.delegate = self
        txtState.addTarget(self, action: #selector(self.txtSearchStateData), for: .editingChanged)
        
        txtCuntry.delegate = self
        txtCuntry.addTarget(self, action: #selector(self.txtSearchCountryData), for: .editingChanged)
        
        tblView.register(UINib(nibName: "CityStateTableCell", bundle: nil), forCellReuseIdentifier: "CityStateTableCell")
        
        tblView.estimatedRowHeight = 60.0
        tblView.rowHeight = UITableViewAutomaticDimension
//        btnBuyer.backgroundColor = UIColor.red
//        btnSeller.backgroundColor = UIColor.white
    }
    
    func TermsConditionView() {
        viewForDisplayPDF = (Bundle.main.loadNibNamed("ViewPDF", owner: self, options: nil)?.first as? ViewPDF)!
        
        viewForDisplayPDF.frame = CGRect(x: CGFloat(0), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        viewForDisplayPDF.btnBack.addTarget(self, action: #selector(self.clkToRemoveViewAction), for: .touchUpInside)
        
        viewForDisplayPDF.webView.delegate = self
        app_Delegate.startLoadingview("")
        if let pdf = Bundle.main.url(forResource: "test", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            viewForDisplayPDF.webView.loadRequest(req as URLRequest)
        }
        
        self.view.addSubview(viewForDisplayPDF)
        self.view.bringSubview(toFront: viewForDisplayPDF)
    }
    

    
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    
    func txtSearchCityData() {
        if (txtCity.text == "") {
            tblView.isHidden = true
        }
        else {
            constraint_bottom_Constant.constant = 46
            let str: String = txtCity.text!
            methodSearch(str)
        }
    }
    
    func methodSearch(_ searchText: String) {
        arrMain.removeAll()
        strAddress = "City"
        let Predicate = NSPredicate(format: "SELF contains[c] %@", searchText)
        print("\(Predicate)")
        for i in 0..<app_Delegate.arrCity.count {
            let strCity = app_Delegate.arrCity[i]
            if (strCity as NSString).range(of: txtCity.text!, options: .caseInsensitive).location != NSNotFound {
                arrMain.append(strCity)
                tblView.isHidden = false
                tblView.reloadData()
            }
        }
    }
    
    //===============STATE======================================//
    func txtSearchStateData() {
        if (txtState.text == "") {
            tblView.isHidden = true
        }
        else {
            constraint_bottom_Constant.constant = -12
            let str: String = txtState.text!
            methodStateSearch(str)
        }
    }
    
    func methodStateSearch(_ searchText: String) {
        arrMain.removeAll()
        strAddress = "State"
        let Predicate = NSPredicate(format: "SELF contains[c] %@", searchText)
        print("\(Predicate)")
        for i in 0..<app_Delegate.arrState.count {
            let strState = app_Delegate.arrState[i]
            if (strState as NSString).range(of: txtState.text!, options: .caseInsensitive).location != NSNotFound {
                arrMain.append(strState)
                tblView.isHidden = false
                tblView.reloadData()
            }
        }
    }
    //===============================================================//
    
    //================++++++++Country===============================//
    func txtSearchCountryData() {
        if (txtCuntry.text == "") {
            tblView.isHidden = true
        }
        else {
            constraint_bottom_Constant.constant = -72
            let str: String = txtCuntry.text!
            methodCountrySearch(str)
        }
    }
    
    func methodCountrySearch(_ searchText: String) {
        arrMain.removeAll()
        strAddress = "Country"
        let Predicate = NSPredicate(format: "SELF contains[c] %@", searchText)
        print("\(Predicate)")
        for i in 0..<app_Delegate.arrCountry.count {
            let strCountry = app_Delegate.arrCountry[i]
            if (strCountry as NSString).range(of: txtCuntry.text!, options: .caseInsensitive).location != NSNotFound {
                arrMain.append(strCountry)
                tblView.isHidden = false
                tblView.reloadData()
            }
        }
    }
    //====================================================================//
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : - WebView Delegate Method
    func webViewDidFinishLoad(_ webView: UIWebView) {
        app_Delegate.stopLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if _userDefault.string(forKey: "fcm") != nil {
//            txtEmail.text = _userDefault.string(forKey: "fcm")!
//        }
        // Navigation Controller Changes
        // Listen for keyboard appearances and disappearances
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    // MARK :- Keyboard Did Show
    func keyboardDidShow(_ notif: Notification) {
        // Do something here
        let userInfo:NSDictionary = notif.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        constraint_ViewBottomHeight.constant = 775 + keyboardHeight
        
    }
    
    //MARK : - Keyboard Hide
    func keyboardDidHide(_ notif: Notification) {
        // Do something here
        constraint_ViewBottomHeight.constant = 775
    }
    
    
    // MARK: - Register Api Call Method
    func CallApiForRegisterUser() {
        var fcmToken = "1234567890IOS"
        if _userDefault.string(forKey: "fcm") != nil {
            fcmToken = _userDefault.string(forKey: "fcm")!
        }
        
        // init paramters Dictionary
        let myUrl = kBasePath + kRegister
        
        let param = ["fcmid"        : fcmToken,
                     "name"         : txtName.text!,
                     "company_name" : txtCompanyName.text!,
                     "email"        : txtEmail.text!,
                     "address"      : txtAddress.text!,
                     "city"         : txtCity.text!,
                     "state"        : txtState.text!,
                     "country"      : txtCuntry.text!,
                     "password"     : txtPassword.text!,
                     "mobile"       : txtMobile.text!,
                     "vGstNo"       : txtgstNo.text!,
                     "type"         : strBuyerSeller]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameRegister)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameRegister {
            
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
                    
                    _userDefault.set(UserID, forKey: "user_id")
                    _userDefault.set(StrType, forKey: "type")

                    let alertController = UIAlertController(title: "", message: strMsg, preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                        let objOTP = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                        objOTP.strOpt = String(describing: Otp)
                        self.navigationController?.pushViewController(objOTP, animated: true)
                        
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


    //=====================================================================================//
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrMain.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityStateTableCell", for: indexPath as IndexPath) as! CityStateTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.lblTitle.text = arrMain[indexPath.row]
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if strAddress == "City" {
            txtCity.text = arrMain[indexPath.row]
        }
        if strAddress == "State" {
            txtState.text = arrMain[indexPath.row]
        }
        if strAddress == "Country" {
            txtCuntry.text = arrMain[indexPath.row]
        }
        tblView.isHidden = true
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == txtMobile{
            return checkEnglishPhoneNumberFormat(string: string, str: str)
        }
        else {
            return true
        }
    }
    
    // Mark: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tblView.isHidden = true
        if textField == txtName {
            textField.resignFirstResponder()
            txtCompanyName.becomeFirstResponder()
            return false
        }
        if textField == txtCompanyName {
            textField.resignFirstResponder()
            txtEmail.becomeFirstResponder()
            return false
        }
        if textField == txtEmail {
            textField.resignFirstResponder()
            txtgstNo.becomeFirstResponder()
            return false
        }
        if textField == txtgstNo {
            textField.resignFirstResponder()
            txtAddress.becomeFirstResponder()
            return false
        }
        if textField == txtAddress {
            textField.resignFirstResponder()
            txtCity.becomeFirstResponder()
            return false
        }
        if textField == txtCity {
            textField.resignFirstResponder()
            txtState.becomeFirstResponder()
            return false
        }
        if textField == txtState {
            textField.resignFirstResponder()
            txtCuntry.becomeFirstResponder()
            return false
        }
        if textField == txtCuntry {
            textField.resignFirstResponder()
            txtPassword.becomeFirstResponder()
            return false
        }
        if textField == txtPassword {
            textField.resignFirstResponder()
            txtMobile.becomeFirstResponder()
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tblView.isHidden = true
    }
    
    
    // MARK: - Validation function
    func isValidData() -> Bool{
        if strBuyerSeller == "" {
            Constant.showAlert(title: "", message:kEntetSlectRole)
            return false;
        }
        if !(txtName?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetName)
            return false;
        }
        if !(txtCompanyName?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetCompanyName)
            return false;
        }
        if !(txtEmail?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetEmail)
            return false;
        }
        else if !(txtEmail?.text!.isEmail())!{
            Constant.showAlert(title: "", message:kEntetValidEmail)
            return false;
        }
        if !(txtgstNo?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetGSTNo)
            return false;
        }
        if !(txtAddress?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetAddress)
            return false;
        }
        if !(txtCity?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetCity)
            return false;
        }
        if !(txtState?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEnterState)
            return false;
        }
        if !(txtCuntry?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetCountry)
            return false;
        }
        else if !(txtPassword?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetPassword )
            return false;
        }
        else if !((txtPassword?.text?.characters.count)! > 5){
            Constant.showAlert(title: "", message:kEntetMinCharacterPassword )
            return false;
        }
        else if !(txtMobile?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetMobile )
            return false;
        }
        else if !((txtMobile?.text?.characters.count)! > 9){
            Constant.showAlert(title: "", message:kEntetValidMobile )
            return false;
        }
        else if strAcceptTerms == "Blank" {
            Constant.showAlert(title: "", message:kAcceptTerms )
            return false;
        }
        
        return true
    }
    
    
    @IBAction func btnRegisterAction(_ sender: UIButton) {
       // let otp = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
       // self.navigationController?.pushViewController(otp, animated: true)
        if isValidData() == false {
            return
        }
        else{
            self.view.endEditing(true)
            //Call Api For Login
            app_Delegate.startLoadingview("")
            self.CallApiForRegisterUser()
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBuyerAction(_ sender: UIButton) {
        strBuyerSeller = "b"
        btnBuyer.backgroundColor = UIColor.red
        btnSeller.backgroundColor = UIColor.white
        btnBuyer.setTitleColor(UIColor.white, for: .normal)
        btnSeller.setTitleColor(UIColor.black, for: .normal)
    }
    
    @IBAction func btnSellerAction(_ sender: UIButton) {
        strBuyerSeller = "s"
        btnBuyer.backgroundColor = UIColor.white
        btnSeller.backgroundColor = UIColor.red
        btnBuyer.setTitleColor(UIColor.black, for: .normal)
        btnSeller.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func btnTermsConditionsAction(_ sender: UIButton) {
        TermsConditionView()
    }
    
    @IBAction func btnTermsAction(_ sender: UIButton) {
        if btnCheck.isSelected == true {
            btnCheck.isSelected = false
            strAcceptTerms = "Blank"
        }
        else {
            self.TermsConditionView()
            btnCheck.isSelected = true
            strAcceptTerms = "fd"
        }
    }
    
    
    
    
    //MARK :- Phone Number Format
//    func checkEnglishPhoneNumberFormat(string: String?) -> Bool{
//        if string!.characters.count == 10{
//            return false
//        }
//        
//        return true
//    }
    
    // MARK: - Pdf Remove Buuton Action
    @IBAction func clkToRemoveViewAction(_ sender: UIButton) {
        viewForDisplayPDF.removeFromSuperview()
    }
    
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            return true
        }
        else if str!.characters.count == 5{
            txtMobile.text = txtMobile.text! + ""
            
        }else if str!.characters.count > 10{
            
            return false
        }
        
        return true
    }
    
    

}




//46,   -12,   72


