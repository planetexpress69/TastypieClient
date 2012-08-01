//
//  TBTableViewController.m
//  TastypieClient
//
//  Created by Martin Kautz on 30.07.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import "TBTableViewController.h"
#import "TBDetailViewController.h"
#import "TBAppDelegate.h"
#import "TastypieEngine.h"
#import "JSONKit.h"
#import "YRDropdownView.h"

@interface TBTableViewController ()
@property (nonatomic, strong)           TBDetailViewController  *detailViewController;
@property (nonatomic, strong)           TBAddViewController     *addViewController;
@property (nonatomic, assign)           BOOL                    visible;
@end

@implementation TBTableViewController
@synthesize detailViewController = _detailViewController;
@synthesize addViewController = _addViewController;
@synthesize visible = _visible;

#pragma mark - init & view's lifecycle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = YES;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(addPerson:)];
    
    self.navigationItem.rightBarButtonItem = addItem;
    
    TheApp.dirty = YES; // triger initial load...

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.visible = YES;
    if (TheApp.dirty) {
        [self loadData];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    self.visible = NO;
    
    
    
}

- (void)didReceiveMemoryWarning {
    DLog(@"!!!");
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        self.detailViewController = nil;
        self.addViewController = nil;
    } else {
        self.detailViewController = nil;
        self.addViewController = nil;
    }
    
    
}

#pragma mark - autorotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    self.editButtonItem.enabled = TheApp.dataSource.count > 0;
    
    return TheApp.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foo"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"foo"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *firstName = [[TheApp.dataSource objectAtIndex:indexPath.row]objectForKey:@"first_name"];
    NSString *lastName = [[TheApp.dataSource objectAtIndex:indexPath.row]objectForKey:@"last_name"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    return cell;

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger rowToDelete = indexPath.row;
        
        NSString *resourceUri = [[TheApp.dataSource objectAtIndex:rowToDelete]objectForKey:@"resource_uri"];
        
        [TheApp.tastypieEngine deletePerson:resourceUri
                               onCompletion:^(MKNetworkOperation *completedOperation) {
                                   [TheApp.dataSource removeObjectAtIndex:rowToDelete];
                                   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                               } onError:^(NSError *error) {
                                   DLog(@"Errr: %@", error);
                               }];
        
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
        self.detailViewController.person = [TheApp.dataSource objectAtIndex:indexPath.row];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:self.detailViewController animated:YES];
     
}

#pragma mark - REST call list
- (void)loadData {
    
    [TheApp.tastypieEngine persons:nil
                      onCompletion:^(MKNetworkOperation *completedOperation) {
                          
                          NSError *parseError;
                          NSDictionary *json;
                          
                          json = [completedOperation.responseData
                                  objectFromJSONDataWithParseOptions:JKParseOptionNone
                                  error:&parseError];
                          
                          
                          
                          
                          
                          
                          if (!parseError) {
                              
                              int numberOfPersons = [[[json objectForKey:@"meta"]objectForKey:@"total_count"]integerValue];
                              
                              if (numberOfPersons > 0) {
                                  TheApp.dataSource = [[json objectForKey:@"objects"]mutableCopy];
                                  [self.tableView reloadData];
                              }
                              
                              /*
                              [YRDropdownView showDropdownInView:self.view
                                                           title:@"OK"
                                                          detail:[NSString stringWithFormat:@"%d %@", numberOfPersons, numberOfPersons > 1 ? @"persons" : @"person"]
                                                           image:nil
                                                        animated:YES
                                                       hideAfter:1.0]; */
                              
                              TheApp.dirty = NO;
                              
                              
                          } else {
                              [self.tableView reloadData];
                              [YRDropdownView showDropdownInView:self.view
                                                           title:@"Error"
                                                          detail:@"Garbled answer. Try again later."
                                                           image:nil
                                                        animated:YES
                                                       hideAfter:1.0];
                          }
                      } onError:^(NSError *error) {
                          TheApp.dataSource = nil;
                          [self.tableView reloadData];
                          NSInteger errorCodeToDisplay = error.code;
                          NSString *errorTextToDisplay = @"An unknown error occured!";
                          
                          if (errorCodeToDisplay == 401) {
                              errorTextToDisplay = @"Unauthorized. Check your credentials...";
                          }
                          
                          [YRDropdownView showDropdownInView:self.view
                                                       title:[NSString stringWithFormat:@"Error %d", errorCodeToDisplay]
                                                      detail:errorTextToDisplay
                                                       image:nil
                                             backgroundImage:nil
                                                    animated:YES
                                                   hideAfter:3.0];
                          
                      }];
}

#pragma mark - User triggered action 
- (IBAction)addPerson:(id)sender {
    self.detailViewController.person = nil;
    //[self.navigationController pushViewController:self.detailViewController animated:YES];
    //
    self.addViewController.tfFirstName.text = @"";
    self.addViewController.tfLastName.text = @"";
    [self.navigationController presentModalViewController:self.addViewController
                                                 animated:YES];
    
    
}

#pragma mark - ViewControllers' lazy initializers
- (TBDetailViewController *)detailViewController {
    if (!_detailViewController) {
        _detailViewController = [[TBDetailViewController alloc] initWithNibName:@"TBDetailViewController"
                                                                         bundle:nil];
        _detailViewController.title = @"Info";
    }
    return _detailViewController;
}

- (TBAddViewController *)addViewController {
    if (!_addViewController) {

        _addViewController = [[TBAddViewController alloc] initWithNibName:@"TBAddViewController"
                                                                   bundle:nil];
        _addViewController.delegate = self;
    }
    return _addViewController;
}

/*
- (void)handleBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
 */

#pragma mark - TBAddViewControllerDelegate methods
- (void)dismissAddViewController {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dismissAddViewControllerAndReload {
    [self loadData];
    [self dismissModalViewControllerAnimated:YES];
}

@end
