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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(textDidChange:)
                   name:UITextFieldTextDidChangeNotification
                 object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
                            [self.delegate dismissAddViewControllerAndReload];
                            
                            //
                        } onError:^(NSError *error) {
                            DLog(@"error: %@", error);
                        }];
    
    [self.delegate dismissAddViewControllerAndReload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zzz"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"zzz"];
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    switch (indexPath.row) {
        case 0:
            DLog(@"cell %d", indexPath.row);
            [cell.contentView addSubview:self.tfFirstName];
            
            
            
            break;
        case 1:
            DLog(@"cell %d", indexPath.row);
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    //textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    textField.backgroundColor = [UIColor clearColor];
    
    
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    
    DLog(@"%d %d", self.tfFirstName.text.length, self.tfLastName.text.length);
        
    return YES;
    
    /*
    if ([string isEqualToString:@"#"]) {
        return NO;
    }
    else {
        return YES;
    } */
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn: %@", textField);
    
    if (textField == self.tfFirstName ) {
            [self.tfFirstName resignFirstResponder];
            [self.tfLastName becomeFirstResponder];
       
    } else {
            [self.tfLastName resignFirstResponder];
            [self.tfFirstName becomeFirstResponder];
    }
    
    
    /*
    if (textField == self.tfLastName) {
        [self.tfFirstName becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }*/
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.theTableView endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)textDidChange:(NSNotification *)notification {
    self.saveButton.enabled = (self.tfFirstName.text.length > 2 && self.tfLastName.text.length > 2);
}


@end
