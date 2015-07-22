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
    if([slider isEqual:_weightSlider]){
        NSInteger value = round(slider.value);
        slider.value = value;
        _weightLabel.text = [NSString stringWithFormat:@"%zd.%zd KG",(NSInteger)_weightSlider.value,(NSInteger)_floatWeightSlider.value*100];
    }
    
    if([slider isEqual:_floatWeightSlider]){
        float roundedValue = roundf(slider.value / 0.25f) * 0.25f;
        slider.value = roundedValue;
        NSInteger displayValue = slider.value*100;
  
        _weightLabel.text = [NSString stringWithFormat:@"%zd.%zd KG",(NSInteger)_weightSlider.value,displayValue];
    }
    if (slider.tag == 2) {
        slider.value = round(slider.value);
        _repLabel.text = [NSString stringWithFormat:@"WDH: %.0f",slider.value];
    }
}




@end
