//
//  Sample.swift
//  PayDollarSDK
//
//  Created by AsiaPay Limited on 18/01/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

import UIKit

public class PaySDK: NSObject {
    
    public static var shared = PaySDK()
    public var paymentDetails : PayData!
    var sharedAuth :Auth!
    public var delegate: PaySDKDelegate?
    var navigationVW : UINavigationController?
    var publicKey : String = ""
    //public var uiCustomization : UiCustomization?
    //var service: ults_ThreeDS2Service? = nil
    //var sdkTransaction: ults_Transaction? = nil
    //var isSdkInitialized: Bool = false
    //let factory =  SampleFactory()
    
    override init() {
        super.init()
        publicKey = self.getPublicKey()
        //initializeXecureSDK()
    }
    
    init(publicKey: String) {
        super.init()
    }
    
    func processApplePay() {
        //ApplePayClass.sharedPay.payDetails = paymentDetails
        //ApplePayClass.sharedPay.pay()
    }
    
    func getPublicKey() -> String {
        do {
            if let fileUrl = Bundle.main.url(forResource: "paysdk", withExtension: "plist"),
                let data = try? Data(contentsOf: fileUrl) {
                if let result = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
                    return result["SDK_RSA_PublicKey"] as! String
                }
            } else {
                fatalError("paysdk.plist File not found")
            }
        } catch let error {
            print(error)
        }
        return ""
    }
    
    public func process() {
        Reachability.isInternetAvailable(webSiteToPing: nil) { (isInternetAvailable) in
            guard isInternetAvailable else {
                self.delegate?.paymentResult(result: PayResult.init(fromDictionary: [
                    "errMsg":"Device is not connected to internet",
                    "successCode":"1",
                ]))
                return
            }
        }
        if paymentDetails == nil {
            self.delegate?.paymentResult(result: PayResult.init(fromDictionary: ["errMsg" : "PayData cannot be nil or empty"]))
            fatalError("PayData cannot be nil or empty")
            //return
        }
        _ = paymentDetails.isValidInput()
        // if(self.paymentDetails.payMethod == "APPLEPAY") {
        //if UIDevice.current.systemVersion.floatValue >= 11 {
        //self.processApplePay()
        //} else {
        //self.delegate?.paymentResult(result: PayResult.init(fromDictionary: ["errMsg":"Apple Pay required iOS 11.0 and above","successCode":"1"]))
        //}
        //} else if(self.paymentDetails.payMethod == "3DS2.0") {
        //let threeDS = PaysdkThreeds()
        //paymentDetails.payMethod = "VISA"
        //threeDS.paymentDetails = paymentDetails
        //threeDS.checkThreeDSSupport()
        //} else {
        let authKey = RsaOaep256A128GCM.sharedRSA.encodeJWE(merchantPublicKey : publicKey)
        let url = Environment().getbaseURL(payDetails: paymentDetails) + "paysdk-api/auth"
        let authParas = ["user":paymentDetails.merchantId?.getMerchantId(paygate: paymentDetails.payGate!), "auth": authKey] as! [String : String]
        let headers = [
            "Content-Type": "application/json"
        ]
        APIService.sharedInstance.makeRequest(serviceURL: url, method: .post, header: headers, postData: authParas) { dataResponse, Error in
            do {
                let jsonDecoder = JSONDecoder()
                self.sharedAuth = try jsonDecoder.decode(Auth.self, from: dataResponse as! Data)
                if self.sharedAuth.token != nil {
                    if (self.paymentDetails.extraData["memberPay_service"] != nil && self.paymentDetails.extraData["addNewMember"] as! Bool == false) {
                        self.processMemberPay()
                    } else if (self.paymentDetails.payMethod == .ALIPAYHKAPP || self.paymentDetails.payMethod == .ALIPAYCNAPP || self.paymentDetails.payMethod == .ALIPAYAPP) {
                        self.makeAliPayPayment()
                    } else {
                        switch self.paymentDetails.channelType {
                        case .WEBVIEW?:
                            self.makeHostedPayment()
                            break
                        case .DIRECT?:
                            self.makePayment()
                            break
                        default:
                            break
                        }
                    }
                } else {
                    self.delegate?.paymentResult(result: PayResult.init(fromDictionary: ["errMsg": self.sharedAuth.error!]))
                }
            } catch let error{
                print(error)
            }
        }
    }
    
    
    func addCardDetails() {
        if(paymentDetails.cardDetails?.cardNo != nil) {
            paymentDetails.extraData["cardNo"] = paymentDetails.cardDetails!.cardNo
        }
        if(paymentDetails.cardDetails?.cardHolderName != nil) {
            paymentDetails.extraData["cardHolder"] = paymentDetails.cardDetails!.cardHolderName
        }
        if(paymentDetails.cardDetails?.expMonth != nil) {
            paymentDetails.extraData["epMonth"] = paymentDetails.cardDetails!.expMonth
        }
        if(paymentDetails.cardDetails?.expYear != nil) {
            paymentDetails.extraData["epYear"] = paymentDetails.cardDetails!.expYear
        }
        if(paymentDetails.cardDetails?.securityCode != nil) {
            paymentDetails.extraData["securityCode"] = paymentDetails.cardDetails!.securityCode!
        }
    }
    
    
    func processMemberPay() {
        var directData1 =  ["merchantId": self.paymentDetails.merchantId!,
                            "orderRef" : self.paymentDetails.orderRef!,
                            "amount" : self.paymentDetails.amount!,
                            "currCode" : self.paymentDetails.currCode!.rawValue,
                            "actionType" : "GenerateToken",
                            "memberId" : self.paymentDetails.extraData["memberPay_memberId"]!
            ] as [String : Any]
        if self.paymentDetails.extraData["memberPay_token"] != nil {
            directData1["token"] = self.paymentDetails.extraData["memberPay_token"]
        }
        var parameters : [String :Any]?
        do {
            let dicData1 = try JSONSerialization.data(withJSONObject: directData1, options: [])
            let dicStr = String(data: dicData1, encoding: .utf8)!
            let cipherText = RsaOaep256A128GCM().makePaymentEnc(dataString: dicStr).removePaddingAndWrapping()
            parameters = ["data":cipherText, "hash":"", "ts":"" ] as [String : Any]
        } catch let error {
            print(error)
        }
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + self.sharedAuth.token!
        ]
        let url = Environment().getbaseURL(payDetails: paymentDetails) + "paysdk-api/order/mempay"
        APIService.sharedInstance.makeRequest(serviceURL: url, method: .post, header: headers, postData: parameters!) { dataResponse, Error in
            do {
                let jsonDecoder = JSONDecoder()
                let memberPayCall = try jsonDecoder.decode(txResp.self, from: dataResponse as! Data)
                let decryptedMemberPayCall = RsaOaep256A128GCM().decodeGCM(dataString: memberPayCall.data!)
                let memPayDic = try JSONSerialization.jsonObject(with: decryptedMemberPayCall.data(using: .utf8)!, options: .allowFragments) as! [String : Any]
                if(memPayDic["responseCode"] as! String == "0" && (memPayDic["token"] as! String != "" || memPayDic["token"] != nil)) {
                    self.paymentDetails.extraData["memberPay_token"] = memPayDic["token"] as! String
                    switch self.paymentDetails.channelType {
                    case .WEBVIEW?:
                        self.makeHostedPayment()
                        break
                    case .DIRECT?:
                        self.makePayment()
                        break
                    default:
                        break
                    }
                } else {
                    self.delegate?.paymentResult(result: PayResult.init(fromDictionary: ["errMsg":(memPayDic["responseMsg"] as! String),"successCode":(memPayDic["responseCode"] as! String)]))
                }
            } catch {
            }
        }
    }
    
    
    func makePayment() {
        if self.sharedAuth.token != nil {
            addCardDetails()
            MakePayment.shared.startPayment(dict: paymentDetails) { (dic) in
                self.delegate?.paymentResult(result: dic!)
            }
        }
    }
    
    
    func indirectPayment() {
        if self.sharedAuth.token != nil {
            MakePayment.shared.startIndirectPayment(dict: paymentDetails) { (dic) in
            }
        }
    }
    
    
    func makeHostedPayment() {
        addCardDetails()
        if self.sharedAuth.token != nil {
            MakePayment.shared.startHostedPayment(dict: paymentDetails) { (dic) in
                self.delegate?.paymentResult(result: dic!)
            }
        }
    }
    
    
    func makeAliPayPayment() {
        if(self.paymentDetails.payMethod == .ALIPAYHKAPP) {
            AliPayHKClass().Pay(pay: self.paymentDetails)
        } else if(self.paymentDetails.payMethod == .ALIPAYCNAPP) {
            AliPayCNClass().PayV2(pay: self.paymentDetails)
        } else if(self.paymentDetails.payMethod == .ALIPAYAPP) {
            AliPayClass().Pay(pay: self.paymentDetails)
        }
    }
    
    
    func makeWeChatPayment() {
        //WeChatPayClass.shared.Pay(pay: paymentDetails)
    }
    
    
    func refreshToken() {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + self.sharedAuth.token!
        ]
        let url = Environment().getbaseURL(payDetails: paymentDetails) + "paysdk-api/auth"
        APIService.sharedInstance.makeRequest(serviceURL: url, method: .put, header: headers, postData: [:]) { dataResponse, Error in
            do {
                let jsonDecoder = JSONDecoder()
                self.sharedAuth = try jsonDecoder.decode(Auth.self, from: dataResponse as! Data)
                switch self.paymentDetails.channelType {
                case .WEBVIEW?:
                    self.makeHostedPayment()
                    break
                case .DIRECT?:
                    self.makePayment()
                    break
                default:
                    break
                }
            }
            catch {}
        }
    }
    
    public func invalidateToken() {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + self.sharedAuth.token!
        ]
        let url = Environment().getbaseURL(payDetails: paymentDetails) + "paysdk-api/auth"
        APIService.sharedInstance.makeRequest(serviceURL: url, method: .delete, header: headers, postData: [:]) { dataResponse, Error in
            do {
                let jsonDecoder = JSONDecoder()
                self.sharedAuth = try jsonDecoder.decode(Auth.self, from: dataResponse as! Data)
            }
            catch {}
        }
    }
    
    public func processOrder(url: URL) {
        if url.host == "safepay" || url.host == "platformapi" {
            AliPayHKClass().processAliPay(url: url)
        }
    }
}


public protocol PaySDKDelegate {
    func paymentResult(result: PayResult)
}

//extension UIButton {
//
//public func setApplePayButton(btnType: ApplePayButtonType, btnStyle: ApplePayButtonStyle, view : UIView) {
////var btnPay = self
////if (!(self.isKind(of: PKPaymentButton.self) )) {
////if (self.accessibilityAttributedLabel == nil) {//After ios 11.0
//if (self.accessibilityLabel == nil){
//let btnPay = PKPaymentButton.init(paymentButtonType: PKPaymentButtonType(rawValue: btnType.rawValue)!, paymentButtonStyle: PKPaymentButtonStyle(rawValue: btnStyle.rawValue)!)
////}
//btnPay.frame = self.frame
//view.addSubview(btnPay)
//view.bringSubview(toFront: self)
//self.alpha = 0.1
//}
////self.accessibilityAttributedLabel = NSAttributedString.init(string: "applePay", attributes: [NSAttributedStringKey.init(rawValue: "isButton") : true])//AFter ios 11.0
//self.accessibilityLabel = "isApplePayButton"
//}
//}


//extension PaySDK{
//
//func getSdkVersion() -> String {
//var result = "(Unknown)"
//self.initSdkOnce()
//do {
//if (service != nil) {
//try result = service!.getSDKVersion()
//}
//} catch let error {
//print(error)
//}
//return result
//}
//
//
//func initializeXecureSDK() {
//do {
//initSdkOnce()
//self.sdkTransaction = try self.service?.createTransaction("F000000000", "2.1.0")
//PaysdkThreeds.sdkProgressDialog = try self.sdkTransaction!.getProgressView(nil)
//}
//catch _ {
//}
//}
//
//
//func initSdkOnce() {
//do {
//if (!self.isSdkInitialized) {
//let config = factory.newConfigParameters()
//self.service = factory.newThreeDS2Service()
//let locale = NSLocale.autoupdatingCurrent.languageCode! + "-" + NSLocale.autoupdatingCurrent.regionCode!
//try self.service!.initialize(nil, config, locale, uiCustomization)
//self.isSdkInitialized = true
//} else {
//}
//}
//catch _ {
//}
//}
//}
