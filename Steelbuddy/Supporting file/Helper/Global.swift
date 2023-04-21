//
//  Global.swift
//  E-Ticketing
//
//  Created by Beant Singh on 2/10/16.
//  Copyright © 2016 Beant Singh. All rights reserved.
//

import UIKit




class Global: NSObject {

    var arrCollectionData = [AnyObject]()
    var arrQuoteListData = [AnyObject]()
    var arrImageListData = [AnyObject]()
    var arrImageNameData = [AnyObject]()
    var arrDeleteValueData = [AnyObject]()
    var arrGreenTickNewData = [AnyObject]()
    var arrGreenTickOldData = [AnyObject]()
    var arrReminderData = [AnyObject]()
    var CollectionData = ""
    var QuoteData = ""
    var ImageData = ""
    var DeleteData = ""
    var ReminderData = ""
    var StrGreenTickNewData = ""
    var strGreenTick = ""
    
    var StrGreenTickOldData = ""
    
    
    var dicData = [AnyHashable: Any]()
    var pickedImage = UIImage()
    var ParemeterData = NSData()
    
    static let sharedInstance = Global()
    var loaderAdded = Bool()
    
    var controllerArray = NSMutableArray()
    struct macros {
        
 
        static let kAppDelegate = UIApplication.shared.delegate
        static let AppWindow:UIWindow = Global.macros.kAppDelegate!.window!!
        static let Storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
    }
}

extension Global {
    
//    func showToast(toastMessage:NSString) {
//
//        self.configureAppearance()
//        
//        Toast.makeText(toastMessage as String, delay: 0, duration: 2).show()
//    }
    
//    func configureAppearance() {
//        let appearance = ToastView.appearance()
//        //appearance.backgroundColor = .black
//        appearance.textColor = .white
//        //appearance.font = .boldSystemFont(ofSize: 16)
//        appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
//        appearance.bottomOffsetPortrait = 100
//        appearance.cornerRadius = 20
//    }
    

    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    
    
    
    
//    func showLoader() {
//        var config : SwiftLoader.Config = SwiftLoader.Config()
//        config.size = 170
//        config.backgroundColor = UIColor.clear
//        config.spinnerColor = UIColor.white
//        config.titleTextColor = UIColor.white
//        config.spinnerLineWidth = 2.0
//        config.foregroundColor = UIColor.black
//        config.foregroundAlpha = 0.5
//        
//        SwiftLoader.setConfig(config)
//        
//        SwiftLoader.show(animated: true)
//        
//        SwiftLoader.show(title: "Loading...", animated: true)
//
//    }
//    
//    func hideLoader() {
//        SwiftLoader.hide()
//    }
    
   
    
    
    
    // MARK: - Api WebserviceForPostData
   // func WebserviceForPostData()  {
      //  let strURL = MainURL+"getDataFromApp&quoteTitles="+CollectionData+"&quote_list="+QuoteData+"&img_album="+ImageData+"&delete_action="+DeleteData
        //let strURL = MainURL+"getDataFromApp"
      //  let request = NSMutableURLRequest()
      //  request.url = URL(string: strURL)!
      //  request.httpMethod = "POST"
        
        

       // let data : NSData = NSKeyedArchiver.archivedData(withRootObject: param) as NSData
       // JSONSerialization.isValidJSONObject(param)
        
     //   request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
     //   request.setValue("application/json", forHTTPHeaderField: "Accept")
//        let newDatasetInfo = [
//            "quoteTitles" : CollectionData,
//            "qoute_list" : QuoteData,
//            "img_album" : ImageData,
//            "delete_action" : DeleteData
//        ]
//        //convert object to data
//        
    
     //   let boundary = "---------------------------14737809831466499882746641449"
    //    let contentType = "multipart/form-data; boundary=\(boundary)"
    //    request.addValue(contentType, forHTTPHeaderField: "Content-Type")
    //    let body = NSMutableData()
    //    body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        
//        body.append("Content-Disposition: form-data; name=\"\("quoteTitles")\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//        body.append("\(CollectionData)\r\n".data(using: String.Encoding.utf8)!)
//        
//        body.append("Content-Disposition: form-data; name=\"\("quote_list")\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//        body.append("\(QuoteData)\r\n".data(using: String.Encoding.utf8)!)
//        
//        body.append("Content-Disposition: form-data; name=\"\("img_album")\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//        body.append("\(ImageData)\r\n".data(using: String.Encoding.utf8)!)
//        
//        body.append("Content-Disposition: form-data; name=\"\("delete_action")\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//        body.append("\(DeleteData)\r\n".data(using: String.Encoding.utf8)!)
        
     //   for i in 0..<arrImageListData.count {
      //      let item = arrImageListData[i]
      //      let Imag = "\(item.value(forKey: "image") as! String)"
      //      let ImageId = "\(item.value(forKey: "id") as! String)"
            
      //      let decodedData = NSData(base64Encoded: Imag, options: NSData.Base64DecodingOptions(rawValue: 0) )
      //      let decodedimage = UIImage(data: decodedData! as Data)
       //     pickedImage = decodedimage! as UIImage
            
        //    let image = UIImageJPEGRepresentation(pickedImage, 50)!
        //    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
    //        body.append("Content-Disposition: form-data; name=\"\(ImageId)\"; filename=\"image.jpg\"\r\n".data(using: String.Encoding.utf8)!)
            
     //       print("Content-Disposition: form-data; name=\"\(ImageId)\"; filename=\"image.jpg\"\r\n")
            
    //        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
     //       body.append(image)
     //       body.append("\r\n".data(using: String.Encoding.utf8)!)
      //      body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
     //   }
        
    //    body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        
     //   body.append("quoteTitles=\"\(CollectionData)\"".data(using: String.Encoding.utf8)!)
        
        
    //    request.httpBody = body as Data
        //let bodyData = "quoteTitles='"+CollectionData+"'&quote_list='"+QuoteData+"'&img_album='"+ImageData+"'&delete_action='"+DeleteData+"'"
        //request.httpBody = bodyData.data(using: String.Encoding.utf8);
        
    //    let returnData = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil)
        
    //    let receivedString = "\(returnData)"
     //   print(receivedString)
        
     //   let datastring = NSString(data: returnData, encoding: String.Encoding.utf8.rawValue)
     //   print("\(datastring)")
    
   // }
    
    
    
    

}
  


extension  UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType? {
        guard iPhone else { return nil }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return nil
        }
    }
}
