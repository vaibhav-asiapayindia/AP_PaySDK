
import Foundation
import CommonCrypto

public struct PayData {
    
    //public var threeDSParams : ThreeDSParams?
    var amount : String!
    var channelType: PayChannel?
    var envType : EnvType?
    var merchantId: String?
    var orderRef : String!
    var currCode : currencyCode?
    var lang : Language?
    var payMethod : payMethod?
    var payType : payType?
    var securityCode : String?
    var payGate : PayGate?
    var remark : String?
    var secureMethod = SecureMethod.NONE
    var secureHashSecret = ""
    public var cardDetails : CardDetails?
    var extraData: [String : Any]!
    
    
    public init(channelType : PayChannel,
                envType : EnvType,
                amount : String,
                payGate : PayGate,
                currCode : currencyCode,
                payType : payType,
                orderRef : String,
                payMethod : payMethod,
                lang : Language,
                merchantId : String,
                remark : String,
                extraData : [String : Any]?) {
        self.amount = amount
        self.channelType = channelType
        self.envType = envType
        self.merchantId = merchantId
        self.currCode = currCode
        self.lang = lang
        self.orderRef = orderRef
        self.payMethod = payMethod
        self.payType = payType
        self.payGate = payGate
        self.extraData = extraData
        self.remark = remark
    }
    
}

extension PayData {
    
    func isValidInput() -> Bool {
        if self.merchantId == "" {
            fatalError("Merchant ID cannot be blank")
            //return false
        }
        if self.amount == "" || self.amount.floatValue <= 0.0 {
            fatalError("Amount incorrect")
            //return false
        }
        if self.orderRef == "" {
            return false
        }
        return true
    }
    
    //Generate Payment secure hash
    func generatePaymentSecureHash() -> String {
        if self.secureMethod == .NONE {
            return ""
        }
        var buffer : String = ""
        buffer = "\(String(describing: self.merchantId!))\("|")\(String(describing: self.orderRef!))\("|")\(String(describing: self.currCode!.rawValue))\("|")\(String(describing: self.amount!))\("|")\(String(describing: self.payType!.rawValue))\("|")\(self.secureHashSecret)"
        if self.secureMethod == SecureMethod.MD5 {
            return buffer.md5()
        } else if self.secureMethod == SecureMethod.SHA_1 {
            return buffer.sha1()
        }
        return ""
    }
}


extension String {
    // func mD5(_ string: String) -> String? {
    func getMerchantId(paygate: PayGate) -> String {
        var merchantId = ""
        switch(paygate) {
        case PayGate.PAYDOLLAR:
            merchantId = paygate.rawValue + "-" + self;
            break;
        case PayGate.SIAMPAY:
            merchantId = paygate.rawValue + "-" + self;
            break;
        case PayGate.PESOPAY:
            merchantId = paygate.rawValue + "-" + self;
            break;
        }
        return merchantId;
    }
    
    
    func mD5() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = self.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
    //func sha1(securestr : String) -> String? {
    func sha1() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        let hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            CC_SHA1(bytes, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
