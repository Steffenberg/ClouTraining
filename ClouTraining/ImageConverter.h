//
//  ImageConverter.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 17.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageConverter : NSObject

+(UIImage *) maskImage:(UIImage*)image withColor:(UIColor *)color;

@end
