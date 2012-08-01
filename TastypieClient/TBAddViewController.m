//
//  TBAddViewController.m
//  TastypieClient
//
//  Created by Martin Kautz on 31.07.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import "TBAddViewController.h"
#import "TBAppDelegate.h"

@interface TBAddViewController ()

@end

@implementation TBAddViewController
@synthesize theTableView = _theTableView;
@synthesize delegate = _delegate;
@synthesize tfFirstName = _tfFirstName;
@synthesize tfLastName = _tfLastName;
@synthesize saveButton = _saveButton;

#pragma mark - init & view lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.theTableView.dataSource = self;
    
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
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma mark - autorotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - user triggered actions
- (IBAction)cancel:(id)sender {
    [self.delegate dismissAddViewController];
}

- (IBAction)save:(id)sender {
    
    NSString *sFirstName = self.tfFirstName.text;
    NSString *sLastName = self.tfLastName.text;
    
    NSDictionary *oUser = [NSDictionary dictionaryWithObjectsAndKeys:sFirstName, @"first_name", sLastName, @"last_name", nil];
    
    [TheApp.tastypieEngine addPerson:oUser
                        onCompletion:^(MKNetworkOperation *completedOperation) {
                            
                            DLog(@"completedOperation: %@", completedOperation);
                            TheApp.dirty = YES;
                            [self.delegate dismissAddViewController];
                            
                            //
                        } onError:^(NSError *error) {
                            DLog(@"error: %@", error);
                            [self.delegate dismissAddViewController];
                        }];
    
    
    
    //[self.delegate dismissAddViewControllerAndReload];
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zzz"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"zzz"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
            [cell.contentView addSubview:self.tfFirstName];
            break;
        case 1:
            [cell.contentView addSubview:self.tfLastName];
            break;
        default:
            break;
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITextField *)tfFirstName {
    if (_tfFirstName == nil) {
        _tfFirstName = [[UITextField alloc]initWithFrame:CGRectMake(20,9,260,26)];
        _tfFirstName.placeholder = @"First name";
        _tfFirstName.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tfFirstName.returnKeyType = UIReturnKeyNext;
        _tfFirstName.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _tfFirstName.autocorrectionType = UITextAutocorrectionTypeNo;
        _tfFirstName.keyboardType = UIKeyboardTypeDefault;
        _tfFirstName.delegate = self;
        
    }
    return _tfFirstName;
}

- (UITextField *)tfLastName {
    if (_tfLastName == nil) {
        _tfLastName = [[UITextField alloc]initWithFrame:CGRectMake(20,9,260,26)];
        _tfLastName.placeholder = @"Last name";
        _tfLastName.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tfLastName.returnKeyType = UIReturnKeyNext;
        _tfLastName.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _tfLastName.autocorrectionType = UITextAutocorrectionTypeNo;
        _tfLastName.keyboardType = UIKeyboardTypeDefault;
        _tfLastName.delegate = self;
    }
    return _tfLastName;
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.tfFirstName ) {
            [self.tfFirstName resignFirstResponder];
            [self.tfLastName becomeFirstResponder];
       
    } else {
            [self.tfLastName resignFirstResponder];
            [self.tfFirstName becomeFirstResponder];
    }
    
    return YES;
}

- (void)textDidChange:(NSNotification *)notification {
    self.saveButton.enabled = (self.tfFirstName.text.length > 2 && self.tfLastName.text.length > 2);
}


@end
