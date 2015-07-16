//
//  Communicator.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 14.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MediaComplete)(BOOL);

@interface Communicator : NSObject

+(Communicator*)sharedInstance;

-(void)sendExerciseToServer:(Exercise*)e;
-(void)reuqestMediaInfoWithData:(NSDictionary*)data andMedia:(NSData*)media;
-(void)getMediaURLsForExercise:(Exercise*)e type:(NSInteger)type;
@end
