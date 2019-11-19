//
//  MakePayment.swift
//  PayDollarSDK
//
//  Created by AsiaPay Limited on 14/02/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

import UIKit

class MakePayment: NSObject, jBridgeWebViewDelegate {
    
    var navigationVW : UINavigationController?
    static var shared = MakePayment()
    var complHandlerHosted : ((_ dataResponse: PayResult?) -> Void)?
    var url = ""
    
    private override init() {
        super.init()
    }
    
    func startPayment(dict : PayData,  Completion : @escaping (_ dataResponse: PayResult?) -> Void ) {
        var dicStr : String = ""
        let authToken = PaySDK.shared.sharedAuth.token!
        let directData1 = ["merchantId" : dict.merchantId!,
                           "orderRef" : dict.orderRef!,
                           "amount" : dict.amount!,
                           "currCode" : dict.currCode!.rawValue,
                           "lang" : dict.lang!.rawValue,
                           "payMethod" : dict.payMethod!.rawValue ,
                           "payType" : dict.payType!.rawValue as String,
                           "payGate" : dict.payGate!.rawValue,
                           "extraData" : dict.extraData] as [String : Any]
        do {
            let dicData1 = try JSONSerialization.data(withJSONObject: directData1, options: [])
            dicStr = String(data: dicData1, encoding: .utf8)!
        } catch {}
        //let dicData1 = try? JSONSerialization.data(withJSONObject: directData1, options: [])
        //let dicStr = String(data: dicData1!, encoding: .utf8)!
        let cipherText = RsaOaep256A128GCM.sharedRSA.makePaymentEnc(dataString: dicStr).removePaddingAndWrapping()
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + authToken
        ]
        let parameters = ["data":cipherText, "hash":"", "ts":"" ] as [String : Any]
        url = Environment().getbaseURL(payDetails: dict) + "paysdk-api/tx/direct"
        APIService.sharedInstance.makeRequest(serviceURL: url, method: .post, header: headers, postData: parameters) { dataResponse, Error in
            do {
                if Error != nil {
                    Completion((Error as! PayResult))
                }
                if (dataResponse as! Data).count == 0 {
                    PaySDK.shared.refreshToken()
                }
                else {
                    do {
                        let dataDic =  try JSONSerialization.jsonObject(with: dataResponse as! Data, options: []) as? NSDictionary
                        if dataDic != nil {
                            if dataDic?.value(forKey: "data") != nil {
                                let jsonDecoder = JSONDecoder()
                                let directCall = try jsonDecoder.decode(txResp.self, from: dataResponse as! Data)
                                let decryptedDirectCall = RsaOaep256A128GCM.sharedRSA.decodeGCM(dataString: directCall.data!)
                                let dic = try JSONSerialization.jsonObject(with: decryptedDirectCall.data(using: .utf8)!, options: .allowFragments)
                                Completion(PayResult(fromDictionary: dic as! [String : Any]))
                            }
                            else {
                                Completion(PayResult(fromDictionary: ["errMsg": (dataDic?["error"] as! String)]))
                            }
                        }
                    } catch {}
                }
            }
        }
    }
    
    
    
    
    func startHostedPayment(dict : PayData ,  Completion : @escaping (_ dataResponse: PayResult?) -> Void ) {
        var dicStr : String = ""
        let authToken = PaySDK.shared.sharedAuth.token!
        complHandlerHosted = Completion
        let directData1 = ["merchantId": dict.merchantId!,
                           "channelType" : dict.channelType!.rawValue,
                           "envType" : dict.envType!.rawValue,
                           "orderRef": dict.orderRef,
                           "amount": dict.amount,
                           "currCode": dict.currCode!.rawValue,
                           "lang": dict.lang!.rawValue,
                           "payMethod": dict.payMethod!.rawValue,
                           "payType": dict.payType!.rawValue as Any,
                           "payGate": dict.payGate!.rawValue,
                           "extraData" : dict.extraData] as [String : Any]
        do {
            let dicData1 = try JSONSerialization.data(withJSONObject: directData1, options: [])
            dicStr = String(data: dicData1, encoding: .utf8)!
        } catch {}
        let cipherText = RsaOaep256A128GCM().makePaymentEnc(dataString: dicStr).removePaddingAndWrapping()
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + authToken
        ]
        var parameters : [String : Any]
        if dict.extraData["cardNo"] != nil {
            parameters = ["data":cipherText, "hash":dicStr.md5(), "ts":"\((Date().timeIntervalSince1970 * 1000))" ] as [String : Any]
        } else {
            parameters = ["data":cipherText, "hash":"", "ts":"" ] as [String : Any]
        }
        url = Environment().getbaseURL(payDetails: dict) + "paysdk-api/tx/hosted"
        APIService.sharedInstance.makeRequest(serviceURL: url, method: .post, header: headers, postData: parameters) { dataResponse, Error in
            do {
                if Error != nil {
                    Completion((Error as! PayResult))
                }
                if (dataResponse as! Data).count == 0 {
                    PaySDK.shared.refreshToken()
                }
                else {
                    do {
                        let dataDic =  try JSONSerialization.jsonObject(with: dataResponse as! Data, options: []) as? NSDictionary
                        if dataDic != nil {
                            if dataDic?.value(forKey: "data") != nil {
                                let jsonDecoder = JSONDecoder()
                                let hostedCall = try jsonDecoder.decode(txResp.self, from: dataResponse as! Data)
                                let decryptedHostedCall = RsaOaep256A128GCM().decodeGCM(dataString: hostedCall.data!)
                                let dic = try JSONSerialization.jsonObject(with: decryptedHostedCall.data(using: .utf8)!, options: .allowFragments) as! [String : Any]
                                let btn1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(MakePayment.cancelView))
                                btn1.tintColor = UIColor.red
                                let viewController = HostViewController.init(request: dic["param"] as! [String : Any], url: dic["url"] as! String)
                                self.navigationVW = UINavigationController.init(rootViewController: viewController)
                                viewController.navigationItem.setRightBarButton(btn1, animated: true)
                                //add code
                                //let textAttributes = NSMutableDictionary()
                                //do {
                                //if try PaySDK.shared.uiCustomization!.getToolbarCustomization() != nil {
                                //if try PaySDK.shared.uiCustomization!.getToolbarCustomization().getTextColor() != "" {
                                //textAttributes.addEntries(from: [NSAttributedString.Key.foregroundColor:UIColor.init(hex: try PaySDK.shared.uiCustomization!.getToolbarCustomization().getTextColor())!])
                                //self.navigationVW!.navigationBar.titleTextAttributes = (textAttributes as! [NSAttributedString.Key : Any])
                                //} else {
                                //textAttributes.addEntries(from: [NSAttributedString.Key.foregroundColor: UIColor.white])
                                //self.navigationVW!.navigationBar.titleTextAttributes = (textAttributes as! [NSAttributedString.Key : Any])
                                //}
                                //if try PaySDK.shared.uiCustomization!.getToolbarCustomization().getTextFontName() != "" || PaySDK.shared.uiCustomization!.getToolbarCustomization().getTextFontSize() != 0 {
                                //textAttributes.addEntries(from: [NSAttributedString.Key.font : UIFont(name: try PaySDK.shared.uiCustomization!.getToolbarCustomization().getTextFontName(), size: CGFloat(try PaySDK.shared.uiCustomization!.getToolbarCustomization().getTextFontSize())) as Any])
                                //self.navigationVW!.navigationBar.titleTextAttributes = (textAttributes as! [NSAttributedString.Key : Any])
                                //} else {
                                //textAttributes.addEntries(from: [NSAttributedString.Key.font : UIFont(name: "Courier", size: 15) as Any])
                                //self.navigationVW!.navigationBar.titleTextAttributes = (textAttributes as! [NSAttributedString.Key : Any])
                                //}
                                //if try PaySDK.shared.uiCustomization!.getToolbarCustomization().getHeaderText() != "" {
                                //viewController.title = try PaySDK.shared.uiCustomization!.getToolbarCustomization().getHeaderText()
                                //} else {
                                //viewController.title = "SECURE CHECKOUT"
                                //}
                                //if try PaySDK.shared.uiCustomization!.getToolbarCustomization().getBackgroundColor() != "" {
                                //self.navigationVW!.navigationBar.barTintColor = UIColor.init(hex: try PaySDK.shared.uiCustomization!.getToolbarCustomization().getBackgroundColor())
                                //self.navigationVW!.navigationBar.tintColor = UIColor.white
                                //}
                                //}
                                //} catch let error {
                                //print(error)
                                //}
                                self.navigationVW!.navigationBar.barTintColor = UIColor(red: 45/255, green: 83/255, blue: 196/255, alpha: 1)
                                self.navigationVW!.navigationBar.tintColor = UIColor.white
                                self.navigationVW!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                                viewController.bridgeDelegate = self
                                UIApplication.shared.keyWindow?.rootViewController?.present(self.navigationVW!, animated: true, completion: nil)
                            } else {
                                Completion(PayResult(fromDictionary: ["errMsg": (dataDic?["error"] as! String)]))
                            }
                        }
                    }catch {}
                }
            }
        }
    }
    
    
    @objc func cancelView() {
        navigationVW!.dismiss(animated: true, completion: nil)
        complHandlerHosted!(PayResult.init(fromDictionary: ["errMsg":"Cancel Payment"]))
    }
    
    
    func startIndirectPayment(dict : PayData ,  Completion : @escaping (_ dataResponse: PayResult?) -> Void ) {
        var dicStr : String = ""
        let authToken = PaySDK.shared.sharedAuth.token
        let directData1 = ["merchantId":dict.merchantId!,
                           "channelType" : dict.channelType!.rawValue,
                           "envType" : dict.envType!.rawValue,
                           "orderRef":dict.orderRef,
                           "amount":dict.amount,
                           "currCode": dict.currCode!.rawValue,
                           "lang":dict.lang!.rawValue,
                           "payMethod":dict.payMethod!.rawValue,
                           "payType":dict.payType!.rawValue,
                           "extraData" : dict.extraData] as [String : Any]
        do {
            let dicData1 = try JSONSerialization.data(withJSONObject: directData1, options: [])
            dicStr = String(data: dicData1, encoding: .utf8)!
        } catch {}
        let cipherText = RsaOaep256A128GCM().makePaymentEnc(dataString: dicStr).removePaddingAndWrapping()
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + authToken!
        ]
        let parameters = ["data":cipherText, "hash":"", "ts":"" ] as [String : Any]
        url = Environment().getbaseURL(payDetails: dict) + "paysdk-api/tx/indirect"
        APIService.sharedInstance.makeRequest(serviceURL: url, method: .post, header: headers, postData: parameters) { dataResponse, Error in
            do {
                if Error != nil {
                    Completion((Error as! PayResult))
                }
                let jsonDecoder = JSONDecoder()
                let indirectCall = try jsonDecoder.decode(txResp.self, from: dataResponse as! Data)
                let decryptedIndirectCall = RsaOaep256A128GCM().decodeGCM(dataString: indirectCall.data!)
                let dic = try JSONSerialization.jsonObject(with: decryptedIndirectCall.data(using: .utf8)!, options: .allowFragments) as! [String : Any]
                Completion(PayResult(fromDictionary: dic))
            }
            catch {}
        }
    }
    
    
    func jBridgeWebView_txSuccess(json: String) {
        do {
            let json1 = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            complHandlerHosted!(PayResult.init(fromDictionary: json1))
            navigationVW!.dismiss(animated: true, completion: nil)
        } catch{}
    }
    
    
    func jBridgeWebView_txFail(json: String) {
        do {
            let json1 = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            complHandlerHosted!(PayResult.init(fromDictionary:json1))
            navigationVW!.dismiss(animated: true, completion: nil)
        } catch{}
    }
    
    
    func jBridgeWebView_txCancel(json: String) {
        do {
            let json1 = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            complHandlerHosted!(PayResult.init(fromDictionary: json1))
            navigationVW!.dismiss(animated: true, completion: nil)
        } catch{}
    }
    
    
    func jBridgeWebView_txError(json: String) {
        do {
            let json1 = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            complHandlerHosted!(PayResult.init(fromDictionary: json1))
            navigationVW!.dismiss(animated: true, completion: nil)
        } catch {}
    }
    
    
    func jBridgeWebView_txPrint(json: String) {
        do {
            let json1 = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            complHandlerHosted!(PayResult.init(fromDictionary: json1))
            navigationVW!.dismiss(animated: true, completion: nil)
        } catch{}
    }
    
    
    func jBridgeWebView_setResult(json: String) {
        do {
            let json1 = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            //PaySDKClass.shared.paymentDetails =
            complHandlerHosted!(PayResult.init(fromDictionary: json1))
        } catch{}
        //navigationVW!.dismiss(animated: true, completion: nil)
    }
    
    
    func jBridgeWebView_handleClick() {
        PaySDK.shared.process()
    }
    
    
    
    func paymentCallBack(paymentResult: PayResult) {
        complHandlerHosted!(paymentResult)
    }
    
}
