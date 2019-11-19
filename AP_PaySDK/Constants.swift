//
//  Constants.swift
//  PayDollarSDK
//
//  Created by AsiaPay Limited on 15/02/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//


import UIKit
import CommonCrypto

let ConfigFile              = "paysdk.plist"
let publicKeyFile           = "SDK_RSA_PublicKey"

class Environment {
    func getbaseURL(payDetails: PayData) -> String {
        var url_str = ""
        if payDetails.envType == EnvType.SANDBOX {
            if payDetails.payGate == .PAYDOLLAR {
                url_str = PayGate_uat.PAYDOLLAR.rawValue
            } else if payDetails.payGate == .PESOPAY {
                url_str = PayGate_uat.PESOPAY.rawValue
            } else if payDetails.payGate == .SIAMPAY {
                url_str = PayGate_uat.SIAMPAY.rawValue
            }
        }
        if payDetails.envType == EnvType.PRODUCTION {
            if payDetails.payGate == .PAYDOLLAR {
                url_str = PayGate_production.PAYDOLLAR.rawValue
            } else if payDetails.payGate == .PESOPAY {
                url_str = PayGate_production.PESOPAY.rawValue
            } else if payDetails.payGate == .SIAMPAY {
                url_str = PayGate_production.SIAMPAY.rawValue
            }
        }
        return url_str
    }
    
}


extension String {
    
    func aesGCMEncrypt(ivRandomBytes:[UInt8], aesRandomBytes:[UInt8]) -> String {
        do {
            let gcm = GCM(iv: ivRandomBytes, mode: .combined)
            let aes = try AES(key: aesRandomBytes, blockMode: gcm, padding: .noPadding)
            let encryptedAES = try aes.encrypt(self.bytes)
            let result = encryptedAES.toBase64()!.removePaddingAndWrapping()
            return result
        } catch let error {
            print(error)
        }
        return ""
    }
    
    
    func aesGCMDecrypt(ivRandomBytes:[UInt8], aesRandomBytes:[UInt8]) -> String {
        do {
            let jweDecoded = self.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/").base64Decoded
            let gcm = GCM(iv: ivRandomBytes, mode: .combined)
            let aes = try AES(key: aesRandomBytes, blockMode: gcm, padding: .noPadding)
            var decryptedAES = [UInt8]()
            decryptedAES = try aes.decrypt(jweDecoded!.bytes)
            let result = String(bytes: decryptedAES, encoding: .utf8)!
            return result
        } catch  {
        }
        return ""
    }
    
    
    func getPrivateKeyRSA() -> SecKey? {
        let privateKey = self
        let priKeyRSAData = Data(base64Encoded: privateKey, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        let priAttributesRSA: [String:Any] = [
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecClass as String : kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048,
        ]
        var error3: Unmanaged<CFError>?
        let privateSecKeyRSA = SecKeyCreateWithData(priKeyRSAData! as CFData, priAttributesRSA as CFDictionary, &error3)
        return privateSecKeyRSA;
    }
    
    
    func removePaddingAndWrapping() -> String {
        var StrForRemovingPadding = self
        StrForRemovingPadding = StrForRemovingPadding.replacingOccurrences(of: "=", with: "")
        StrForRemovingPadding = StrForRemovingPadding.replacingOccurrences(of: "\n", with: "")
        StrForRemovingPadding = StrForRemovingPadding.replacingOccurrences(of: "\r", with: "")
        StrForRemovingPadding = StrForRemovingPadding.replacingOccurrences(of: "\t", with: "")
        StrForRemovingPadding = StrForRemovingPadding.replacingOccurrences(of: "+", with: "-")
        StrForRemovingPadding = StrForRemovingPadding.replacingOccurrences(of: "/", with: "_")
        StrForRemovingPadding = StrForRemovingPadding.replacingOccurrences(of: "\"", with: "")
        return StrForRemovingPadding
    }
    
    
    
    
    var hexaBytes: [UInt8] {
        var position = startIndex
        return (0..<count/2).compactMap { _ in // for Swift 4.1 or later use compactMap instead of flatMap
            defer { position = index(position, offsetBy: 2) }
            return UInt8(self[position...index(after: position)], radix: 16)
        }
    }
    
    
    
    func hmac(algorithm: CryptoAlgorithm, key: [UInt8]) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CCHmac(algorithm.HMACAlgorithm, key, key.count, str!, strLen, result)
        let digest = stringFromResult(result: result, length: digestLen)
        //result.deallocate(capacity: digestLen)
        result.deallocate()
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash).lowercased()
    }
    
    
    func fromBase64toString() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    //var data:          Data  { return Data(utf8) }
    //var base64Encoded: Data  { return data.base64EncodedData() }
    var base64Decoded: Data? { return Data(base64Encoded: self) }
    
}

extension Data {
    var string: String? { return String(data: self, encoding: .utf8) }
    
    
    
    func toBase64() -> String {
        return self.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed).replacingOccurrences(of: "=", with: "")
    }
}

extension String {
    enum CryptoAlgorithm {
        case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
        var HMACAlgorithm: CCHmacAlgorithm {
            var result: Int = 0
            switch self {
            case .MD5:      result = kCCHmacAlgMD5
            case .SHA1:     result = kCCHmacAlgSHA1
            case .SHA224:   result = kCCHmacAlgSHA224
            case .SHA256:   result = kCCHmacAlgSHA256
            case .SHA384:   result = kCCHmacAlgSHA384
            case .SHA512:   result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }
        var digestLength: Int {
            var result: Int32 = 0
            switch self {
            case .MD5:      result = CC_MD5_DIGEST_LENGTH
            case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
            case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
            case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
            case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
            case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }
    }
    
    func getPublicKeyRSA() -> SecKey? {
        var publicKey = self
        publicKey = publicKey.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
        let pubKeyRSAData = Data(base64Encoded: publicKey, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        let attributesRSA: [String:Any] = [
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecClass as String : kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048,
        ]
        var error1: Unmanaged<CFError>?
        return SecKeyCreateWithData(pubKeyRSAData! as CFData, attributesRSA as CFDictionary, &error1)
    }
}

