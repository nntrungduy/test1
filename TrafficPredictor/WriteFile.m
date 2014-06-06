//
//  WriteFile.m
//  TrafficPredictor
//
//  Created by tqthanh on 5/25/14.
//  Copyright (c) 2014 JVN. All rights reserved.
//

#import "WriteFile.h"

@implementation WriteFile

+(void) clearGPS
{
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] ;
    
    NSLog(@"%@",docPath);
    NSString* txtFile = [docPath stringByAppendingPathComponent:@"GPS.txt"];
    
    NSLog(@"%@",txtFile);
    if ([[NSFileManager defaultManager] fileExistsAtPath:txtFile])
    {
        [[NSFileManager defaultManager] removeItemAtPath:txtFile error:nil];
    }
}

+(void) writeGPS: (NSURL*)url withLatitude:(NSString*) Latitude
   withLongitude:(NSString*) Longitude atTime:(NSString*) Time
         address:(NSString*) MAC
{
    NSString* content = [NSString stringWithContentsOfURL: url encoding:NSUTF8StringEncoding error:nil];
    NSString* GPSdata = [NSString stringWithFormat:@"%@ %@ %@ %@",Latitude,Longitude,Time,MAC];
    
    NSString* newContent = [NSString stringWithFormat:@"%@\n%@",content,GPSdata];
    
    [newContent writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}
+(void) writeGPS:(NSString*) Latitude
   withLongitude:(NSString*) Longitude atTime:(NSString*) Time
         address:(NSString*) MAC;
{
    NSString* GPSdata = [NSString stringWithFormat:@"%@ %@ %@ %@\n",Latitude,Longitude,Time,MAC];
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] ;
    
    NSLog(@"%@",docPath);
    NSString* txtFile = [docPath stringByAppendingPathComponent:@"GPS.txt"];
    
    NSLog(@"%@",txtFile);
    if (![[NSFileManager defaultManager] fileExistsAtPath:txtFile])
    {
        if([[NSFileManager defaultManager] createFileAtPath:txtFile contents:nil attributes:nil])
            NSLog(@"file created");
    }
    NSFileHandle * handler = [NSFileHandle fileHandleForUpdatingAtPath:txtFile];
    [handler seekToEndOfFile];
    
    [handler writeData:[GPSdata dataUsingEncoding:NSUTF8StringEncoding]];
    [handler closeFile];
}

@end
