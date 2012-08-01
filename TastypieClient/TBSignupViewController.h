//
//  TBSignupViewController.h
//  TastypieClient
//
//  Created by Martin Kautz on 01.08.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBSignupViewControllerDelegate
- (void)dismiss:(id)sender;
@end

@interface TBSignupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign)   NSObject<TBSignupViewControllerDelegate> *delegate;
@end
