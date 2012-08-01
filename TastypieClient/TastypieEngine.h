//
//  TastypieEngine.h
//  TastypieClient
//
//  Created by Martin Kautz on 30.07.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import "TastypieEngine.h"

@interface TastypieEngine : MKNetworkEngine

- (id)initWithHostName:(NSString *)hostName;

- (void)authorizeForUser:(NSString *)name
             andPassword:(NSString *)password;

- (void)persons:(id)foo
   onCompletion:(MKNKResponseBlock)completionBlock
        onError:(MKNKErrorBlock)errorBlock;

- (void)addPerson:(NSDictionary *)user
     onCompletion:(MKNKResponseBlock)completionBlock
          onError:(MKNKErrorBlock)errorBlock;

- (void)updatePerson:(NSDictionary *)user
      forResourceUri:(NSString *)resourceUri
        onCompletion:(MKNKResponseBlock)completionBlock
             onError:(MKNKErrorBlock)errorBlock;

- (void)deletePerson:(NSString *)resourceUri
        onCompletion:(MKNKResponseBlock)completionBlock
             onError:(MKNKErrorBlock)errorBlock;

- (void)addUser:(NSDictionary *)user
   onCompletion:(MKNKResponseBlock)completionBlock
        onError:(MKNKErrorBlock)errorBlock;

@end
