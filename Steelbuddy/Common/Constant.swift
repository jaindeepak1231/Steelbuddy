//
//  Constant.swift
//  SpotASport
//
//  Created by Bit1 on 29/02/16.
//  Copyright © 2016 bit. All rights reserved.
//


import Foundation
import MapKit
import CoreLocation
import UIKit


enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}


private let _sharedManager = Constant()

var currentView : UIView = UIView()
var panGesture: UIPanGestureRecognizer?
let isiPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)
let _userDefault : UserDefaults = UserDefaults.standard



let kBasePath   = "http://www.steelbuddy.com/index.php/api/v1/"
let kLogin      = "Login/checkLogin"
let kRegister   = "Registration/addRegistration"
let kCheckOTP   = "Profile/checkOtp"
let kForgotPass = "PasswordReset/resetPassword"
let kGetBanner  = "Banner/getBanner"
let kGetProfile = "Profile/getProfile"
let kUpdateProfile = "Profile/updateProfile"
let kGetCategory = "Category/viewAll"
let kCreateInquiry = "Inquiry/createInquiry"
let kAddInquiry = "Inquiry/addInquiry"
let kAboutUs = "About/getAbout"
let kGetInquiry = "Inquiry/getInquiryBuyer"
let kGetQuatation = "Quotation/getQuotation"
let kBookQuatation = "Quotation/bookQuotation"
let kGetSellerInquiry = "Inquiry/getInquiry"
let kGetAddQuatation = "Quotation/addQuotation"
let kGetSellerViewQuatation = "Quotation/getSellerQuotation"
let kGetChat = "QuotationChatting/getChatting"
let kSendChat = "QuotationChatting/addChatting"
let kGetBuyerRead = "Quotation/ReadUnRead"
let kGetReadUnread = "Quotation/getUnreadCount"
let kUpdateFcm = "Profile/updateFcmid"
let kNotificationCount = "Notification/unreadCount"
let kGetNotificationData = "Notification/allNotification"
let kReadNotification = "Notification/readAll"
let kDeleteNotification = "Notification/allDelete"
let kUploadContacts = "Contact/addContact"


let UserInfo : String = "UserInfo"
let userName : String = "userName"
let islogin : String = "islogin"
let loginWith : String = "login_with"
var device_token = ""
var dictUserInfo : NSDictionary = ["":""]
var _currentUser : String = dictUserInfo["user_id"] as! String
var _currentEmail : String = dictUserInfo["email"] as! String
var _currentUserType : String = dictUserInfo["user_type"] as! String
var cityArray : NSArray = []
var categoryArray : NSArray = []
var _notificationArray :NSMutableArray? = NSMutableArray()


//ALERT MESSAGES
let kEntetEmail:                     String = "Please Enter Email"
let kEntetValidEmail:                String = "Please Enter Valid Email"
let kEntetPassword:                  String = "Please Enter Password"
let kEntetName:                      String = "Please Enter Name"
let kEntetCompanyName:               String = "Please Enter Company Name"
let kEntetGSTNo:                     String = "Please Enter GST Number"
let kEntetAddress:                   String = "Please Enter Address"
let kEntetCity:                      String = "Please Enter City"
let kEnterState:                     String = "Please Enter State"
let kEntetCountry:                   String = "Please Enter Country"
let kEntetMobile:                    String = "Please Enter Mobile"
let kEntetValidMobile:               String = "Please Enter Valid Mobile Number"
let kEntetMinCharacterPassword:      String = "Please Enter Password Min 6 Character"
let kAcceptTerms:                    String = "Please Accept Terms Conditions"
let kEntetSlectRole:                 String = "Please select are you a buyer or seller"



let kEnterReviewDate:                String = "Please Select Review Date"
let kEntetDescription:               String = "Please Enter Description"
let kEnterWorkActivity:              String = "Please Enter Work Activity"
let kEntetCPassword:                 String = "Please Enter Confirm Password"
let kEntetBusiness_Name:             String = "Please Enter Business Name"
let kEnterEmployeeName:              String = "Please Enter Employeer Name"
let kDeleteQuestion:                 String = "You Want to Delete this Question"
let kselectCorrectAnswer:            String = "Please Select Correct Answer"
let kEntetMinium2Optin:              String = "Please Enter Minimum 2 Options"
let kSelectRiskQ:                    String = "Please Eelect Risk Question Checkbox"
let kEnterWorkSupervisior:           String = "Please Enter Work Supervisor"
let kEnterDateSWMSReceive:           String = "Please Select Date SWMS Received"
let kEnterPrincipleCons:             String = "Please Enter Principle Constructer"
let kEnterEmergencyName:             String = "Please Enter Emergency Person Name"
let kEntetCCPassword:                String = "Please Enter Corrcet Confirm Password"
let kEnterEmergencyPhone:            String = "Please Enter Emergency Person Number"
let kEnterSWMSDateProvide:           String = "Please Select Date SWMS Provider to PC"
let kEnterComplience:                String = "Please Enter Ensure Compilence With the SWMS"
let kEnterControlMeasure:            String = "Please Enter Reviewing SWMS Control Measure"
let kEnterPersonResposible:          String = "Please Enter Person Responsible for Ensuring"
let kEnterControlbrReviewd:          String = "Please Enter SWMS Control Measure be Reviewed"
let kEnterDateSWMSReceiveByReviewer: String = "Please Select Date SWMS Received by Reviewer"



let kEntetCompnayName: String = "Please Enter Company Name"
let kEnterSiteName:    String = "Please Enter Site Name"
let kEnterContracter:  String = "Please Enter Contracter"
let kEnterActivity:    String = "Please Select Activity"
let kEnterJSADate:     String = "Please Select Date"
let kEnterJSANo:       String = "Please Enter JSA No"
let kSelectPermit:     String = "Please Select Permit to Work"
let kEnterApproveBy:   String = "Please Enter Approved by"
let kEntetJSAFirst:    String = "Please Enter First Answer"
let kEntetJSASecond:   String = "Please Enter Second Answer"
let kEntetJSAThird:    String = "Please Enter Third Answer"
let kEntetJSAForuth:   String = "Please Enter Fourth Answer"




class Constant: NSObject,CLLocationManagerDelegate {
    
    class var sharedManager:Constant {
        return _sharedManager;
    }
    public override init(){
        
    }
    
    static let PRIMARY_COLOR = UIColor.init(colorLiteralRed: 21.0/255.0, green: 129.0/255.0, blue: 198.0/255.0, alpha: 1.0)
    static let MENU_HEIGHT:CGFloat = 30.0
    
    static let Roboto_Reg  = "Roboto-Regular"
    static let Roboto_Light  = "Roboto-Light"
    
    //[Droid Sans]
    //Font Names = [["DroidSans",
    
    static let screenSize = UIScreen.main.bounds.width / 2
    
    //=============================Googloe AutoComplete Api========================//
    static let GoogleClientID = "1012692018500-3lualpspcumqvuubpsdruf2as3ecbn2t.apps.googleusercontent.com"
    //static let GoogleDirectionAPI = "AIzaSyCmvC_H5S08MvkO-ixoQTpJQGXdu5qyVWg"
    static let GoogleDirectionAPI = "AIzaSyDW6HJPpZVkdFVjS27foM4yWCLlEtUrsdM"
    
    
    static let kGoogleAutoCompleteAPI  = "https://maps.googleapis.com/maps/api/place/autocomplete/json?language=en&key=" + GoogleDirectionAPI + "&input="
    
    static let kGoogleLatlongFromAddressAPI  = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    class func themeColor()->UIColor{
        return UIColor(red:232/255.0, green:28/255.0, blue:35/255.0, alpha: 1.0)
    }
    
    class func WhiteColor()->UIColor{
        return UIColor(red:234/255.0, green:135/255.0, blue:138/255.0, alpha: 1.0)
    }
    
    class func BorderColor()->UIColor{
        return UIColor(red:142/255.0, green:218/255.0, blue:218/255.0, alpha: 1.0)
    }

    class func borderColor()->CGColor{
        return UIColor(red:181/255.0, green:181/255.0, blue:181/255.0, alpha: 1.0).cgColor
    }
    
    class func RedColor()->UIColor{
        return UIColor(red:231/255.0, green:29/255.0, blue:35/255.0, alpha: 1.0)
    }
    
    class func blackColor()->UIColor{
        return UIColor(red:35/255.0, green:35/255.0, blue:35/255.0, alpha: 1.0)
    }
    
    class func GreyColor()->UIColor{
        return UIColor(red:238/255.0, green:238/255.0, blue:238/255.0, alpha: 1.0)
    }
    
    class func backgrayColor()->UIColor{
        return UIColor(red:153/255.0, green:153/255.0, blue:153/255.0, alpha: 1.0)
    }
    
    class func backpinkColor()->UIColor{
        return UIColor(red:233/255.0, green:30/255.0, blue:99/255.0, alpha: 1.0)
    }
    class func FBColor()->UIColor{
        return UIColor(red:0/255.0, green:42/255.0, blue:156/255.0, alpha: 1.0)
    }
    class func TwitterColor()->UIColor{
        return UIColor(red:0/255.0, green:148/255.0, blue:219/255.0, alpha: 1.0)
    }
    class func convertFloatDecimalAfterTwoPoint(strPrice : String) -> String{
        let floatvat = Float(strPrice as String)
        let strFloatPrice = String.localizedStringWithFormat("%.2f", floatvat!)
        return strFloatPrice
    }
    
    class func paddingView() -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: 10, height: 40)
        let paddingView = UIView(frame: rect)
        return paddingView
    }
    
    class func rightAerrow() -> UIImageView? {
        let arrow = UIImageView(image: UIImage(named: "dropdown-arrow"))
        let rect = CGRect(x: -30, y: 15, width: 19, height: 10)
        arrow.frame = rect
        arrow.contentMode = UIViewContentMode.scaleToFill
        return arrow
    }
    
    class func rightPaddingView(strImage:NSString) -> UIView? {
        
        let rectFrame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let paddingView = UIView(frame: rectFrame)
        let arrow = UIImageView(image: UIImage(named:strImage as String))
        var rect = CGRect()
        
//        if strImage == "school_blue"
//        {
//            rect = CGRect(x: 0, y: 12, width:12 , height: 22)
//            
//        }else{
            rect = CGRect(x: 2, y: 5, width: 15, height: 15)
//        }
        
        arrow.frame = rect
        arrow.contentMode = UIViewContentMode.scaleToFill
        paddingView.addSubview(arrow)
        return paddingView
    }
    
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func convertArrayToJsonString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
        
    
    
    
    
    static func validateUrl(candidate:String)->Bool{
        if URL.init(string: candidate) != nil{
            return true
        }else{
            return false
        }
    }
    
    
    
    class func openMapCurrentLocation(){
 if(UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL))
        {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")! as URL)
        } else {
            self.showAlert(title: "", message: "Oops seems like something went wrong!!")
        }
    }

    // Resize image
    class func resizeImage(image: UIImage, longEdge: CGFloat) -> UIImage {
        var newHeight = image.size.height
        var newWidth = image.size.width
        
        if newHeight < 500 &&  newWidth < 500{
            return image
        }
        
        var scale = longEdge / image.size.height
        
        if newHeight > newWidth{
            scale = longEdge / image.size.height
            newWidth = image.size.width * scale
            newHeight = longEdge
        }else{
            scale = longEdge / image.size.width
            newHeight = image.size.height * scale
            newWidth = longEdge
        }
        
        let size = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        image.draw(in:rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    class func openRoute(sourceLat: NSString,sourceLong: NSString, destinationLat: NSString, destinationlong: NSString)
    {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.openURL(NSURL(string: "comgooglemaps://?saddr=\(sourceLat),\(sourceLong)&daddr=\(destinationLat),\(destinationlong)&zoom=10")! as URL)
        }else if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL)) {
            UIApplication.shared.openURL(NSURL(string: "http://maps.apple.com/maps?saddr=\(sourceLat),\(sourceLong)&daddr=\(destinationLat),\(destinationlong)")! as URL)
        }
    }
    
    
    class func getQueryStringFromDictionary(_dict: [String : Any]) -> String {
        var output = String()
        for (key,value) in _dict {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.characters.dropLast())
        return output
    }
    
    
    class func currentDateString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormat.string(from: NSDate() as Date)
        return strDate
    }
    
    class func currentDateStringForChat() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormat.string(from: NSDate() as Date)
        return strDate
    }
    
    class func currentTimeString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "ddMMyyyyHHmmssSSS"
        let strDate = dateFormat.string(from: NSDate() as Date)
        return strDate
    }
    
    class func currentDateTime() -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-mm-dd HH:mm:ss"
        let strDate = dateFormat.string(from: NSDate() as Date)
        let date = dateFormat.date(from: strDate)
        return date!
    }
    
    class func currentDateTimeString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "ddMMyyHHmmss"
        let strDate = dateFormat.string(from: NSDate() as Date)
        return strDate
    }
    
    class func currentDateTimeStringForCategory() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "ddMMyy"
        let strDate = dateFormat.string(from: NSDate() as Date)
        return strDate
    }
    
    
    class func showAlert(title: NSString, message: String) {
        let obj = UIAlertView(title: title as String, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
        obj.show()
    }
    
    class func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let blue = CGFloat(rgbValue & 0xFF)/255.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    class func uicolorFromHexDifferentAlpha(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let blue = CGFloat(rgbValue & 0xFF)/255.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:0.2)
    }
    
   class func getDayOfWeek(today:String) -> String? {
        let weekdays = [
            "SUN",
            "MON",
            "TUE",
            "WED",
            "THU",
            "FRI",
            "SAT"
        ]
        
        let formatter  = DateFormatter()
        //formatter.dateFormat = "dd-MMM-yyyy hh:mm a"
        formatter.dateFormat = "dd-MMM-yyyy"
        if let todayDate = formatter.date(from: today) {
            let myCalendar =  NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let myComponents = myCalendar!.components(NSCalendar.Unit.weekday, from: todayDate)
            let weekDay = weekdays[myComponents.weekday! - 1]
            return weekDay
        } else {
            return nil
        }
    }
    
   class func getNextTwoWeeks() -> NSMutableArray? {
        let dateArray : NSMutableArray = []
        var dict : NSDictionary = [:]
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let dateComponent = NSDateComponents()
        let date: NSDate = NSDate()
        
        let formatter        = DateFormatter()
        //formatter.dateFormat = "dd-MMM-yyyy hh:mm a"
        formatter.dateFormat = "dd-MMM-yyyy"
        let strDate = formatter.string(from:
            
            
            date as Date)
        let currDate         = formatter.date(from: strDate)
        
        
        for i in 1...15
        {
            dateComponent.day = i
            let newDate = calendar?.date(byAdding: dateComponent as DateComponents, to: currDate!, options:NSCalendar.Options(rawValue: 0))
            let strDate = formatter.string(from: newDate!)
            let weekday = getDayOfWeek(today: strDate )
            
            let todayDate = formatter.date(from: strDate)
            let myCalendar =  NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let myComponents = myCalendar!.components(NSCalendar.Unit.day, from: todayDate!)
            let weekDate = myComponents.day
            let day = String(describing: weekDate)
            dict = [:]
            
            dict = ["day" : day, "date" : strDate, "week" : weekday!]
            print(dict)
            dateArray.add(dict)
        }
        return dateArray
    }
    
    
    class func isConnected() -> Bool {
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: URLResponse?
        do {
            _ = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    Status = true
                }
            }
        } catch (let e) {
            print(e)
            Status = false
            return Status
        }
        return Status
    }
    
    class func makeaCall(_ phone_number: String) {
        var phNo: String = phone_number
        phNo = phNo.replacingOccurrences(of: " ", with: "")
        let phoneUrl = URL(string: "telprompt:\(phNo)")
        if (phNo.characters.count ) > 0 {
            if UIApplication.shared.canOpenURL(phoneUrl!) {
                UIApplication.shared.openURL(phoneUrl!)
            }
            else {
                Constant.showAlert(title: "", message: "Call facility is not available!!!")
            }
        }
        else {
            Constant.showAlert(title: "", message: "Number is not available!!!")
        }
    }
    
    
    
    
    
    
   /*
    class func CheckPhotoPermission() -> Bool {
        var Status:Bool = false
        let mediaType: String = AVMediaTypeVideo
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType)
        
        if authStatus == .authorized {
            // do your logic
        }
        else if authStatus == .denied {
            // denied
            Status = true
        }
        else if authStatus == .restricted {
            // restricted, normally won't happen
        }
        else if authStatus == .notDetermined {
            // not determined?!
            AVCaptureDevice.requestAccess(forMediaType: mediaType, completionHandler: { (_ granted : Bool) in
                DispatchQueue.main.async(execute: {() -> Void in
                    if granted {
                        
                    }
                    else {
                        print("Not granted access to \(mediaType)")
                    }
                })
            })
        }
        else {
            // impossible, unknown authorization status
        }
        return Status
    }
    
    */
    
}


extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    ///
    /// Returns a data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var pngData: Data? { return UIImagePNGRepresentation(self) }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpegData(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

extension UIButton {
    /*public func imageFromUrl(urlString: String, placeholderImage : UIImage, contrlState : UIControlState) {
        
        if let url = NSURL(string: urlString) {
            self.APsetImageWithURL(url, forState: contrlState, placeholderImage: placeholderImage)
        }
    }*/
}

extension NSDate {
    
    /*func getElapsedInterval(currentTime : NSDate) -> String {
        
        
        //var interval = NSCalendar.currentCalendar.components(.Year, fromDate: self, toDate: currentTime, options: []).year
        
        var interval = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: currentTime)


        
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + NSLocalizedString("year", comment: "") :
                "\(interval)" + " " +  NSLocalizedString("years", comment: "")
        }
        
        interval = NSCalendar.currentCalendar().components(.Month, fromDate: self, toDate: currentTime, options: []).month
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " +  NSLocalizedString("month", comment: "") :
                "\(interval)" + " " + NSLocalizedString("months", comment: "")
        }
        
        interval = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: currentTime, options: []).day
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + NSLocalizedString("day", comment: "") :
                "\(interval)" + " " + NSLocalizedString("days", comment: "")
        }
        
        interval = NSCalendar.currentCalendar().components(.Hour, fromDate: self, toDate: currentTime, options: []).hour
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + NSLocalizedString("hour", comment: "") :
                "\(interval)" + " " + NSLocalizedString("hours", comment: "")
        }
        
        interval = NSCalendar.currentCalendar().components(.Minute, fromDate: self, toDate: currentTime, options: []).minute
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " +  NSLocalizedString("minute", comment: "") :
                "\(interval)" + " " + NSLocalizedString("minutes", comment: "")
        }
        
        return NSLocalizedString("a moment", comment: "a moment")
    }
    func offsetFrom(date:NSDate) ->  (minute: Int, second: Int)? {
        let dayHourMinuteSecond: NSCalendar.Unit = [.minute, .second]
        let difference = NSCalendar.currentCalendar.components(dayHourMinuteSecond, fromDate: date, toDate: self, options: [])
        return (difference.minute, difference.second)
    }
    */
    
    
    
    
}

extension String {
    
    func isEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
        
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
    
    func isStringWithoutSpace() -> Bool{
        return !self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    func toDouble() -> Double? {
        return Double(self)//NSNumberFormatter().numberFromString(self)?.doubleValue
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    func contains(find: String) -> Bool{
        return self.range(of:find, options:String.CompareOptions.caseInsensitive) != nil
    }
    
    var attributedStringFromHtml: NSAttributedString? {
        do {
            return try NSAttributedString(data: self.data(using: String.Encoding.utf8)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        } catch _ {
            print("Cannot create attributed String")
        }
        return nil
    }
    
    
    /*func indexOfCharacter(char: Character) -> Int? {
        if let idx = self.characters.index(of: char) {
            return self.startIndex.distanceTo(idx)
        }
        return nil
    }
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }*/
    
//    subscript (r: Range<Int>) -> String {
//        let start = startIndex.advancedBy(r.startIndex)
//        let end = start.advancedBy(r.endIndex - r.startIndex)
//        return self[start..<end]
//    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: .literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    /*func firstCharacterUpperCase() -> String {
        let lowercaseString = self.lowercased()
        
        return lowercaseString.stringByReplacingCharactersInRange(lowercaseString.startIndex...lowercaseString.startIndex, withString: String(lowercaseString[lowercaseString.startIndex]).uppercaseString)
    }*/
}

extension UILabel {
    func underlinetext(text: String,color : UIColor) {
        let textRange = NSMakeRange(0, text.characters.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        attributedText.addAttribute(NSUnderlineColorAttributeName, value: color, range: textRange)
        self.attributedText = attributedText
    }
}

// To give parellex effect on any view.

extension UIView {
    
    func cornerWithBorder(sizeCorner: CGFloat ,borderWidth: CGFloat, borderColor: CGColor ){
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = sizeCorner
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func roundCornersWithSide(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func borderView(borderWidth: CGFloat, borderColor: CGColor ){
        self.layer.masksToBounds = true;
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func roundCornersWithSideAndBorder(corners:UIRectCorner, radius: CGFloat,borderWidth: CGFloat, borderColor: CGColor ) {
                 
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.clipsToBounds = true
   
    }
 
    func cornerWith(sizeCorner: CGFloat){
        self.layer.cornerRadius = sizeCorner
        self.clipsToBounds = true
    }
    
    func ch_addMotionEffect() {
        let axis_x_motion: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
        axis_x_motion.minimumRelativeValue = NSNumber(value: -10)
        axis_x_motion.maximumRelativeValue = NSNumber(value: 10)
        
        let axis_y_motion: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
        axis_y_motion.minimumRelativeValue = NSNumber(value: -10)
        axis_y_motion.maximumRelativeValue = NSNumber(value: 10)
        
        let motionGroup : UIMotionEffectGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = NSArray(objects: axis_x_motion,axis_y_motion) as? [UIMotionEffect]
        
        self.addMotionEffect(motionGroup)
    }
}





// MARK: Global Functions

func isAtLeastiOSVersion(ver: String) -> Bool {
    return UIDevice.current.systemVersion.compare(ver, options: .numeric, range: nil, locale: nil) != ComparisonResult.orderedAscending
}

// MARK: Useful Classes

class PushWithoutAnimationSegue: UIStoryboardSegue {
    override func perform() {
        let svc =  source
        svc.navigationController?.pushViewController(destination , animated: false)
    }
}

class RoundView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
}

class RoundImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.bounds.size.height/2
        self.layer.masksToBounds = true
    }
    
}


class RoundButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
}


extension UIDevice {
    var isSimulator: Bool {
        #if IOS_SIMULATOR
            return true
        #else
            return false
        #endif
    }
}
