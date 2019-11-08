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
    
    func makeRequest(serviceURL: String, method: HTTPMethod, header: [String : String], postData: Parameters, completionBlock:@escaping (_ result: Any?, _ error: Error?) -> ()) -> Void {
        let headers: HTTPHeaders = header
        Alamofire.shared.request(serviceURL, method: method, parameters: postData, encoding: JSONEncoding.prettyPrinted, headers: headers).responseData { dataResponse in
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
        Alamofire.shared.request(serviceURL, method: method, parameters: postData, encoding: URLEncoding.default, headers: headers).responseString { dataResponse in
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
