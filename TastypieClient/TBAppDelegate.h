//
//  TBAppDelegate.h
//  TastypieClient
//
//  Created by Martin Kautz on 27.07.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TastypieEngine.h"

// shorthand to access the delegate
#define TheApp ((TBAppDelegate *)[UIApplication sharedApplication].delegate)

@interface TBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TastypieEngine        *tastypieEngine;
@property (strong, nonatomic) NSMutableArray        *dataSource;
@property (assign, nonatomic) BOOL                  dirty;

@end
