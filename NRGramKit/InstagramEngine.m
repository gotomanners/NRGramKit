//
//  InstagramEngine.m
//  Instamap
//
//  Created by Raul Andrisan on 12/16/11.
//  Copyright (c) 2011 NextRoot. All rights reserved.
//

#import "InstagramEngine.h"
#define BASE_URL @"https://api.instagram.com"


@implementation InstagramEngine

InstagramEngine* _sharedIGEngine;

+(InstagramEngine*)sharedEngine
{
    if(_sharedIGEngine==nil)
    {
        _sharedIGEngine = [[InstagramEngine alloc] init];
    }
    return _sharedIGEngine;
}


-(AFHTTPRequestOperation*)bodyForPath:(NSString*)path
                                 verb:(NSString*)verb
                                 body:(NSMutableDictionary*)body
                         onCompletion:(InstagramBodyResponseBlock) completionBlock
                              onError:(void (^)( NSError *error)) errorBlock
{
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:verb
                                                                                 URLString:[NSString stringWithFormat:@"%@%@",BASE_URL,path]
                                                                                parameters:body
                                                                                     error:&error];
    
    if (error) {
        errorBlock(error);
        return nil;
    }
    else {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperationManager manager] HTTPRequestOperationWithRequest:request
                                                                                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                                                 completionBlock(responseObject);
                                                                                                             }
                                                                                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                                                 errorBlock(error);
                                                                                                             }];
        [[[AFHTTPRequestOperationManager manager] operationQueue] addOperation:operation];
        
        return operation;
    }
}

@end
