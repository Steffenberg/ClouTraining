//
//  TrainingContentTableViewCell.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 09.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "TrainingContentTableViewCell.h"

@implementation TrainingContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)sliderValueChanged:(id)sender{
    UISlider *slider = (UISlider*)sender;
    if(slider.tag == 1){
        slider.value = [[NSString stringWithFormat:@"%.2f",round(slider.value * 2) / 2]floatValue];
        _weightLabel.text = [NSString stringWithFormat:@"%.2f KG",slider.value];
    }
    if (slider.tag == 2) {
        slider.value = round(slider.value);
        _repLabel.text = [NSString stringWithFormat:@"WDH: %.0f",slider.value];
    }
}




@end
