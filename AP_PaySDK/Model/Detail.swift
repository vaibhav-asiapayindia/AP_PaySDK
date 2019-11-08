
import Foundation

struct Detail : Codable {
    
    let alertCode : String?
    let amount : String?
    let authId : String?
    let cardHolder : String?
    let cardIssuingCountry : String?
    let channelType : String?
    let currCode : String?
    let eci : String?
    let errMsg : String?
    let ipCountry : String?
    let merchantId : String?
    let ord : String?
    let orderStatus : String?
    let payMethod : String?
    let payRef : String?
    let payerAuth : String?
    let prc : PRC?
    let ref : String?
    let remark : String?
    let sourceIp : String?
    let src : Src?
    let txTime : String?
    
    
    enum CodingKeys: String, CodingKey {
        case alertCode = "alertCode"
        case amount = "amount"
        case authId = "authId"
        case cardHolder = "cardHolder"
        case cardIssuingCountry = "cardIssuingCountry"
        case channelType = "channelType"
        case currCode = "currCode"
        case eci = "eci"
        case errMsg = "errMsg"
        case ipCountry = "ipCountry"
        case merchantId = "merchantId"
        case ord = "ord"
        case orderStatus = "orderStatus"
        case payMethod = "payMethod"
        case payRef = "payRef"
        case payerAuth = "payerAuth"
        case prc = "prc"
        case ref = "ref"
        case remark = "remark"
        case sourceIp = "sourceIp"
        case src = "src"
        case txTime = "txTime"
    }
}

