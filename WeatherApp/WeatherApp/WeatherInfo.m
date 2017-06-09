//
//  WeatherInfo.m
//  WeatherApp
//
//  Created by Bradley Mark Gavan on 2016-03-26.
//  Copyright © 2016 Bradley Mark Gavan. All rights reserved.
//

#import "WeatherInfo.h"

@implementation WeatherInfo



- (instancetype) initWithDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    if (self) {
        @try {
            
            //each property is being assigned to a value which is extracted from the dictionary
        
            self.cloudinessPercent = [dictionary[@"clouds"][@"all"] floatValue];
            self.humidity = [dictionary[@"main"][@"humidity"] floatValue];
            self.pressure = [dictionary[@"main"][@"pressure"] floatValue];
            self.seaLevel = [dictionary[@"main"][@"sea_level"] floatValue];
            self.temperature = [dictionary[@"main"][@"temp"] floatValue];
            self.maximumTemperature = [dictionary[@"main"][@"temp_max"] floatValue];
            self.minimumTemperature = [dictionary[@"main"][@"temp_min"] floatValue];
            self.weatherConditionDescription = dictionary[@"weather"][0][@"description"];
            self.weatherConditionIcon = dictionary[@"weather"][0][@"icon"];
            self.weatherConditionid = dictionary[@"weather"][0][@"id"];
            self.weatherConditionCategory = dictionary[@"weather"][0][@"main"];
            self.date = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"dt"] integerValue]];
            self.windSpeed = [dictionary[@"wind"][@"speed"] floatValue];
            self.windDirection = [dictionary[@"wind"][@"deg"] floatValue];
            self.rainForTheNextThreeHours = [dictionary[@"rain"][@"3h"] floatValue];
        }
        @catch (NSException *exception) {
            self = nil;
        }
    }
    return self;
}



@end
