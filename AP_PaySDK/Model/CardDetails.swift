//
//  CardDetails.swift
//  PaySDK
//
//  Created by AsiaPay Limited on 06/09/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

import Foundation

public struct CardDetails {
    
    var cardHolderName : String!
    var cardNo : String!
    var expMonth : String!
    var expYear : String!
    var securityCode : String!
    
    public init(cardHolderName : String,
                cardNo : String,
                expMonth: String,
                expYear : String,
                securityCode : String) {
        self.cardHolderName = cardHolderName
        self.cardNo = cardNo
        self.expMonth = expMonth
        self.expYear = expYear
        self.securityCode = securityCode
    }
}
