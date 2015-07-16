//
//  VideoContentViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "VideoContentViewController.h"
#import "ContentTabBarViewController.h"
#import "CreateTrainingTableViewCell.h"

@interface VideoContentViewController ()

@end

@implementation VideoContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ContentTabBarViewController *ctbvc = (ContentTabBarViewController*)self.tabBarController;
    [[Communicator sharedInstance]getMediaURLsForExercise:ctbvc.exercise type:1];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataUpdate:) name:@"MediaDataUpdate" object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)dataUpdate:(NSNotification*)note{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSDictionary *data = note.object;
        NSMutableArray *tmp = [NSMutableArray array];
        for(NSString *str in [data allKeys]){
            [tmp addObject:[data objectForKey:str]];
        }
        _videoData = tmp;
        
        for(NSDictionary *d in _videoData){
            NSLog(@"Titel: %@ - URL: %@",[d objectForKey:@"title"], [d objectForKey:@"url "]);
        }
        [_table reloadData];
    });
   
}

#pragma mark - tableView


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _videoData.count;
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
    
    
    cell.titleLabel.text = [(NSDictionary*)[_videoData objectAtIndex:row]objectForKey:@"title"];
    
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *urlString = @"http://192.168.178.45/clouTraining";
    NSString *suffixString = [(NSDictionary*)[_videoData objectAtIndex:indexPath.row] objectForKey:@"url"];
    suffixString = [suffixString stringByReplacingOccurrencesOfString:@".." withString:@""];
    urlString = [urlString stringByAppendingString:suffixString];
    
    NSURL *movieURL = [NSURL URLWithString:urlString];
    _movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    [self presentMoviePlayerViewControllerAnimated:_movieController];
    [_movieController.moviePlayer play];
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
