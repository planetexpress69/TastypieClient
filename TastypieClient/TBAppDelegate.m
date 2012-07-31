//
//  TBAppDelegate.m
//  TastypieClient
//
//  Created by Martin Kautz on 27.07.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import "TBAppDelegate.h"
#import "TBTableViewController.h"

@implementation TBAppDelegate
@synthesize window          = _window;
@synthesize tastypieEngine  = _tastypieEngine;
@synthesize dataSource      = _dataSource;
@synthesize dirty           = _dirty;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
        
    self.dirty = NO;
        
    /*
    self.tastypieEngine = [[TastypieEngine alloc]initWithHostName:API_HOST
                                               customHeaderFields:headers];
     */
    
    self.tastypieEngine = [[TastypieEngine alloc]initWithHostName:API_HOST];
    [self.tastypieEngine authorizeForUser:@"root" andPassword:@"xxxx"];
    
    self.tastypieEngine.portNumber = 8000;
    
    
    TBTableViewController *tbvc = [[TBTableViewController alloc]initWithNibName:@"TBTableViewController"
                                                                         bundle:nil];
    tbvc.title = @"Persons";
    
    
    
    UINavigationController *naviController = [[UINavigationController alloc]initWithRootViewController:tbvc];
    
    
    self.window.rootViewController = naviController;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSDictionary *)assembleAuthHeaderForUser:(NSString *)name andPassword:(NSString *)password {
    NSData *authData = [[NSString stringWithFormat:@"%@:%@", name, password] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
    
    //NSString *encodedUsername = [sUsername urlEncodedString];
    //NSString *encodedUserApiKey = [sUserApiKey urlEncodedString];

    return [NSDictionary dictionaryWithObjectsAndKeys:authValue, @"Authorization", nil];
    
}

@end
