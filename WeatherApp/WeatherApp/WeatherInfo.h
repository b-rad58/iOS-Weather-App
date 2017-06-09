//
//  WeatherInfo.h
//  WeatherApp
//
//  Created by Bradley Mark Gavan on 2016-03-26.
//  Copyright © 2016 Bradley Mark Gavan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfo : NSObject


// below are the list of properties which will be recived from openWeatherAPI and

@property (nonatomic, assign) float cloudinessPercent;
@property (nonatomic, assign) float humidity;

//atmospherical pressure.
@property (nonatomic, assign) float pressure;
@property (nonatomic, assign) float minimumTemperature;
@property (nonatomic, assign) float maximumTemperature;
@property (nonatomic, assign) float temperature;

//the wind direction in degrees.
@property (nonatomic, assign) float windDirection;
@property (nonatomic, assign) float windSpeed;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *weatherConditionDescription;
@property (nonatomic, strong) NSString *weatherConditionIcon;
@property (nonatomic, strong) NSString *weatherConditionid;
@property (nonatomic, strong) NSString *weatherConditionCategory;
@property (nonatomic, assign) float seaLevel;
@property (nonatomic, assign) float rainForTheNextThreeHours;
@property (nonatomic, assign) float snowForTheNextThreeHours;

// Initializes a forecast from a response of the OpenWeatherMap API
- (instancetype) initWithDictionary:(NSDictionary*)dictionary;



    
@end
