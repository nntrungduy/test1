//
//  WriteFile.h
//  TrafficPredictor
//
//  Created by tqthanh on 5/25/14.
//  Copyright (c) 2014 JVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WriteFile : NSObject

+(void) writeGPS: (NSURL*)url withLatitude:(NSString*) Latitude
   withLongitude:(NSString*) Longitude atTime:(NSString*) Time
         address:(NSString*) MAC;
+(void) writeGPS:(NSString*) Latitude
   withLongitude:(NSString*) Longitude atTime:(NSString*) Time
         address:(NSString*) MAC;
+(void) clearGPS;

@end
