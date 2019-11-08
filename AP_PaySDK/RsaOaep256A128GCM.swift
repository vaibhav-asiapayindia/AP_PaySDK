//
//  RsaOaep256A128GCM.swift
//  SDKApp
//
//  Created by AsiaPay Limited on 12/03/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

import UIKit
import CommonCrypto

class RsaOaep256A128GCM: NSObject {
    static let sharedRSA = RsaOaep256A128GCM()
    var plainText = DeviceInfoPaySDK.sharedDeviceInfo.getDeviceInfo()
    var keyChain = KeyChainUtil()
    
    func encodeJWE(merchantPublicKey : String) -> String {
        do {
            let headerStr = "{\"alg\":\"RSA-OAEP\",\"kid\":\"\(DeviceInfoPaySDK.sharedDeviceInfo.deviceUUID)\",\"enc\":\"A128GCM\"}"
            var encipherStr = ""
            var ivStr : String
            var cText : String = ""
            var tagStr: String = ""
            let header64 = toBase64(dataR: headerStr.data(using: .utf8)!).removePaddingAndWrapping()
            let ivRandomByte = AES.randomIV(16)
            let aesRandomByte = try randomData(ofLength: 16)
            var publicKey = ""
            if merchantPublicKey == "" {
                publicKey = PlistInfo.sharedPlistInfo.getPublicKey(key:publicKeyFile).replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
            } else {
                publicKey = merchantPublicKey
            }
            let publicSecKeyRSA = publicKey.getPublicKeyRSA()
            var encryptedData : Data?
            let error2:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
            if let encryptedMessageData:Data = SecKeyCreateEncryptedData(publicSecKeyRSA!, .rsaEncryptionOAEPSHA1, Data.init(bytes: aesRandomByte) as CFData,error2) as Data?{
                encryptedData = encryptedMessageData
                _ = encryptedMessageData.map { Int8(bitPattern: $0) }
            }
            encipherStr = toBase64(dataR: encryptedData!).removePaddingAndWrapping()
            let timeStamp:String = String(format: "%.0f", NSDate().timeIntervalSince1970 * 1000)
            var dic:Dictionary = try (JSONSerialization.jsonObject(with: plainText.data(using: .utf8)!, options : .allowFragments) as? Dictionary<String,Any>)!
            dic["appId"] = Bundle.main.bundleIdentifier
            dic["time"] = timeStamp
            let dataString :String = String.init(data:  try JSONSerialization.data(withJSONObject: dic, options: []), encoding: .utf8)!
            let gcm = GCM.init(iv: ivRandomByte, additionalAuthenticatedData: header64.bytes, mode: .detached)
            let aes = try AES(key: aesRandomByte, blockMode: gcm, padding: .noPadding)
            let encryptedAES = try aes.encrypt(dataString.bytes)
            let tag = gcm.authenticationTag
            cText = encryptedAES.toBase64()!
            cText = cText.removePaddingAndWrapping()
            tagStr = toBase64(dataR: NSData(bytes: tag, length: tag!.count) as Data).removePaddingAndWrapping()
            ivStr = toBase64(dataR: Data.init(bytes: ivRandomByte)).removePaddingAndWrapping()
            _ = keyChain.saveGenericData(data: Data.init(bytes: aesRandomByte), account: "AESAccount", service: "AESService", key: "aesPassKey", overwrite: true)
            _ = keyChain.saveGenericData(data: Data.init(bytes: ivRandomByte), account: "AESAccount1", service: "AESService1", key: "ivPassKey", overwrite: true)
            let rtn = header64 + "." + encipherStr + "." + ivStr + "." + cText + "." + tagStr
            return rtn
        } catch let error {
            print(error)
        }
        return ""
    }
    
    
    func makePaymentEnc(dataString: String) -> String {
        //let keyChain = KeyChainUtil()
        let aesData = keyChain.loadData(account: "AESAccount", service: "AESService", key: "aesPassKey")
        let ivData = keyChain.loadData(account: "AESAccount1", service: "AESService1", key: "ivPassKey")
        let aesBytes = [UInt8](aesData!) //aesData.bytes
        let ivBytes = [UInt8](ivData!) //ivData.bytes
        let encryptedStr = dataString.aesGCMEncrypt(ivRandomBytes: ivBytes, aesRandomBytes:aesBytes)
        return encryptedStr
    }
    
    
    func decodeGCM(dataString: String) -> String {
        //let keyChain = KeyChainUtil()
        let aesData = keyChain.loadData(account: "AESAccount", service: "AESService", key: "aesPassKey")!
        let ivData = keyChain.loadData(account: "AESAccount1", service: "AESService1", key: "ivPassKey")!
        let aesBytes = [UInt8](aesData as Data) //aesData.bytes
        let ivBytes = [UInt8](ivData as Data) // ivData.bytes
        let decryptedStr = dataString.aesGCMDecrypt(ivRandomBytes: ivBytes, aesRandomBytes: aesBytes)
        return decryptedStr
    }
    
    
    func randomData(ofLength length: Int) throws -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        if status == errSecSuccess {
            return bytes
        }
        return []
    }
    
    func toBase64(dataR : Data) -> String {
        return dataR.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed).replacingOccurrences(of: "=", with: "")
    }
    
}
