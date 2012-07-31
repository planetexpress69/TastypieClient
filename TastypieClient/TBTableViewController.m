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
#import "YRDropDownView.h"

@interface TBTableViewController ()

@end

@implementation TBTableViewController
//@synthesize persons = _persons;
@synthesize detailViewController = _detailViewController;
@synthesize addViewController = _addViewController;

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

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(addPerson:)];
    
    self.navigationItem.rightBarButtonItem = addItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    
    [self loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (TheApp.dirty) {
        [self loadData];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        DLog(@"rowToDelete: %d", rowToDelete);
        
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
                              
                              
                              [YRDropdownView showDropdownInView:self.view
                                                           title:@"OK"
                                                          detail:[NSString stringWithFormat:@"%d %@", numberOfPersons, numberOfPersons > 1 ? @"persons" : @"person"]
                                                           image:nil
                                                        animated:YES
                                                       hideAfter:1.0];
                              
                              TheApp.dirty = NO;
                              
                              
                          } else {
                              
                              [YRDropdownView showDropdownInView:self.view
                                                           title:@"Error"
                                                          detail:@"Garbled answer. "
                               @"Try again later."
                                                           image:nil
                                                        animated:YES
                                                       hideAfter:1.0];
                          }
                      } onError:^(NSError *error) {
                          
                          
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

- (void)addPerson:(id)sender {
    self.detailViewController.person = nil;
    //[self.navigationController pushViewController:self.detailViewController animated:YES];
    //
    self.addViewController.tfFirstName.text = @"";
    self.addViewController.tfLastName.text = @"";
    [self.navigationController presentModalViewController:self.addViewController
                                                 animated:YES];
    
    
}

- (TBDetailViewController *)detailViewController {
    if (!_detailViewController) {
        _detailViewController = [[TBDetailViewController alloc] initWithNibName:@"TBDetailViewController"
                                                                         bundle:nil];
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

- (void)handleBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TBAddViewControllerDelegate methods
- (void)dismissAddViewController {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dismissAddViewControllerAndReload {
    [self loadData];
    [self dismissModalViewControllerAnimated:YES];
}

@end
