//
//  ContentContentView.h
//  ClouTraining
//
//  Created by fastline on 21.04.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExerciseContentView : UIView

@property UISlider *setSlider;
@property UILabel *setLabel;

-(void)reloadData;
@end
