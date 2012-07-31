//
//  TastypieEngine.m
//  TastypieClient
//
//  Created by Martin Kautz on 30.07.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import "TastypieEngine.h"

@interface TastypieEngine()
@property (nonatomic, strong) NSString *plainTextUsername;
@property (nonatomic, strong) NSString *plainTextPassword;
@end

@implementation TastypieEngine
@synthesize plainTextUsername = _plainTextUsername;
@synthesize plainTextPassword = _plainTextPassword;


- (id)initWithHostName:(NSString *)hostName {
    if ((self = [super initWithHostName:hostName])) {
        self.plainTextUsername = nil;
        self.plainTextPassword = nil;
    }
    return self;
}

-(void)authorizeForUser:(NSString *)name andPassword:(NSString *)password {
    self.plainTextUsername = name;
    self.plainTextPassword = password;
    DLog(@"Authorizing engine for'%@' and '%@'", self.plainTextUsername, self.plainTextPassword);

}

- (void)persons:(id)foo
   onCompletion:(MKNKResponseBlock)completionBlock
        onError:(MKNKErrorBlock)errorBlock {
    
    NSString *sPath = [NSString stringWithFormat:API_PATH];
    
    MKNetworkOperation *op = [self operationWithPath:sPath
                                              params:nil
                                          httpMethod:@"GET"
                                                 ssl:NO];
    
    [op setAuthorizationHeaderValue:[self assembleTokenForUser:self.plainTextUsername
                                                   andPassword:self.plainTextPassword] forAuthType:@"Basic"];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        completionBlock(completedOperation);
    } onError:^(NSError* error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
}

- (void)deletePerson:(NSString *)resourceUri
     onCompletion:(MKNKResponseBlock)completionBlock
          onError:(MKNKErrorBlock)errorBlock {
    
#warning TODO - get rid of the stupid leading "/"!
    MKNetworkOperation *op = [self operationWithPath:[resourceUri substringFromIndex:1]
                                              params:nil
                                          httpMethod:@"DELETE"
                                                 ssl:NO];
    [op setAuthorizationHeaderValue:[self assembleTokenForUser:self.plainTextUsername
                                                   andPassword:self.plainTextPassword] forAuthType:@"Basic"];
    
    //[op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        completionBlock(completedOperation);
    } onError:^(NSError* error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}


- (void)addPerson:(NSDictionary *)user
   onCompletion:(MKNKResponseBlock)completionBlock
        onError:(MKNKErrorBlock)errorBlock {
    
    NSString *sPath = [NSString stringWithFormat:API_PATH];
    
    NSMutableDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [user objectForKey:@"first_name"], @"first_name",
                                   [user objectForKey:@"last_name"], @"last_name",
                                   nil];
    
    MKNetworkOperation *op = [self operationWithPath:sPath
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:NO];
    [op setAuthorizationHeaderValue:[self assembleTokenForUser:self.plainTextUsername
                                                   andPassword:self.plainTextPassword] forAuthType:@"Basic"];
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        completionBlock(completedOperation);
        
    } onError:^(NSError* error) {
        
        errorBlock(error);
        
    }];
    
    [self enqueueOperation:op];
}

- (void)updatePerson:(NSDictionary *)user
      forResourceUri:(NSString *)resourceUri
        onCompletion:(MKNKResponseBlock)completionBlock
             onError:(MKNKErrorBlock)errorBlock {
    
    //NSString *sPath = [NSString stringWithFormat:API_PATH];
    
    NSMutableDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [user objectForKey:@"first_name"], @"first_name",
                                   [user objectForKey:@"last_name"], @"last_name",
                                   nil];
    
#warning TODO - get rid of the stupid leading "/"!
    MKNetworkOperation *op = [self operationWithPath:[resourceUri substringFromIndex:1]
                                              params:params
                                          httpMethod:@"PUT"
                                                 ssl:NO];
    [op setAuthorizationHeaderValue:[self assembleTokenForUser:self.plainTextUsername
                                                   andPassword:self.plainTextPassword] forAuthType:@"Basic"];
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        completionBlock(completedOperation);
        
    } onError:^(NSError* error) {
        
        errorBlock(error);
        
    }];
    
    [self enqueueOperation:op];
}


- (NSString *)assembleTokenForUser:(NSString *)name andPassword:(NSString *)password {
    
    if (name == nil || password == nil) {
        NSLog(@"\n\n*** TastypieEngineAlert\n*** Ummm, who did forget about the credentials?\n*** Look for 'authorizeForUser:andPassword:'...\n\n");
        return nil;
    }
    
    NSData *authData = [[NSString stringWithFormat:@"%@:%@", name, password] dataUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@", [authData base64EncodedString]];
    
    
    
}

@end
