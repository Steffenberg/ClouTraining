//
//  DataConverter.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 14.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataConverter : NSObject

+(DataConverter*)sharedInstance;
+(NSData*)createJSONForExercise:(Exercise*)e;
+(NSData*)createJSONForData:(NSDictionary*)data;
+(NSDictionary*)convertOnlineExecise:(NSString*)data;
@end
