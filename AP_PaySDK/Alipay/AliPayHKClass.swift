//
//  AliPayHKClass.swift
//  PayDollarSDK
//
//  Created by AsiaPay Limited on 08/03/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.


import UIKit

class AliPayHKClass: NSObject {
    
    override init() {
        super.init()
    }
    
    func processAliPay(url: URL) {
        if url.host == "safepay" || url.host == "platformapi" {
            let wrapper =  Wrapper.shared()
            wrapper.delegate = self
            wrapper.processOrder(url)
        }
    }
    
    func Pay(pay :PayData) {
        var isValid : Bool = false
        isValid = pay.isValidInput()
        var dicStr = ""
        if isValid {
            let url_str = Environment().getbaseURL(payDetails: pay) + "paysdk-api/tx/direct"
            let authToken = PaySDK.shared.sharedAuth.token!
            //let secureHash = pay.generatePaymentSecureHash()
            let parameterDict = ["merchantId" : pay.merchantId!,
                                 "orderRef" : pay.orderRef!,
                                 "amount" : pay.amount!,
                                 "currCode" : pay.currCode!.rawValue,
                                 "lang" : pay.lang!.rawValue,
                                 "payMethod" : pay.payMethod!.rawValue,
                                 "payType" : pay.payType!.rawValue as String,
                                 "payGate" : pay.payGate!.rawValue] as [String : Any]
            do {
                let dicData = try JSONSerialization.data(withJSONObject: parameterDict, options: [])
                dicStr = String(data: dicData, encoding: .utf8)!
            } catch {}
            
            let cipherText = RsaOaep256A128GCM.sharedRSA.makePaymentEnc(dataString: dicStr).removePaddingAndWrapping()
            
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + authToken
            ]
            let parameters = ["data":cipherText, "hash":"", "ts":"" ] as [String : Any]
            APIService.sharedInstance.makeRequest(serviceURL: url_str, method: .post, header: headers, postData: parameters) { dataResponse, Error in
                do {
                    let dataDic =  try JSONSerialization.jsonObject(with: dataResponse as! Data, options: []) as? NSDictionary
                    if dataDic != nil {
                        if dataDic?.value(forKey: "data") != nil {
                            let jsonDecoder = JSONDecoder()
                            let directCall = try jsonDecoder.decode(txResp.self, from: dataResponse as! Data)
                            let decryptedDirectCall = RsaOaep256A128GCM.sharedRSA.decodeGCM(dataString: directCall.data!)
                            let dic = try JSONSerialization.jsonObject(with: decryptedDirectCall.data(using: .utf8)!, options: .allowFragments) as! [String :Any]
                            
                            var str : String = dic["errMsg"] as! String
                            str =  str.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: "")
                            var param : String = ""
                            let decodedData = Data(base64Encoded: str, options: .ignoreUnknownCharacters)
                            param = String(data: decodedData!, encoding: .utf8)!
                            var out_trade_nostr = ""
                            var order_ref_no = ""
                            let paramArr = param.components(separatedBy: "&")
                            for j in paramArr {
                                if j.contains("out_trade_no") {
                                    out_trade_nostr = j.replacingOccurrences(of: "out_trade_no=", with: "").replacingOccurrences(of: "\"", with: "")
                                    order_ref_no = pay.orderRef
                                    break
                                }
                            }
                            DispatchQueue.main.async {
                                let wrapper =  Wrapper.shared()
                                wrapper.order_id = out_trade_nostr
                                wrapper.order_ref = order_ref_no
                                wrapper.delegate = self
                                wrapper.getWrapped(param)
                                
                            }
                        }
                    } } catch let error {
                        print(error)
                }
            }
        }
    }
}

extension AliPayHKClass : callBackFromAliPay {
    func getResponse(_ resultDic: [AnyHashable : Any]) {
        if (resultDic["memo"] != nil || resultDic["memo"] as! String != "" ) {
            if resultDic["resultStatus"] as! String == "9000" {
                PaySDK.shared.delegate?.paymentResult(result: (
                    PayResult.init(fromDictionary: ["successCode":"0",
                                                    "ref":(resultDic["orderRef"] ?? "") as! String,
                                                    "ord":(resultDic["orderId"] ?? "") as! String,
                                                    "errMsg":resultDic["memo"] as! String])))
            } else {
                PaySDK.shared.delegate?.paymentResult(result: (PayResult.init(fromDictionary:
                    ["successCode":resultDic["resultStatus"] as! String,
                     "ref":(resultDic["orderRef"] ?? "") as! String,
                     "ord":(resultDic["orderId"] ?? "") as! String,
                     "errMsg":resultDic["memo"] as! String])))
            }
        } else {
            var errMsg = ""
            if resultDic["resultStatus"] as! String == "9000" {
                errMsg = "Payment Success"
            } else if resultDic["resultStatus"] as! String == "8000" {
                errMsg = "Processing is in progress, payment result is unknown (it may have been paid successfully), please check the payment status of the order in the merchant order list"
            } else if resultDic["resultStatus"] as! String == "4000" {
                errMsg = "Payment failed"
            } else if resultDic["resultStatus"] as! String == "5000" {
                errMsg = "Repeat request"
            } else if resultDic["resultStatus"] as! String == "6001" {
                errMsg = "The user canceled halfway"
            } else if resultDic["resultStatus"] as! String == "6002" {
                errMsg = "Network connection error"
            } else if resultDic["resultStatus"] as! String == "6004" {
                errMsg = "The payment result is unknown (it may have been paid successfully), please check the payment status of the order in the merchant order list"
            }
            PaySDK.shared.delegate?.paymentResult(result: (
                PayResult.init(fromDictionary:
                    ["successCode":resultDic["resultStatus"] as! String,
                     "ref":(resultDic["orderRef"] ?? "") as! String,
                     "ord":(resultDic["orderId"] ?? "") as! String,
                     "errMsg": errMsg])))
        }
    }
}
