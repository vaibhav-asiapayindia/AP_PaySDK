//
//  callBackFromAliPay.h
//  AP_PaySDK
//
//  Created by AsiaPay Limited on 07/11/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol callBackFromAliPay <NSObject>


- (void) getResponse:(NSDictionary *) resultDic;
@end

NS_ASSUME_NONNULL_END
