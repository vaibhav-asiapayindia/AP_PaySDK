//
//  APIService.swift
//  PayDollarSDK
//
//  Created by AsiaPay Limited on 17/12/18.
//  Copyright © 2018 Asiapay. All rights reserved.
//

import Foundation
import UIKit


class APIService: NSObject {
    
    static let sharedInstance = APIService()
    
    private static let NetworkManager = NetworkUtility.init("")

    public static func getManager() -> SessionManager {
        return NetworkManager.manager!
    }
    
    
    func makeRequest(serviceURL: String, method: HTTPMethod, header: [String : String], postData: Parameters, completionBlock:@escaping (_ result: Any?, _ error: Error?) -> ()) -> Void {
        let headers: HTTPHeaders = header
        
        APIService.getManager().request(serviceURL, method: method, parameters: postData, encoding: JSONEncoding.prettyPrinted, headers: headers).responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                completionBlock(dataResponse.data, nil)
                break
            case .failure:
                completionBlock(nil, dataResponse.error)
                break
            }
        }
    }
    
    
    func makeThirdPartyRequest(serviceURL: String, method: HTTPMethod, header: [String : String], postData: Parameters, completionBlock:@escaping (_ result: Any?, _ error: Error?) -> ()) -> Void {
        let headers: HTTPHeaders = header
        APIService.getManager().request(serviceURL, method: method, parameters: postData, encoding: URLEncoding.default, headers: headers).responseString { dataResponse in
            switch dataResponse.result {
            case .success:
                completionBlock(dataResponse.data, nil)
                break
            case .failure:
                completionBlock(nil, dataResponse.error)
                break
            }
        }
    }
}


class NetworkUtility : NSObject {
    
    var manager: SessionManager?
    
    override init() {
        manager = SessionManager.init()
    }
    
    init(_: String) {
        super.init()
        do {
            let data = try Data.init(contentsOf: URL.init(fileURLWithPath: Bundle.init(for: classForCoder).path(forResource: "test", ofType: "cer")!))
            let data1 = try Data.init(contentsOf: URL.init(fileURLWithPath: Bundle.init(for: classForCoder).path(forResource: "pay", ofType: "cer")!))
            let serverTrustPolicies: [String: ServerTrustPolicy] = [
                "test.paydollar.com": ServerTrustPolicy.pinCertificates(certificates: [SecCertificateCreateWithData(nil, data as CFData)!], validateCertificateChain: true, validateHost: true),
                "www.paydollar.com": ServerTrustPolicy.pinCertificates(certificates: [SecCertificateCreateWithData(nil, data1 as CFData)!], validateCertificateChain: true, validateHost: true)
            ]
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 30
            config.timeoutIntervalForResource = 30
            manager = SessionManager.init(configuration: config, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
