//
//  TippsContentViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TippsContentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSArray *tippsData;

@end
