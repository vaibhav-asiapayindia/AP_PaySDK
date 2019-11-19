//
//  ViewController.swift
//  SDKApp
//
//  Created by Priyanka Gore on 08/01/19.
//  Copyright © 2019 Asiapay. All rights reserved.
//

import UIKit
import AP_PaySDK
//import PassKit
import WebKit


class ViewController: UIViewController , PaySDKDelegate {
    
    @IBOutlet weak var bthAuthCall: UIButton!
    @IBOutlet weak var btnDirectCall: UIButton!
    @IBOutlet weak var lblResponse: UILabel!
    @IBOutlet var btnApplePay: UIButton!
    
    @IBOutlet var btnAliPayHK: UIButton!
    
    @IBOutlet weak var txtCardName: UITextField!
    @IBOutlet weak var txtOrderRef: UITextField!
    @IBOutlet weak var txtExMonth: UITextField!
    @IBOutlet weak var txtExYear: UITextField!
    @IBOutlet weak var txtSecurityCode: UITextField!
    @IBOutlet weak var txtCardNo: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    
    var paySDK = PaySDK.shared
    let memberPayToken = "8472265e546643a095be287b9db3906d788b32cc5005"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let customization = UiCustomization()
        //let submitButtonCustomization = ButtonCustomization.init("Courier", "#FF0000", 15, "#d3d3d3", 4)
        //let resendButtonCustomization = ButtonCustomization.init("Courier", "#FF0000", 15, "#d3d3d3", 4)
        //let cancelButtonCustomization = ButtonCustomization.init("Courier", "#FF0000", 15, "#d3d3d3", 4)
        //let nextButtonCustomization = ButtonCustomization.init("Courier", "#FF0000", 15, "#d3d3d3", 4)
        //let continueButtonCustomization = ButtonCustomization.init("Courier", "#FF0000", 15, "#d3d3d3", 4)
        //let labelCustomization = LabelCustomization.init("Courier", "FF0000", 14, "FF0000", "Courier", 20)
        //let textboxCustomization = TextBoxCustomization.init("Courier", "#FF0000", 14, 5, "#d3d3d3", 4)
        //let toolBarCustomization = ToolbarCustomization.init("Courier", "#FFFFFF", 20, "#000000", "")
        //
        //try! customization.setButtonCustomization(submitButtonCustomization, .SUBMIT)
        //try! customization.setButtonCustomization(resendButtonCustomization, .RESEND)
        //try! customization.setButtonCustomization(cancelButtonCustomization, .CANCEL)
        //try! customization.setButtonCustomization(nextButtonCustomization, .NEXT)
        //try! customization.setButtonCustomization(continueButtonCustomization, .CONTINUE)
        //try! customization.setLabelCustomization(labelCustomization)
        //try! customization.setTextBoxCustomization(textboxCustomization)
        //try! customization.setToolbarCustomization(toolBarCustomization)
        //paySDK.uiCustomization = customization
        
        paySDK.delegate = self
        //btnApplePay.setApplePayButton(btnType: ApplePayButtonType.Buy, btnStyle: ApplePayButtonStyle.Black, view : self.view)
        
        
    }
    
    @IBAction func threedsbtnClick(_ sender: Any) {
        //
        ////txtCardNo.text = "4012000000020084"    //WebView
        ////txtCardNo.text = "4012000000020086"    //challenge flow
        ////txtCardNo.text = "4012000000020090"    //frictionless flow
        //txtCardNo.text = "4012000000020089"      //Call Notifly Test
        //txtOrderRef.text = "4335900000140067Ref"
        //txtExYear.text = "2030"
        //
        //paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT, envType: EnvType.SANDBOX, amount: txtAmount.text!, payGate: PayGate.PAYDOLLAR, currCode: currencyCode.HKD, payType: payType.NORMAL_PAYMENT, orderRef: txtOrderRef.text!, payMethod: "3DS2.0", lang: Language.ENGLISH, merchantId: "88146271", remark: "", extraData: [:])
        //
        //paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: txtCardName.text!, cardNo: txtCardNo.text!, expMonth: txtExMonth.text!, expYear: txtExYear.text!, securityCode: txtSecurityCode.text!)
        //
        //var threeDSParams = ThreeDSParams()
        //threeDSParams.apiUsername = "a997001508"
        //threeDSParams.apiPassword = "a997001508"
        //threeDSParams.threeDSCustomerEmail = "example@example.com"
        //threeDSParams.threeDSDeliveryEmail = "example@example.com"
        //threeDSParams.threeDSMobilePhoneCountryCode = "852"
        //threeDSParams.threeDSMobilePhoneNumber = "9000000000"
        //threeDSParams.threeDSHomePhoneCountryCode = "852"
        //threeDSParams.threeDSHomePhoneNumber = "8000000000"
        //threeDSParams.threeDSWorkPhoneCountryCode = "852"
        //threeDSParams.threeDSWorkPhoneNumber = "7000000000"
        //threeDSParams.threeDSBillingCountryCode = "344"
        //threeDSParams.threeDSBillingState = ""
        //threeDSParams.threeDSBillingCity = "Hong Kong"
        //threeDSParams.threeDSBillingLine1 = "threeDSBillingLine1"
        //threeDSParams.threeDSBillingLine2 = "threeDSBillingLine2"
        //threeDSParams.threeDSBillingLine3 = "threeDSBillingLine3"
        //threeDSParams.threeDSBillingPostalCode = "121245"
        //threeDSParams.threeDSShippingDetails = "01"
        //threeDSParams.threeDSShippingCountryCode = "344"
        //threeDSParams.threeDSShippingState = ""
        //threeDSParams.threeDSShippingCity = "Hong Kong"
        //threeDSParams.threeDSShippingLine1 = "threeDSShippingLine1"
        //threeDSParams.threeDSShippingLine2 = "threeDSShippingLine2"
        //threeDSParams.threeDSShippingLine3 = "threeDSShippingLine3"
        //threeDSParams.threeDSAcctCreateDate = "20190401"
        //threeDSParams.threeDSAcctAgeInd = "01"
        //threeDSParams.threeDSAcctLastChangeDate = "20190401"
        //threeDSParams.threeDSAcctLastChangeInd = "01"
        //threeDSParams.threeDSAcctPwChangeDate = "20190401"
        //threeDSParams.threeDSAcctPwChangeInd = "01"
        //threeDSParams.threeDSAcctPurchaseCount = "10"
        //threeDSParams.threeDSAcctCardProvisionAttempt = "0"
        //threeDSParams.threeDSAcctNumTransDay = "0"
        //threeDSParams.threeDSAcctNumTransYear = "1"
        //threeDSParams.threeDSAcctPaymentAcctDate = "20190401"
        //threeDSParams.threeDSAcctPaymentAcctInd = "01"
        //threeDSParams.threeDSAcctShippingAddrLastChangeDate = "20190401"
        //threeDSParams.threeDSAcctShippingAddrLastChangeInd = "01"
        //threeDSParams.threeDSAcctIsShippingAcctNameSame = "T"
        //threeDSParams.threeDSAcctIsSuspiciousAcct = "F"
        //threeDSParams.threeDSAcctAuthMethod = "01"
        //threeDSParams.threeDSAcctAuthTimestamp = "20190401"
        //threeDSParams.threeDSDeliveryTime = "04"
        //threeDSParams.threeDSPreOrderReason = "01"
        //threeDSParams.threeDSPreOrderReadyDate = "20190401"
        //threeDSParams.threeDSGiftCardAmount = "5"
        //threeDSParams.threeDSGiftCardCurr = "344"
        //threeDSParams.threeDSGiftCardCount = "1"
        //threeDSParams.threeDSSdkMaxTimeout = "05"
        //threeDSParams.threeDSSdkInterface = "03"
        //paySDK.paymentDetails.threeDSParams = threeDSParams
        ////paySDK.process()
    }
    
    @IBAction func onDirectCall(_ sender: Any) {
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: EnvType.SANDBOX,
                                        amount : txtAmount.text!,
                                        payGate: PayGate.PAYDOLLAR,
                                        currCode: currencyCode.HKD,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: txtOrderRef.text!,
                                        payMethod: payMethod.VISA,
                                        lang: Language.ENGLISH,
                                        merchantId: "88144151",//"1036",//"88144151",
            remark: "",
            extraData :  ["installment_service" : "T",
                          "installment_period" : 6,
                          "installOnly": "T"])
        paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: txtCardName.text!, cardNo: txtCardNo.text!, expMonth: txtExMonth.text!, expYear: txtExYear.text!, securityCode: txtSecurityCode.text!)
        paySDK.process()
    }
    
    @IBAction func onHostedCall(_ sender: Any) {
        paySDK.paymentDetails = PayData(channelType : PayChannel.WEBVIEW,
                                        envType : EnvType.SANDBOX,
                                        amount : txtAmount.text!,
                                        payGate : PayGate.PAYDOLLAR,
                                        currCode : currencyCode.HKD,
                                        payType : payType.NORMAL_PAYMENT,
                                        orderRef : txtOrderRef.text!,
                                        payMethod : payMethod.VISA,
                                        lang : Language.ENGLISH,
                                        merchantId : "88144151",
                                        remark : "",
                                        extraData: [:])
        paySDK.process()
    }
    
    @IBAction func onApplePayCall() {
        
        //paySDK.paymentDetails = PayData(channelType : PayChannel.DIRECT,
        //envType : EnvType.SANDBOX,
        //amount : "15",
        //payGate : PayGate.PAYDOLLAR,
        //currCode : currencyCode.HKD,
        //payType : payType.NORMAL_PAYMENT,
        //orderRef : "560200353ref",
        //payMethod : "APPLEPAY",
        //lang : Language.ENGLISH,
        //merchantId : "88144151",
        //remark : "",
        //extraData: ["apple_countryCode" : "US",
        //"apple_currencyCode" : "USD",
        //"apple_billingContactEmail" : "abc@gmail.com",
        //"apple_billingContactPhone" : "1234567890",
        //"apple_billingContactGivenName" : "ABC",
        //"apple_billingContactFamilyName" : "XYZ",
        //"apple_requiredBillingAddressFields" : ""])
        
        //paySDK.process()
    }
    
    @IBAction func onMemberPayCall(_ sender: Any) {
        var extraData = [String : Any]()
        extraData["memberPay_memberId"] = "member03"
        extraData["memberPay_service"] = "T"
        if memberPayToken == "" {
            extraData["addNewMember"] = true
        } else {
            extraData["addNewMember"] = false
            extraData["memberPay_token"] = memberPayToken
        }
        paySDK.paymentDetails = PayData(channelType : PayChannel.DIRECT,
                                        envType : EnvType.SANDBOX,
                                        amount : txtAmount.text!,
                                        payGate : PayGate.PAYDOLLAR,
                                        currCode : currencyCode.HKD,
                                        payType : payType.NORMAL_PAYMENT,
                                        orderRef : txtOrderRef.text!,
                                        payMethod : payMethod.VISA,
                                        lang : Language.ENGLISH,
                                        merchantId : "88144151",
                                        remark : "",
                                        extraData: extraData)
        
        if memberPayToken == "" {
            paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: txtCardName.text!, cardNo: txtCardNo.text!, expMonth: txtExMonth.text!, expYear: txtExYear.text!, securityCode: txtSecurityCode.text!)
        }
        else {
            paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: "", cardNo: "", expMonth: "", expYear: "", securityCode: txtSecurityCode.text!)
        }
        paySDK.process()
    }
    
    
    @IBAction func onSchedulePay() {
        paySDK.paymentDetails =  PayData(channelType : PayChannel.DIRECT,
                                         envType : EnvType.SANDBOX,
                                         amount : txtAmount.text!,
                                         payGate : PayGate.PAYDOLLAR,
                                         currCode : currencyCode.HKD,
                                         payType : payType.NORMAL_PAYMENT,
                                         orderRef : txtOrderRef.text!,
                                         payMethod : payMethod.VISA,
                                         lang : Language.ENGLISH,
                                         merchantId : "88144151",
                                         remark : "",
                                         extraData: ["appId" : "SP",
                                                     "appRef" : txtOrderRef.text!,
                                                     "installment_service " : "T",
                                                     "installment_period" : 6,
                                                     "installOnly": "T",
                                                     "schType" : "Day",
                                                     "schStatus" : "Active",
                                                     "nSch" : "1",
                                                     "sMonth" : "4",
                                                     "sDay" : "26",
                                                     "sYear" : "2019",
                                                     "eMonth" : "",
                                                     "eDay" : "",
                                                     "eYear" : "",
                                                     "name" : "Name",
                                                     "email" : "name@abc.com"])
        paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: txtCardName.text!, cardNo: txtCardNo.text!, expMonth: txtExMonth.text!, expYear: txtExYear.text!, securityCode: txtSecurityCode.text!)
        paySDK.process()
    }
    
    
    @IBAction func onWechatPayCall(_ sender: Any) {
        //paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
        //envType: EnvType.SANDBOX,
        //amount: "1",
        //payGate: PayGate.PAYDOLLAR,
        //currCode: currencyCode.RMB,
        //payType: payType.NORMAL_PAYMENT,
        //orderRef: "560200500orderRef",
        //payMethod: "WECHATAPP",
        //lang: Language.ENGLISH,
        //merchantId: "560200500",
        //remark: "test remark",
        //extraData : [:])
        //paySDK.process()
    }
    
    
    @IBAction func onAlipayHKCall(_ sender: Any) {
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: EnvType.PRODUCTION,
                                        amount: "1",
                                        payGate: PayGate.PAYDOLLAR,
                                        currCode: currencyCode.HKD,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: "560200353Ref",
                                        payMethod: payMethod.ALIPAYHKAPP,
                                        lang: Language.ENGLISH,
                                        merchantId: "1036",
                                        remark: "test",
                                        extraData : [:])
        paySDK.process()
    }
    
    
    @IBAction func onAliPayCNCall(_ sender: Any) {
        
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: EnvType.PRODUCTION,
                                        amount: "1",
                                        payGate: PayGate.PAYDOLLAR,
                                        currCode: currencyCode.RMB,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: "560200269Ref",
                                        payMethod: payMethod.ALIPAYCNAPP,
                                        lang: Language.ENGLISH,
                                        merchantId: "1036",//"560200269",
            remark: "test",
            extraData : [:])
        paySDK.process()
    }
    
    
    @IBAction func onAliPayGlobalCall(_ sender: Any) {
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: EnvType.PRODUCTION,
                                        amount: "1",
                                        payGate: PayGate.PAYDOLLAR,
                                        currCode: currencyCode.HKD,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: "560200439Ref",
                                        payMethod: payMethod.ALIPAYAPP,
                                        lang: Language.ENGLISH,
                                        merchantId: "1036",//"560200439",
            remark: "test",
            extraData : [:])
        paySDK.process()
    }
    
    
    @IBAction func onPromoPayCall(_ sender: Any) {
        paySDK.paymentDetails = PayData(channelType : PayChannel.DIRECT,
                                        envType : EnvType.SANDBOX,
                                        amount : txtAmount.text!, 
                                        payGate : PayGate.PAYDOLLAR,
                                        currCode : currencyCode.HKD,
                                        payType : payType.NORMAL_PAYMENT,
                                        orderRef : txtOrderRef.text!,
                                        payMethod : payMethod.VISA,
                                        lang : Language.ENGLISH,
                                        merchantId : "88144151",
                                        remark : "",
                                        extraData: ["promotion": "T",
                                                    "promotionCode": "TEST1",
                                                    "promotionRuleCode" : "TESTR25",//"TESTR50"
                                            "promotionOriginalAmt":"5"])
        paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: txtCardName.text!, cardNo: txtCardNo.text!, expMonth: txtExMonth.text!, expYear: txtExYear.text!, securityCode: txtSecurityCode.text!)
        
        paySDK.process()
    }
    
    //MARK: ----PaySDK Delegate ----
    func paymentResult(result: PayResult) {
        //print("Payment result: \(result)")
        //lblResponse.text = result.toJson()
        lblResponse.text = result.errMsg
    }
}
