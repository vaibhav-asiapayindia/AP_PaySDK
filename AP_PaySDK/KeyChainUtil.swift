//
//  KeyChainUtil.swift
//  PaySDK
//
//  Created by AsiaPay Limited on 07/05/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

import UIKit

class KeyChainUtil: NSObject {
    
    func dictionaryOfGenericData(account: String, service: String, key: String) -> [AnyHashable:Any]? {
        var dic: [AnyHashable : Any] = [:]
        let identifier: Data? = key.data(using: .utf8)
        dic[kSecAttrGeneric] = identifier
        dic[kSecAttrAccount] = account
        dic[kSecAttrService] = service
        dic[kSecClass] = kSecClassGenericPassword
        return dic
    }
    
    
    func saveGenericData(data: Data,  account: String, service: String, key: String, overwrite: Bool) -> Bool {
        var dic = dictionaryOfGenericData(account: account, service: service, key: key)
        dic?[kSecValueData] = data
        var uDic: [AnyHashable : Any] = [:]
        uDic[kSecValueData] = data
        var result: AnyObject?
        let status: OSStatus = SecItemAdd(dic! as CFDictionary, &result)
        if status == 0 {
            return true
        } else if status == errSecDuplicateItem && overwrite == true {
            let status1: OSStatus = SecItemUpdate(dic! as CFDictionary, (uDic as CFDictionary))
            if status1 == 0 {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    
    func loadData(account: String, service: String, key: String) -> Data? {
        let searchDic = searchDictionaryOfGenericData(account: account, service: service, key: key)
        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(searchDic as CFDictionary, &result)
        if status == 0 {
            return (result![kSecValueData] as! Data)
        } else {
            return nil
        }
    }
    
    
    func searchDictionaryOfGenericData(account: String, service: String, key: String) -> [AnyHashable:Any] {
        var dic = dictionaryOfGenericData(account: account, service: service, key: key)
        dic![kSecMatchLimit] = kSecMatchLimitOne
        dic![kSecReturnAttributes] = kCFBooleanTrue
        dic![kSecReturnData] = kCFBooleanTrue
        return dic!
    }
    
}

