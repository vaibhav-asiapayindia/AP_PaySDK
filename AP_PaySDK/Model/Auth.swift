//
//  Auth.swift
//  PayDollar
//
//  Created by AsiaPay Limited on 10/12/18.
//  Copyright © 2018 Asiapay. All rights reserved.
//

import Foundation

struct Auth: Codable {
    
    //let permission : Permission?
    let token : String?
    let error : String?
    
    
    enum CodingKeys: String, CodingKey {
        //case permission
        case token = "token"
        case error = "error"
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // permission = try Permission(from: decoder)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }
    
    
}

