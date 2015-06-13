//
//  MBotAPIClient.m
//  Mealbot
//
//  Created by caL_ on 2015-06-12.
//  Copyright (c) 2015 mealbot. All rights reserved.
//

#import "MBotAPIClient.h"

NSString * const APIKey = @"2HICRHA6OfBZW7RBEN3DCXGZItQGG7hz";
NSString * const BaseURLString = @"http://api.pearson.com/kitchen-manager/v1/";

@implementation MBotAPIClient

+ (MBotAPIClient *)sharedClient {
    static MBotAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if(!self){
        return nil;
    }
    self.securityPolicy.allowInvalidCertificates = YES;
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (void)getRecipesWithIngredients:(NSArray *)ingredients
                          success:(void (^)(NSURLSessionDataTask *, id))success
                          failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSMutableString *ingredientList = [NSMutableString string];
    
    for (NSString *ingredient in ingredients) {
        [ingredientList appendString:ingredient];
        [ingredientList appendString:@","];
    }
    
    NSString* path = [NSString stringWithFormat:@"recipes?ingredients-any=%@&apikey=%@", ingredientList, APIKey];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];

}

@end
