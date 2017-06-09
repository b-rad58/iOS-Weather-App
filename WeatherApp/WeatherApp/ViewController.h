//
//  ViewController.h
//  WeatherApp
//
//  Created by Bradley Mark Gavan on 2016-03-23.
//  Copyright © 2016 Bradley Mark Gavan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "WeatherInfo.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"


@interface ViewController : UIViewController <CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    //creating lables and text fields for the UIView/main story board
    IBOutlet UILabel *temperatureLabel;
    IBOutlet UILabel *cityName;
    IBOutlet UITextField *cityTextField;
    IBOutlet UIButton *cityButton;
    IBOutlet UILabel *todayDate;
    IBOutlet UILabel *minMaxTemp;
    IBOutlet UIImageView *weatherIcon;
    IBOutlet UILabel *humidtytextfield;
    

}
 // creating property arrays
@property (nonatomic, strong) NSMutableArray *temperatureArray;
@property (nonatomic, strong) NSMutableArray *weatherDescriptionArray;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *humidity;
@property (nonatomic, strong) NSMutableArray *weatherIconArray;


// creating arrays for each day
@property (nonatomic, strong) NSMutableArray *day1;
@property (nonatomic, strong) NSMutableArray *day2;
@property (nonatomic, strong) NSMutableArray *day3;
@property (nonatomic, strong) NSMutableArray *day4;
@property (nonatomic, strong) NSMutableArray *day5;
@property (nonatomic, strong) NSMutableArray *forecastDays;



@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenW;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic, strong) NSDictionary *forecastDictionary;

@end

