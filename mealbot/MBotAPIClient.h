//
//  MBotAPIClient.h
//  Mealbot
//
//  Created by caL_ on 2015-06-12.
//  Copyright (c) 2015 mealbot. All rights reserved.
//

#import "AFHTTPSessionManager.h"

extern NSString* const APIKey;
extern NSString* const BaseURLString;

@interface MBotAPIClient : AFHTTPSessionManager

+ (MBotAPIClient *)sharedClient;

- (void)getRecipesWithIngredients:(NSArray *)ingredients
                          success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
