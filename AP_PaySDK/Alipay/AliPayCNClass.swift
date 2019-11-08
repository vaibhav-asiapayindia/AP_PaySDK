


import UIKit
import Foundation

class AliPayCNClass: NSObject {
    var out_trade_nostr = ""
    var order_ref_no = ""
    var orderInfo = ""
    var jsonDict : [String : Any]?
    
    override init() {
        super.init()
    }
    
    func PayV2(pay :PayData) {
        var isValid : Bool = false
        var dicStr = ""
        isValid = pay.isValidInput()
        if isValid {
            let url_str = Environment().getbaseURL(payDetails: pay) + "paysdk-api/tx/direct"
            let authToken = PaySDK.shared.sharedAuth.token!
            //            let secureHash = pay.generatePaymentSecureHash()
            let parameterDict = ["merchantId" : pay.merchantId!,
                                 "orderRef" : pay.orderRef!,
                                 "amount" : pay.amount!,
                                 "currCode" : pay.currCode!.rawValue,
                                 "lang" : pay.lang!.rawValue,
                                 "payMethod" : pay.payMethod!,
                                 "payType" : pay.payType!.rawValue as String,
                                 "payGate" : pay.payGate!.rawValue] as [String : Any]
            do {
                let dicData1 = try JSONSerialization.data(withJSONObject: parameterDict, options: [])
                dicStr = String(data: dicData1, encoding: .utf8)!
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
                            //                            var paramArr = param.components(separatedBy: "&")
                            if param != "" {
                                //                                var paramArr = param.components(separatedBy: "&")
                                //                            let jsonStr = String.init(data: dataResponse as! Data, encoding: .utf8)!
                                //                            if jsonStr != "" {
                                //var param = ""
                                //let jsonArr = jsonStr.components(separatedBy: "&")
                                //                                self.jsonDict = jsonStr.decipherIngredients()
                                self.jsonDict = str.decipherIngredients()
                                let errcode = self.jsonDict!["errMsg"]
                                self.orderInfo = errcode as! String;
                                self.out_trade_nostr =  self.jsonDict!["PayRef"] as! String
                                self.order_ref_no =  self.jsonDict!["Ref"] as! String
                                self.orderInfo = self.orderInfo.removingPercentEncoding!
                                //for i in jsonArr {
                                //if i.contains("errMsg") {
                                //param = i
                                //break
                                //}
                                //}
                                //APIService.sharedInstance.addLog(message: "AliPayCN param : \(param)")
                                //param = param.replacingOccurrences(of: "errMsg=", with: "")//.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: "")
                                //while param.contains("%") {
                                //param = param.removingPercentEncoding!
                                //}
                                //
                                //param = param.replacingOccurrences(of: "+", with: " ")
                                //
                                //let asd2 = param.components(separatedBy: "&")
                                //for j in asd2 {
                                //if j.contains("out_trade_no") {
                                //let j1 = j.replacingOccurrences(of: "biz_content=", with: "")
                                //let js = try JSONSerialization.jsonObject(with: j1.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: String]
                                //self.out_trade_nostr = js["out_trade_no"]!
                                //self.order_ref_no = pay.orderRef
                                //break
                                //}
                                //}
                                DispatchQueue.main.async {
                                    let wrapper =  Wrapper.shared()
                                    wrapper.order_id = self.out_trade_nostr
                                    wrapper.order_ref = self.order_ref_no
                                    wrapper.delegate = self
                                    wrapper.getWrappedV2(self.orderInfo)
                                }
                            }
                        }
                    }} catch let error {
                        print(error)
                }
            }
        }
    }
    
}

extension String {
    func decipherIngredients() -> [String : Any] {
        var decipheredIngredients : [String:Any] = [:]
        let keyValueArray = self.components(separatedBy: "&")
        for keyValue in keyValueArray {
            let components = keyValue.components(separatedBy: "=")
            decipheredIngredients[(components[0])] = components[1]
        }
        return decipheredIngredients
    }
}

extension AliPayCNClass : callBackFromAliPay {
    func getResponse(_ resultDic: [AnyHashable : Any]) {
        AliPayHKClass().getResponse(resultDic)
    }
}
