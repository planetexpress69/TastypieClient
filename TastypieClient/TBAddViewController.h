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
@end

@interface TBAddViewController : UIViewController <UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, assign)               NSObject <TBAddViewControllerDelegate>  *delegate;
@property (nonatomic, weak)     IBOutlet    UITableView                             *theTableView;
@property (nonatomic, weak)     IBOutlet    UIBarButtonItem                         *saveButton;
@property (nonatomic, strong)               UITextField                             *tfFirstName;
@property (nonatomic, strong)               UITextField                             *tfLastName;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
