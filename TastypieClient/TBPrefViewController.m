//
//  TBPrefViewController.m
//  TastypieClient
//
//  Created by Martin Kautz on 01.08.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import "TBPrefViewController.h"
#import "TBAppDelegate.h"

@interface TBPrefViewController ()
@property (nonatomic, weak)     IBOutlet    UITableView                             *theTableView;
@property (nonatomic, strong)     IBOutlet    UITextField                             *tfUsername;
@property (nonatomic, strong)     IBOutlet    UITextField                             *tfPassword;
@property (nonatomic, strong)               UIBarButtonItem                         *saveButton;
@property (nonatomic, assign)               BOOL                                    edit;
@end

@implementation TBPrefViewController
@synthesize theTableView = _theTableView;
@synthesize tfUsername = _tfUsername;
@synthesize tfPassword = _tfPassword;
@synthesize edit = _edit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.theTableView.dataSource = self;
    self.theTableView.delegate = self;
    self.theTableView.scrollEnabled = NO;
    
    
    self.edit = NO;
    
    [self disableTextFields];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(toggle:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textDidChange:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    
    self.tfUsername.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    self.tfPassword.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    
    
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
            
        default:
            return 1;
            break;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ddd"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ddd"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [cell.contentView addSubview:self.tfUsername];
                CGRect fu = self.tfUsername.frame;
                fu.origin = CGPointMake (10,7);
                self.tfUsername.frame = fu;
                break;
            case 1:
                [cell.contentView addSubview:self.tfPassword];
                CGRect fp = self.tfPassword.frame;
                fp.origin = CGPointMake (10,7);
                self.tfPassword.frame = fp;
                break;
            default:
                break;
        }
    } else {
        cell.textLabel.text = @"Sign up for a new account";
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Account";
            break;
            
        default:
            return @"";
            break;
    }
}// fixed font style. use custom view (UILabel) if you want something different
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Please enter the credentials provided by your admin.";
            break;
            
        default:
            return @"Acount is free so hurry up to get one!";
            break;
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        TBSignupViewController *vc = [[TBSignupViewController alloc]initWithNibName:@"TBSignupViewController" bundle:nil];
        vc.delegate = self;
        [self.navigationController presentModalViewController:vc animated:YES];
    }
}


#pragma mark - observer stuff
- (void)textDidChange:(NSNotification *)notification {
    self.saveButton.enabled = (self.tfUsername.text.length > 2 && self.tfPassword.text.length > 2);
}


- (void)disableTextFields {
    self.tfUsername.enabled = NO;
    self.tfPassword.enabled = NO;
    self.tfUsername.borderStyle = UITextBorderStyleNone;
    self.tfPassword.borderStyle = UITextBorderStyleNone;
}

- (void)enableTextFields {
    self.tfUsername.enabled = YES;
    self.tfPassword.enabled = YES;
    self.tfUsername.borderStyle = UITextBorderStyleNone;
    self.tfPassword.borderStyle = UITextBorderStyleNone;
    [self.tfUsername becomeFirstResponder];
    
}

- (void)toggle:(id)sender {
    
    UIBarButtonItem *b = (UIBarButtonItem *)sender;
    
    if (!self.edit) {
        b.title = @"Done";
        b.style = UIBarButtonItemStyleDone;
        [self enableTextFields];
        
    } else {
        b.title = @"Edit";
        b.style = UIBarButtonItemStyleBordered;
        [self disableTextFields];
        TheApp.dirty = YES;
        [TheApp.tastypieEngine authorizeForUser:self.tfUsername.text andPassword:self.tfPassword.text];
        
    }
    self.edit = !self.edit;
}

- (void)dismiss:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
