//
//  PlistInfo.swift
//  PayDollarSDK
//
//  Created by AsiaPay Limited on 28/01/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

import UIKit

class PlistInfo: NSObject {
    
    static let sharedPlistInfo = PlistInfo()
    
    override init() {
        super.init()
    }
    
    
    func toJSON(dict: [String : Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)!
            return jsonStr
        } catch {}
        return ""
    }
    
    
    func getPlistData(value: String) -> String {
        var dictRoot: NSDictionary?
        if let path = Bundle.main.path(forResource: ConfigFile, ofType: nil) {
            dictRoot = NSDictionary(contentsOfFile: path)
        }
        if let dict = dictRoot {
            return (dict[value] as? String)!
        }
        return ""
    }
    
    
    func getPublicKey(key: String) -> String {
        let contentFromFile = PlistInfo.sharedPlistInfo.getPlistData(value: publicKeyFile)
        var merchantRSAPublicKey = contentFromFile.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
        merchantRSAPublicKey = merchantRSAPublicKey.replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
        merchantRSAPublicKey = merchantRSAPublicKey.replacingOccurrences(of: "\r", with: "")
        merchantRSAPublicKey = merchantRSAPublicKey.replacingOccurrences(of: "\n", with: "")
        merchantRSAPublicKey = merchantRSAPublicKey.replacingOccurrences(of: "\t", with: "")
        return merchantRSAPublicKey
    }
    
    
    func getPrivateKey() -> String {
        let frameworkBundle = Bundle.init(for: classForCoder)
        let filePath = frameworkBundle.path(forResource: "RSAPrivateKey.txt", ofType: nil)!
        var contentFromFile = ""
        do {
            contentFromFile = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        } catch {}
        var merchantRSAPublicKey = contentFromFile.replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
        merchantRSAPublicKey = merchantRSAPublicKey.replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
        merchantRSAPublicKey = merchantRSAPublicKey.replacingOccurrences(of: "\r", with: "")
        merchantRSAPublicKey = merchantRSAPublicKey.replacingOccurrences(of: "\n", with: "")
        merchantRSAPublicKey = merchantRSAPublicKey.replacingOccurrences(of: "\t", with: "")
        return merchantRSAPublicKey
    }
}
