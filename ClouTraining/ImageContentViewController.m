//
//  ImageContentViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ImageContentViewController.h"
#import "CreateTrainingTableViewCell.h"
#import "ContentTabBarViewController.h"

@interface ImageContentViewController ()

@end

@implementation ImageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataUpdate:) name:@"MediaDataUpdate" object:nil];
    ContentTabBarViewController *ctbvc = (ContentTabBarViewController*)self.tabBarController;
    [[Communicator sharedInstance]getMediaURLsForExercise:ctbvc.exercise type:2];
}

-(void)dataUpdate:(NSNotification*)note{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSDictionary *data = note.object;
        NSMutableArray *tmp = [NSMutableArray array];
        for(NSString *str in [data allKeys]){
            [tmp addObject:[data objectForKey:str]];
        }
        _imageData = tmp;
        
        for(NSDictionary *d in _imageData){
            NSLog(@"Titel: %@ - URL: %@",[d objectForKey:@"title"], [d objectForKey:@"url"]);
        }
        [_table reloadData];
    });
    
}

#pragma mark - tableView


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _imageData.count;
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
    
    
    cell.titleLabel.text = [(NSDictionary*)[_imageData objectAtIndex:row]objectForKey:@"title"];
    
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/clouTraining",ipprefix];
    NSString *suffixString = [(NSDictionary*)[_imageData objectAtIndex:indexPath.row] objectForKey:@"url"];
    if(!suffixString) return;
    suffixString = [suffixString stringByReplacingOccurrencesOfString:@".." withString:@""];
    urlString = [urlString stringByAppendingString:suffixString];
    
    
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowImagePresenter" object:nil userInfo:@{@"image":img,
                                                                                                              @"title":[(NSDictionary*)[_imageData objectAtIndex:indexPath.row]objectForKey:@"title"]
                                                                                                              }];
        
    });
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
