//
//  TippsContentViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "TippsContentViewController.h"
#import "ContentTabBarViewController.h"
#import "CreateTrainingTableViewCell.h"

@interface TippsContentViewController ()

@end

@implementation TippsContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataUpdate:) name:@"MediaDataUpdate" object:nil];
    ContentTabBarViewController *ctbvc = (ContentTabBarViewController*)self.tabBarController;
    [[Communicator sharedInstance]getMediaURLsForExercise:ctbvc.exercise type:3];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"MediaDataUpdate" object:nil];
}

-(void)dataUpdate:(NSNotification*)note{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSDictionary *data = note.object;
        NSMutableArray *tmp = [NSMutableArray array];
        for(NSString *str in [data allKeys]){
            [tmp addObject:[data objectForKey:str]];
        }
        _tippsData = tmp;
        
        for(NSDictionary *d in _tippsData){
            NSLog(@"Titel: %@ - Text: %@",[d objectForKey:@"title"], [d objectForKey:@"text"]);
        }
        [_table reloadData];
    });
    
}

#pragma mark - tableView


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tippsData.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"CreateTrainingTableViewCell";
    CreateTrainingTableViewCell *cell = (CreateTrainingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CreateTrainingTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.titleLabel.text = [(NSDictionary*)[_tippsData objectAtIndex:row]objectForKey:@"title"];
    
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowTextPresenter" object:nil userInfo:@{@"text":[(NSDictionary*)[_tippsData objectAtIndex:indexPath.row]objectForKey:@"text"],
                                                                                                              @"title":[(NSDictionary*)[_tippsData objectAtIndex:indexPath.row]objectForKey:@"title"]
                                                                                                              }];
        
    });
    
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
