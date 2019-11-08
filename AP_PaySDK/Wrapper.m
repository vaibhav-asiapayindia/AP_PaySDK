//
//  Wrapper.m

//  SDKApp
//
//  Created by AsiaPay Limited on 05/03/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

#import "Wrapper.h"
#import <AlipaySDK/AlipaySDK.h>


@implementation Wrapper
@synthesize order_id, order_ref;
@synthesize delegate;


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)sharedWrapper {
    static id _sharedWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWrapper = [[self alloc] init];
    });
    
    return _sharedWrapper;
}

- (void) getWrapped : (NSString *) param {
    [[AlipaySDK defaultService] payOrder:param fromScheme:@"alisdkdemo" callback:^(NSDictionary *resultDic) {
        NSMutableDictionary *resultDic1 = [[NSMutableDictionary alloc] initWithDictionary: resultDic];
        resultDic1[@"orderId"] = self.order_id;
        resultDic1[@"orderRef"] = self.order_ref;
        [self.delegate getResponse:resultDic1];
    }];
}


- (void) getWrappedV2 : (NSString *) param {
    param = [param stringByAppendingString:@"\r\n"];
    [[AlipaySDK defaultService] payOrder:param dynamicLaunch:true fromScheme:@"alisdkdemo" callback:^(NSDictionary *resultDic) {
        NSMutableDictionary *resultDic1 = [[NSMutableDictionary alloc] initWithDictionary: resultDic];
        resultDic1[@"orderId"] = self.order_id;
        resultDic1[@"orderRef"] = self.order_ref;
        [self.delegate getResponse:resultDic1];
    }];
}


- (void) processOrder : (NSURL *) url {
    if([url.host.lowercaseString isEqualToString: @"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSMutableDictionary *resultDic1 = [[NSMutableDictionary alloc] initWithDictionary: resultDic];
            resultDic1[@"orderId"] = self.order_id;
            resultDic1[@"orderRef"] = self.order_ref;
            [self.delegate getResponse:resultDic1];
            //[messageArr addObject: @"processOrder Callback"];
            //[messageArr addObject: url];
            //[messageArr addObject: self.order_id];
            //[messageArr addObject: self.order_ref];
            //[[NSUserDefaults standardUserDefaults] setObject:messageArr forKey:@"message"];
            //NSMutableDictionary *resultDic1 = [[NSMutableDictionary alloc] initWithDictionary: resultDic];
            //resultDic1[@"orderId"] = self.order_id;
            //resultDic1[@"orderRef"] = self.order_ref;
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"result" object:resultDic1];
        }];
    }
}



@end
