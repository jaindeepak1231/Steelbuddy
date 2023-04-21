//
//  ServerCall.swift
//  ShreeMahavirCourier
//
//  Created by Gaurav Rami (gaurav.rami26@gmail.com) on 01/01/16.
//  Copyright © 2016 Versatile. All rights reserved.
//

import UIKit
import Alamofire

//
//MARK: - Network Reachability Manager - GLOBAL Variables
let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
var isInternetAvailable = false



//
//MARK: - URL Constants.....
//private let BASE_URL = "http://52.64.92.76/rest/index.php/Api_doctor/"
//let URL_LOGIN = BASE_URL + "login"
//let URL_FORGOT_PASSWORD = BASE_URL + "forget_password"
//let URL_PATIENT_REQUEST = BASE_URL + "get_appoinment"
//let URL_ACCEPT_REQUEST = BASE_URL + "accept_appoinment"
//let URL_REFERRAL_CATEGORY = BASE_URL + "get_category"
//let URL_REFERRAL_NEAR_BY = BASE_URL + "near_by_specialist"
//let URL_PATIENT_INFO = BASE_URL + "get_patient_info"
//let URL_END_APPOINTMENT = BASE_URL + "end_appoinment"


//
//MARK: - enum
enum ServerCallName : Int {
    case serverCallNameGoogleAddressSearch = 101,
    serverCallNameLogin,
    serverCallNameRegister,
    serverCallNameForgotPass,
    serverCallNameRegisterOTP,
    serverCallNameGetBanner,
    serverCallNameGetProfile,
    serverCallNameUpdateProfile,
    serverCallNameGetCategories,
    serverCallNameCreateInquiry,
    serverCallNameAddInquiry,
    serverCallNameContactUs,
    serverCallNameGetInquiry,
    serverCallNameGetQuatation,
    serverCallNameGetSellerQuatation,
    serverCallNameBookQuatation,
    serverCallNameSellerInquiry,
    serverCallNameAddQuatation,
    serverCallNameGetChat,
    serverCallNameSendChat,
    serverCallNameUnreadCount,
    serverCallNameNotificationCount,
    serverCallNameReadQuotation,
    serverCallNameUpdateFCM,
    serverCallNameGetNotification,
    serverCallNameReadNotification,
    serverCallNameDeleteNotification,
    serverCallNameUploadContacts
    

}

enum HTTP_METHOD {
    case GET,
    POST
}

//
//MARK: - PROTOCOL
protocol ServerCallDelegate {
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName)
    func ServerCallFailed(_ errorObject:String, name: ServerCallName)
}


//
//MARK: - ServerCall CLASS
class ServerCall: NSObject {
    var delegateObject : ServerCallDelegate!
    
    // Shared Object Creation
    static let sharedInstance = ServerCall()
    
    //MARK: - Request Methods.
    // Make API Request WITHOUT Header Parameters
    func requestWithURL(_ httpMethod: HTTP_METHOD, urlString: String, delegate: ServerCallDelegate, name: ServerCallName) {
        self.delegateObject = delegate
        let methodOfRequest : HTTPMethod = (httpMethod == HTTP_METHOD.GET) ? HTTPMethod.get : HTTPMethod.post
        let queue = DispatchQueue(label: "com.versatiletechno.manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        let request = Alamofire.request(urlString, method: methodOfRequest, parameters: nil)
        request.responseJSON(queue: queue,
                             options: JSONSerialization.ReadingOptions.allowFragments) {
                                (response : DataResponse<Any>) in
                                // You are now running on the concurrent `queue` you created earlier.
                                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                                
                                // To update anything on the main thread, just jump back on like so.
                                DispatchQueue.main.async {
                                    print("Am I back on the main thread: \(Thread.isMainThread)")
                                    if (response.result.isSuccess) {
                                        self.delegateObject.ServerCallSuccess(response.result.value! as AnyObject, name: name)
                                    }
                                    else if (response.result.isFailure) {
                                        self.delegateObject.ServerCallFailed((response.result.error?.localizedDescription)!, name: name)
                                    }
                                }
        }
        
    }
    
    
    // Make API Request WITH Parameters
    func requestWithUrlAndParameters(_ httpMethod: HTTP_METHOD, urlString: String, parameters: [String : AnyObject], delegate: ServerCallDelegate, name: ServerCallName) {
        
        self.delegateObject = delegate
        let methodOfRequest : HTTPMethod = (httpMethod == HTTP_METHOD.GET) ? HTTPMethod.get : HTTPMethod.post
        let queue = DispatchQueue(label: "com.versatiletechno.manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        let request = Alamofire.request(urlString, method: methodOfRequest, parameters: parameters)
        request.responseJSON(queue: queue,
                             options: JSONSerialization.ReadingOptions.allowFragments) {
                                (response : DataResponse<Any>) in
                                // You are now running on the concurrent `queue` you created earlier.
                                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                                print("\n\n\n")
                                print("\n")
                                print(parameters)
                                print("\n\n\n")
                                print("\n\n\n")
                                print(response)
                                
                                // To update anything on the main thread, just jump back on like so.
                                DispatchQueue.main.async {
                                    print("Am I back on the main thread: \(Thread.isMainThread)")
                                    if (response.result.isSuccess) {
                                        self.delegateObject.ServerCallSuccess(response.result.value! as AnyObject, name: name)
                                    }
                                    else if (response.result.isFailure) {
                                        let strCheck = response.result.error?.localizedDescription
                                        if strCheck == "Response could not be serialized, input data was nil or zero length." {
                                        }
                                        else {
                                            self.delegateObject.ServerCallFailed((response.result.error?.localizedDescription)!, name: name)
                                        }
                                        
                                        
                                    }
                                }
        }
    }

    
    
    


    
    
    
    
    
    // Make API Request WITH Header
    func requestWithUrlAndHeader(_ httpMethod: HTTP_METHOD, urlString: String, header: [String : String], delegate: ServerCallDelegate, name: ServerCallName) {
        self.delegateObject = delegate
        let methodOfRequest : HTTPMethod = (httpMethod == HTTP_METHOD.GET) ? HTTPMethod.get : HTTPMethod.post
        let queue = DispatchQueue(label: "com.versatiletechno.manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        let request = Alamofire.request(urlString, method: methodOfRequest, parameters: nil, headers: header)
        request.responseJSON(queue: queue,
                             options: JSONSerialization.ReadingOptions.allowFragments) {
                                (response : DataResponse<Any>) in
                                // You are now running on the concurrent `queue` you created earlier.
                                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                                
                                // To update anything on the main thread, just jump back on like so.
                                DispatchQueue.main.async {
                                    print("Am I back on the main thread: \(Thread.isMainThread)")
                                    if (response.result.isSuccess) {
                                        self.delegateObject.ServerCallSuccess(response.result.value! as AnyObject, name: name)
                                    }
                                    else if (response.result.isFailure) {
                                        self.delegateObject.ServerCallFailed((response.result.error?.localizedDescription)!, name: name)
                                    }
                                }
        }
    }
    
    
    
    //MARK:- Multi part request with parameters.
    func requestMultiPartWithUrlAndParameters(_ urlString: String, parameters: [String : Any], fileParameterName: String, fileName:String, fileData : Data, mimeType : String, delegate: ServerCallDelegate, name: ServerCallName) {
        
        self.delegateObject = delegate
       
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // The for loop is to append all parameters to multipart form data.
                for element in parameters.keys{
                    let strElement = String(element)
                    let strValueElement = parameters[strElement!] as! String
                    multipartFormData.append(strValueElement.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: strElement!)
                }
                
                // Append file to multipart form data.
                multipartFormData.append(fileData, withName: fileParameterName, fileName: fileName, mimeType: mimeType)
            },
            to: urlString,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
//                        print(response.result.value!)
//                        print(response.data as! NSData)
                        self.delegateObject.ServerCallSuccess(response.result.value! as AnyObject, name: name)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self.delegateObject.ServerCallFailed(encodingError.localizedDescription, name: name)
                }
            }
        )
    }
    
    /*
    func isInternetAvailabel() -> Bool {
        
        Alamofire.request("https://httpbin.org/get")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
        }
    }
     */
}

//MARK:- GLOBAL Method. Out of ServerCall Class.
func isInternetAvailabel() -> Bool {
    reachabilityManager?.startListening()
    reachabilityManager?.listener = { status in
        print("Network Status Changed: \(status)")
        isInternetAvailable = true
        switch status {
        case .notReachable:
            //Show error state
            isInternetAvailable = false
            break
        case .reachable(.ethernetOrWiFi):
            break
        case .reachable(.wwan):
            break
        case .unknown:
            //Hide error state
            break
        }
    }
    return isInternetAvailable
}





