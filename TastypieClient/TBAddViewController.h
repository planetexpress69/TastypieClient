//
//  TBAddViewController.h
//  TastypieClient
//
//  Created by Martin Kautz on 31.07.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBAddViewControllerDelegate
- (void)dismissAddViewController;
- (void)dismissAddViewControllerAndReload;
@end

@interface TBAddViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak)                 NSObject <TBAddViewControllerDelegate>  *delegate;
@property (nonatomic, weak)     IBOutlet    UITableView                             *theTableView;
@property (nonatomic, strong)               UITextField                             *tfFirstName;
@property (nonatomic, strong)               UITextField                             *tfLastName;
@property (nonatomic, weak)     IBOutlet    UIBarButtonItem                         *saveButton;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
