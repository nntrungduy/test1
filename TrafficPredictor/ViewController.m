//
//  ViewController.m
//  TrafficPredictor
//
//  Created by tqthanh on 5/25/14.
//  Copyright (c) 2014 JVN. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WriteFile.h"
#import "AFNetworking.h"


@interface ViewController ()<CLLocationManagerDelegate>
{
    NSTimer * timer;
}
@end

@implementation ViewController
{
    CLLocationManager *mgr;
    NSString * UUID;
    NSString *myTime;
    UIAlertView *alert;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    mgr = [[CLLocationManager alloc] init ];
    mgr.delegate=self;
    mgr.desiredAccuracy = kCLLocationAccuracyBest;
    
   //set icon background
    alert = [[UIAlertView alloc]initWithTitle: @"Confirmation"
                                                   message: @"Your data has been sent"
                                                  delegate: self
                                         cancelButtonTitle:@"YOLO"
                                         otherButtonTitles:nil,nil];
    
    
    //set background opacity
    self.background.alpha = 0.45;
    //init switch button
    
    [self.onSwitch addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    //
    NSLog(@"Init success");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//========================================Button Start Event=====================================
-(IBAction)btnStart:(id)sender
{
    UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"UDID:: %@", UUID);
    self.labelUDID.text = [NSString stringWithFormat:@"UUID: %@",UUID];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(CallInInterval) userInfo:nil repeats:YES];
    
    
    _btnStart.enabled= NO;
    _btnSend.enabled=NO;
    
}
//========================================Button Stop Event=====================================

- (IBAction)btnStop:(id)sender {
    
    [timer invalidate];
    _btnStart.enabled = YES;
    _btnSend.enabled = YES;
    
}

//========================================Button Send Event=====================================

- (IBAction)btnSend:(id)sender {
   
    
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] ;
    
    NSLog(@"%@",docPath);
    
    NSString* txtFile = [docPath stringByAppendingPathComponent:@"GPS.txt"];
    
    NSData * data = [NSData dataWithContentsOfFile:txtFile];
    
    NSString * urlString = @"http://gpsdata.jvn.edu.vn/GPSdata/upload04.php";
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init] ;
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString * str = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",txtFile];
    [body appendData:[[NSString stringWithString:str] dataUsingEncoding:NSUTF8StringEncoding]];
	
    
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:data]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@",returnString);
    
    [WriteFile clearGPS];
    
    
    [alert show];
    
}


////////////////////////////////////////////////////////
- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn]) {
        self.labelLatitude.text = @"The Switch is On";
        NSLog(@"switch on");
    } else {
        self.labelLatitude.text = @"The Switch is Off";
        NSLog(@"switch off");
    }
}


// Call method update location with interval time 5.0 sec
-(void) CallInInterval
{
    [mgr startUpdatingLocation];
}
//===============================================================================================
//=================================OVERIDE UPDATE LOCATION=======================================

#pragma mark CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@",error);
    NSLog(@"Fail to get location");
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
	myTime = [dateFormatter stringFromDate:now];
    self.labelLatitude.text= [NSString stringWithFormat:@"Latitude: %.5f",newLocation.coordinate.latitude];
    self.labelLongitude.text= [NSString stringWithFormat:@"Longitude: %.5f",newLocation.coordinate.longitude];
    self.labelTime.text =[NSString stringWithFormat:@"Time: %@",myTime];
    NSLog(@"\nLat : %f \nLong: %f \nTime: %@.",newLocation.coordinate.latitude,newLocation.coordinate.longitude,myTime);
    [WriteFile writeGPS:self.labelLatitude.text withLongitude:self.labelLongitude.text atTime:self.labelTime.text address:UUID];

    [mgr stopUpdatingLocation];
    NSLog(@"Stop Update!");
    
}
//===============================================================================================

@end
