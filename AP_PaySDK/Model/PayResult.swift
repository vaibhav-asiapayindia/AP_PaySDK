

import Foundation

public class PayResult {
    
    public var amount : String!
    public var successCode : String!
    public var maskedCardNo : String?
    public var authId : String!
    public var cardHolder : String!
    public var currencyCode : String!
    public var errMsg : String!
    public var ord : String!
    public var payRef : String!
    public var prc : String!
    public var ref : String!
    public var src : String!
    public var transactionTime : String!
    public var description: String!
    public var payMethod : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        amount = dictionary["Amt"] as? String
        maskedCardNo = dictionary ["MaskedCardNo"] as? String
        successCode = dictionary["successcode"] as? String
        authId = dictionary["AuthId"] as? String
        cardHolder = dictionary["Holder"] as? String
        currencyCode = dictionary["Cur"] as? String
        errMsg = dictionary["errMsg"] as? String
        ord = dictionary["Ord"] as? String
        payRef = dictionary["PayRef"] as? String
        prc = dictionary["prc"] as? String
        if dictionary["Ref"] != nil {
            ref = dictionary["Ref"] as? String
        } else {
            ref = dictionary["ref"] as? String
        }
        src = dictionary["src"] as? String
        transactionTime = dictionary["TxTime"] as? String
        payMethod = dictionary["PayMethod"] as? String
        description = getDescription()
    }
    
    func getDescription() -> String {
        switch prc {
        case "0":
            return "Transaction Success"
        case "3":
            return "Transaction Rejected due to Payer Authentication Failure (3D)"
        case "-1":
            return "Transaction Rejected due to Input Parameters Incorrect"
        case "-2":
            return "Transaction Rejected due to Server Access Error"
        case "-8":
            return "Transaction Rejected due to PayDollar Internal/Fraud Prevention Checking"
        case "-9":
            return "Transaction Rejected by Host Access Error"
        default:
            return ""
        }
    }
}
