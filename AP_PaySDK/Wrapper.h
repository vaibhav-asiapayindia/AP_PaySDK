//
//  Wrapper.m

//  SDKApp
//
//  Created by AsiaPay Limited on 05/03/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "callBackFromAliPay.h"

NS_ASSUME_NONNULL_BEGIN

@interface Wrapper : NSObject
+(Wrapper *) sharedWrapper;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_ref;
@property (nonatomic, weak) id <callBackFromAliPay> delegate;

- (void) getWrappedV2 : (NSString *) param;
- (void) getWrapped : (NSString *) param;
- (void) processOrder : (NSURL *) url;

@end

NS_ASSUME_NONNULL_END




