//
//  TBTableViewController.h
//  TastypieClient
//
//  Created by Martin Kautz on 30.07.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBDetailViewController.h"
#import "TBAddViewController.h"

@interface TBTableViewController : UITableViewController<TBAddViewControllerDelegate>

//@property (nonatomic, strong)           NSMutableArray          *persons;
@property (nonatomic, strong)           TBDetailViewController  *detailViewController;
@property (nonatomic, strong)           TBAddViewController     *addViewController;

@end
