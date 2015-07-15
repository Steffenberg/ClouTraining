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

-(BOOL)sendExerciseToServer:(Exercise*)e;
-(void)reuqestMediaInfoFor:(Exercise*)e withData:(NSDictionary*)data andMedia:(NSData*)media;
@end
