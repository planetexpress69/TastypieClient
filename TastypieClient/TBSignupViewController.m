//
//  TBSignupViewController.m
//  TastypieClient
//
//  Created by Martin Kautz on 01.08.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import "TBSignupViewController.h"
#import "TBAppDelegate.h"
#import "YRDropdownView.h"

@interface TBSignupViewController ()

@property (nonatomic, weak)     IBOutlet    UITableView         *theTableView;
@property (nonatomic, weak)     IBOutlet    UIBarButtonItem     *actionButton;
@property (nonatomic, strong)     IBOutlet    UITextField         *tfUsername;
@property (nonatomic, strong)     IBOutlet    UITextField         *tfPassword;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@implementation TBSignupViewController
@synthesize theTableView = _theTableView;
@synthesize actionButton = _actionButton;
@synthesize tfUsername = _tfUsername;
@synthesize tfPassword = _tfPassword;
@synthesize delegate = _delegate;

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
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    
    DLog(@"tfUsername: %@", self.tfUsername);
    
    [self enableTextFields];
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
    self.tfUsername.text = @"";
    self.tfPassword.text = @"";

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ddd"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ddd"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    DLog(@"CHECK: %@", self.tfUsername);
    
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
            return @"Please enter your desired credentials.";
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
        [self.navigationController presentModalViewController:vc animated:YES];
    }
}

- (void)disableTextFields {
    self.tfUsername.enabled = NO;
    self.tfPassword.enabled = NO;

}

- (void)enableTextFields {
    DLog(@"****** tfUsername: %@", self.tfUsername);
    self.tfUsername.borderStyle = UITextBorderStyleNone;
    self.tfPassword.borderStyle = UITextBorderStyleNone;

    self.tfUsername.enabled = YES;
    self.tfPassword.enabled = YES;

    [self.tfUsername becomeFirstResponder];
    
}

- (IBAction)save:(id)sender {
    
    NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.tfUsername.text, @"username",
                              self.tfPassword.text, @"password",
                              nil];
    
    [TheApp.tastypieEngine addUser:userDict
                      onCompletion:^(MKNetworkOperation *completedOperation) {
                          DLog(@"YES!");
                          [self.delegate dismiss:sender];
                      } onError:^(NSError *error) {
                          
                          
                          
                          NSInteger errorCodeToDisplay = error.code;
                          NSString *errorTextToDisplay = @"An unknown error occured!";
                          
                          if (errorCodeToDisplay == 400) {
                              errorTextToDisplay = @"That username already exists.";
                          }
                          
                          [YRDropdownView showDropdownInView:self.theTableView
                                                       title:[NSString stringWithFormat:@"Error %d", errorCodeToDisplay]
                                                      detail:errorTextToDisplay
                                                       image:nil
                                             backgroundImage:nil
                                                    animated:YES
                                                   hideAfter:3.0];
                      }];
    
    
}

- (IBAction)cancel:(id)sender {
    [self.delegate dismiss:sender];
}

#pragma mark - observer stuff
- (void)textDidChange:(NSNotification *)notification {
    self.actionButton.enabled = (self.tfUsername.text.length > 2 && self.tfPassword.text.length > 2);
}

@end
