//
//  TBDetailViewController.h
//  TastypieClient
//
//  Created by Martin Kautz on 30.07.12.
//  Copyright (c) 2012 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet    UITextField     *tfFirstName;
@property (nonatomic, weak) IBOutlet    UITextField     *tfLastName;

@property (nonatomic, strong)           NSDictionary    *person;
@property (nonatomic, assign)           BOOL            edit;

@property (nonatomic, strong)           NSString        *oldFirstName;
@property (nonatomic, strong)           NSString        *oldLastName;

@end
