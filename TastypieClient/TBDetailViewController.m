//
//  TBDetailViewController.m
//  TastypieClient
//
//  Created by Martin Kautz on 30.07.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import "TBDetailViewController.h"
#import "TBAppDelegate.h"

@interface TBDetailViewController ()

@end

@implementation TBDetailViewController
@synthesize person = _person;
@synthesize edit = _edit;
@synthesize oldFirstName = _oldFirstName;
@synthesize oldLastName = _oldLastName;

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
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered
                                                                 target:self action:@selector(edit:)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    self.edit = NO;
    self.tfFirstName.enabled = NO;
    self.tfLastName.enabled = NO;
    self.tfFirstName.borderStyle = UITextBorderStyleNone;
    self.tfLastName.borderStyle = UITextBorderStyleNone;
    
    
    
}

- (void)edit:(id)sender {
    

    
    if (!self.isEditing) {
        
        self.oldFirstName = self.tfFirstName.text;
        self.oldLastName = self.tfLastName.text;
    
        UIBarButtonItem *b = (UIBarButtonItem *)sender;
        b.style = UIBarButtonItemStyleDone;
        b.title = @"Done";
    
        [self.navigationItem setHidesBackButton:YES animated:YES];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered
                                                                        target:self action:@selector(cancel:)];
        
        //self.navigationItem.leftBarButtonItem = leftBarButton;
        [self.navigationItem setLeftBarButtonItem:leftBarButton animated:YES];
        self.tfFirstName.enabled = YES;
        self.tfLastName.enabled = YES;
        self.tfFirstName.borderStyle = UITextBorderStyleRoundedRect;
        self.tfLastName.borderStyle = UITextBorderStyleRoundedRect;

        
    } else {
        
        if (![self.oldFirstName isEqualToString:self.tfFirstName.text] || ![self.oldLastName isEqualToString:self.tfLastName.text])
        {
            // apparently the input differs from original record
            
            // pack new values int dict
            NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self.tfFirstName.text, @"first_name",
                                      self.tfLastName.text, @"last_name", nil];
            
            // call the update method
            [TheApp.tastypieEngine updatePerson:userDict
                                 forResourceUri:[self.person objectForKey:@"resource_uri"]
                                   onCompletion:^(MKNetworkOperation *completedOperation) {
                                       //code
                                   } onError:^(NSError *error) {
                                       //
                                   }];
            
            TheApp.dirty = YES;
        
        }
        
        UIBarButtonItem *b = (UIBarButtonItem *)sender;
        b.style = UIBarButtonItemStyleBordered;
        b.title = @"Edit";
        //self.navigationItem.leftBarButtonItem = nil;
        
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        
        [self.navigationItem setHidesBackButton:NO animated:YES];
        self.tfFirstName.enabled = NO;
        self.tfLastName.enabled = NO;
        self.tfFirstName.borderStyle = UITextBorderStyleNone;
        self.tfLastName.borderStyle = UITextBorderStyleNone;

    }
    self.edit = !self.edit;
}

- (void)cancel:(id)sender {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem.title = @"Edit";
    self.tfFirstName.enabled = NO;
    self.tfLastName.enabled = NO;
    self.tfFirstName.borderStyle = UITextBorderStyleNone;
    self.tfLastName.borderStyle = UITextBorderStyleNone;

    self.tfFirstName.text = self.oldFirstName;
    self.tfLastName.text = self.oldLastName;
    
    self.edit = !self.edit;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tfFirstName.text = [self.person objectForKey:@"first_name"];
    self.tfLastName.text = [self.person objectForKey:@"last_name"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
