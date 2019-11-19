 
 
 import UIKit
 
 class AliPayClass: NSObject {
    var out_trade_nostr = ""
    var order_ref_no = ""
    var orderInfo = ""
    var jsonDict : [String : Any]?
    
    override init() {
        super.init()
    }
    
    
    func Pay(pay :PayData) {
        var isValid : Bool = false
        var dicStr : String = ""
        isValid = pay.isValidInput()
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
                            let jsonStr = String.init(data: dataResponse as! Data, encoding: .utf8)!
                            if jsonStr != "" {
                                //var param = ""
                                //let jsonArr = jsonStr.components(separatedBy: "&")
                                //self.jsonDict = self.decipherIngredients(jsonStr)
                                self.jsonDict = jsonStr.decipherIngredients()
                                let errcode = self.jsonDict!["errMsg"]
                                self.orderInfo = errcode as! String;
                                self.out_trade_nostr =  self.jsonDict!["PayRef"] as! String
                                self.order_ref_no =  self.jsonDict!["Ref"] as! String
                                if (self.orderInfo as String != "") {
                                    if (pay.envType == .SANDBOX) {
                                        //EnvUtils.setEnv(EnvUtils.EnvEnum.SANDBOX);
                                    } else {
                                        //EnvUtils.setEnv(EnvUtils.EnvEnum.ONLINE);
                                    }
                                    self.orderInfo = self.orderInfo.removingPercentEncoding!
                                }
                                //for i in jsonArr {
                                //if i.contains("errMsg") {
                                //param = i
                                //break
                                //}
                                //}
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
 
 extension AliPayClass : callBackFromAliPay {
    func getResponse(_ resultDic: [AnyHashable : Any]) {
        AliPayHKClass().getResponse(resultDic)
    }
 }
 
