//
//  ViewController.m
//  WeatherApp
//
//  Created by Bradley Mark Gavan on 2016-03-23.
//  Copyright © 2016 Bradley Mark Gavan. All rights reserved.
//

#import "ViewController.h"
#import "WeatherTableViewCell.h"


@interface ViewController () {
    NSString* key;
    NSMutableArray *forecastsArray;
    int currentDay;
}


@end
@implementation ViewController {

    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [cityTextField setDelegate:self];
    currentDay = 1;
    
    //setting up the motion manager
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .1;
    self.motionManager.gyroUpdateInterval = .1;
    
    //start rotation updates
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                      withHandler:^(CMGyroData *Rotationinfo, NSError *error) {
                                          [self UpdateRotationInfo:Rotationinfo.rotationRate];
                                      }];
    
    //start acceleration
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                               withHandler:^(CMAccelerometerData  *Accelrationinfo, NSError *error) {
                                                   [self UpdateAccelerationInfo:Accelrationinfo.acceleration];
                                               }];
    
    //allocating + initializing property arrays
    self.temperatureArray=[[NSMutableArray alloc]init];
    self.weatherDescriptionArray=[[NSMutableArray alloc]init];
    self.timeArray=[[NSMutableArray alloc]init];
    self.weatherIconArray = [[NSMutableArray alloc] init];
    self.humidity = [[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bkg-7"]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
   
    //adding the table view to the main view
    [self.view addSubview:self.tableView];

    locationManager = [[CLLocationManager alloc] init];
        [self getUserLocation];
    key = @"006f2b6cd7724f9e3b60d7fdfd28de82"; //OpenWeatherMap API key
    
    //will hold 5 arrays, one for each day of the forecast
    _forecastDays = [[NSMutableArray alloc] initWithCapacity:5];
    NSLog(@"Program start:");
    [self getUserLocation];
}



// # of rows in the tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Return count of forecast
    return   [self.temperatureArray count];
}
//size of the cells in the table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


//initializing UItable cells with properties
//cell is a custom cell (WeatherUITableViewCell)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    WeatherTableViewCell *cell = (WeatherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"WeatherUITableViewCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    //assigning values to cells and setting the icon image for each row
    cell.iconImage.image= [UIImage imageNamed:self.weatherIconArray[indexPath.row]];
    cell.minMaxTemp.text=self.temperatureArray[indexPath.row];
    cell.weatherDescription.text=self.weatherDescriptionArray[indexPath.row];
    cell.time.text=self.timeArray[indexPath.row];
    humidtytextfield.text=self.humidity[indexPath.row];

    return cell;
}

- (NSString *)stringFromArrayOfStrings:(NSArray *)array {
    NSMutableString *result = [NSMutableString stringWithString:@""];
    if ([self.temperatureArray count] > 0) {
        [result appendString:[self.temperatureArray objectAtIndex:0]];
        for (int i = 1; i < [self.temperatureArray count]; i++) {
            [result appendString:@", "];
            [result appendString:[self.temperatureArray objectAtIndex:i]];
        }
    }
    return result;
}
 -(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// starts location updates
-(void)getUserLocation {
    locationManager.delegate = self;
    /*if ([locationManager locationServicesEnabled]) {
        NSLog(@"Services Enabled");
    }*/
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

}

    // displaying error if the finding location is not possible due to any reason
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Location Alert"
                                                                   message:@"Failed to Get Your Location."
                                
                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                    
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


    // when locationManger is updating location, this method is called and updates the longitude and latitude
    // labels as well as uses reverseGeocode lookup to update the city label
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        NSString *longitude = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.longitude];
        NSString *latitude = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.latitude];
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding city");
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            NSLog(@"Latitude = %.6f", currentLocation.coordinate.latitude);
            NSLog(@"Longitude = %.6f", currentLocation.coordinate.longitude);
            MKPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placemark.locality);
            cityName.text = placemark.locality;
            NSLog(@"city name: %@", cityName.text);
              [self loadDataFromLat:latitude Lon:longitude]; //calls to download
        }
    }];
    }
    [locationManager stopUpdatingLocation];
  
}




    //currently logs the url needed to access the weather information for the city the device is currently in
    // will need to make a urlRequest to download that information
    // another mehthod will be need to add a feature to search for the weater of a given city
- (void)loadDataFromLat:(NSString *)lat Lon:(NSString *)lon
{
    NSString *api = @"http://api.openweathermap.org/data/2.5/forecast?lat=";
    api = [api stringByAppendingString:lat];
    api = [api stringByAppendingString:@"&lon="];
    api = [api stringByAppendingString:lon];
    // add option to chose between metric and farhenheit
    api = [api stringByAppendingString:@"&units=metric&appid="];
    api = [api stringByAppendingString:key];
    NSLog(@"%@", api);
    NSURL *url = [NSURL URLWithString:api];
    [self loadDataFromURL:url];
}

// downloads the forecast from the openweathermap url
// returns a dictionary containing 40 data points in JSON format
// creates a WeatherInfo object for each data point and places them in an array
-(void)loadDataFromURL:(NSURL *)url {
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        // Check if any data returned.
        if (data != nil) {
            // Convert the returned data into a dictionary.
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"%@", [returnedDict valueForKey:@"cod"]);
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                if ([returnedDict isKindOfClass:[NSDictionary class]]) {
                    if ([returnedDict[@"cod"] integerValue] == 200) {
                        NSInteger numberOfForecasts = [returnedDict[@"cnt"] integerValue];
                        if (numberOfForecasts) {
                            forecastsArray = [[NSMutableArray alloc] initWithCapacity:numberOfForecasts];
                            for (int forecastNumber = 0; forecastNumber < numberOfForecasts; forecastNumber++) {
                                WeatherInfo *forecast;
                                forecast = [[WeatherInfo alloc] initWithDictionary:returnedDict[@"list"][forecastNumber]];
                                if (forecast) {
                                    [forecastsArray addObject:forecast];
                                }
                            }
                            NSLog(@"size of forecastsArray: %lu", (unsigned long)[forecastsArray count]);
                            [self seperateForcastByDateFromArray:forecastsArray];
                        }
                    }
                    else
                    {
                        NSLog(@"didFailWithError: %@", error);
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Data Alert"
                                                                                       message:@"Failed to Get Data."
                                                    
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                        
                                                                              handler:^(UIAlertAction * action) {}];
                        
                        [alert addAction:defaultAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];

                        
                    }
                }
                
            }
        }
         }];
}

// given an array of WeatherInfo objects, seperates them by day (into 5 seperate day arrays)
- (void)seperateForcastByDateFromArray:(NSMutableArray *) forecastArray
{
    // check if forecastArray != nil
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    _forecastDays = [[NSMutableArray alloc] init];
    _day1 = [[NSMutableArray alloc] init];
    _day2 = [[NSMutableArray alloc] init];
    _day3 = [[NSMutableArray alloc] init];
    _day4 = [[NSMutableArray alloc] init];
    _day5 = [[NSMutableArray alloc] init];
    
    
    //put the forecast into 5 arrays, each representing a day
    NSDate *tempDay1 = ((WeatherInfo *)[forecastArray objectAtIndex:0]).date;
    NSDate *tempDay2 = [NSDate dateWithTimeInterval:86400 sinceDate:tempDay1];
    NSDate *tempDay3 = [NSDate dateWithTimeInterval:86400 sinceDate:tempDay2];
    NSDate *tempDay4 = [NSDate dateWithTimeInterval:86400 sinceDate:tempDay3];
    NSDate *tempDay5 = [NSDate dateWithTimeInterval:86400 sinceDate:tempDay4];
    
    
    
    WeatherInfo *tempWeatherInfo = [[WeatherInfo alloc] init];
    for (int i=0; i<[forecastArray count]; i++) {
        tempWeatherInfo = [forecastsArray objectAtIndex:i];
        if ([[dateFormat stringFromDate:tempWeatherInfo.date ] isEqualToString:[dateFormat stringFromDate:tempDay1]] )
        {
        NSLog(@"time: %@", tempWeatherInfo.date);
            [_day1 addObject:tempWeatherInfo];
        }
        else if ([[dateFormat stringFromDate:tempWeatherInfo.date] isEqualToString:[dateFormat stringFromDate:tempDay2]] )
        {
            [_day2 addObject:tempWeatherInfo];
        }
        else if ([[dateFormat stringFromDate:tempWeatherInfo.date] isEqualToString:[dateFormat stringFromDate:tempDay3]] )
        {
            [_day3 addObject:tempWeatherInfo];
        }
        else if ([[dateFormat stringFromDate:tempWeatherInfo.date] isEqualToString:[dateFormat stringFromDate:tempDay4]] )
        {
            [_day4 addObject:tempWeatherInfo];
        }
        else if ([[dateFormat stringFromDate:tempWeatherInfo.date] isEqualToString:[dateFormat stringFromDate:tempDay5]] )
        {
            [_day5 addObject:tempWeatherInfo];
        }
        else {
            break;
        }
        
    }
  
    
    NSLog(@"size of day1: %lu", (unsigned long)[_day1 count]);
    NSLog(@"size of day2: %lu", (unsigned long)[_day2 count]);
    NSLog(@"size of day3: %lu", (unsigned long)[_day3 count]);
    NSLog(@"size of day4: %lu", (unsigned long)[_day4 count]);
    NSLog(@"size of day5: %lu", (unsigned long)[_day5 count]);
    
    //adding each day to the forecastDays
    [_forecastDays addObject:_day1];
    [_forecastDays addObject:_day2];
    [_forecastDays addObject:_day3];
    [_forecastDays addObject:_day4];
    [_forecastDays addObject:_day5];
    NSLog(@"size of days array: %lu", (unsigned long)[_forecastDays count]);
    [self loadTableDataFromArray:_forecastDays Day:currentDay]; //use currentDay variable for 'Day'
}

// empties the content arrays
// repopulates them with the data for the given day
// also updates interface fields (not including table view)
- (void)loadTableDataFromArray:(NSMutableArray *)forecast Day:(int) current {
    NSMutableArray *currentForecast = [forecast objectAtIndex:(current-1)];
    
    //have to remove upject to be able to reload new data
    [_temperatureArray removeAllObjects];
    [_weatherDescriptionArray removeAllObjects];
    [_timeArray removeAllObjects];
    [_weatherIconArray removeAllObjects];
    [_humidity removeAllObjects];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];

    
    // getting min/max temps for the day (checking each value)
    // getting the temperatre for each cell
    float minTemp = FLT_MAX;
    float maxTemp = FLT_MIN;
    for(int i=0; i<[currentForecast count]; i++) {
        WeatherInfo *tempWeather = [currentForecast objectAtIndex:i];
        if (tempWeather.minimumTemperature < minTemp) // check for min/max of day
            minTemp = tempWeather.minimumTemperature;
        if (tempWeather.maximumTemperature > maxTemp)
            maxTemp = tempWeather.maximumTemperature;
        
        //converting the tempreture value and adding it to an array
    float temperature=roundf(tempWeather.temperature);
    NSString *temperatureString = [[NSNumber numberWithFloat:temperature] stringValue];
    temperatureString = [temperatureString stringByAppendingString:@"℃"];
    [self.temperatureArray addObject:temperatureString];
    [self.weatherIconArray addObject:tempWeather.weatherConditionIcon];
        
        
        //getting the  weatherCondition  and adding it to the weatherDescriptionArray array
    NSString *weatherCondition =  tempWeather.weatherConditionDescription;
    weatherCondition = [weatherCondition capitalizedString];
    [self.weatherDescriptionArray addObject:weatherCondition];
    
        //getting the humidity value and adding it to the humidity array
    float humidityf = roundf(tempWeather.humidity);
    NSString *humiditystring = [[NSNumber numberWithFloat:humidityf] stringValue];
    humiditystring = [humiditystring stringByAppendingString:@" %"];
    [self.humidity addObject:humiditystring];
        
        
        //formating hours to make sure that AM and PM are correctly to hour
    NSString *hour  = [formatter stringFromDate:tempWeather.date];
        if ([hour integerValue] == 0) {
            hour = [NSString stringWithFormat:@"%d",12];
            hour = [hour stringByAppendingString:@"AM"];
        }
        else if ([hour integerValue] ==  12) {
            hour = [NSString stringWithFormat:@"%d",12];
            hour = [hour stringByAppendingString:@"PM"];
        }
        else if ([hour integerValue] > 12) {
            hour = [NSString stringWithFormat:@"%ld",(long)[hour integerValue]-12];
            hour = [hour stringByAppendingString:@"PM"];
        }
        else {
            hour = [NSString stringWithFormat:@"%ld",(long)[hour integerValue]];
            hour = [hour stringByAppendingString:@"AM"];
        }
        [self.timeArray addObject:hour];
        
    }
    // finds min and max temperatures for the day
    if (minTemp !=FLT_MIN && maxTemp != FLT_MAX) {
        minTemp = roundf(minTemp);
        maxTemp = roundf(maxTemp);
    }
    
    // shows the weather icon for the current weather (today)
    // or for noon (days 2-5)
    [formatter setDateFormat:@"EEEE MMMM dd, yyyy"];
    WeatherInfo *tempWeather = [[WeatherInfo alloc] init];
    if (currentDay ==1) {
        tempWeather = (WeatherInfo *)[currentForecast objectAtIndex:0];
    }
    else {
        tempWeather = (WeatherInfo *)[currentForecast objectAtIndex:4];
    }
    
    //setting the date
    NSString *currentDayDate = [formatter stringFromDate:tempWeather.date];
    todayDate.text = currentDayDate;
    
    //setting the icon and adding animation to it
    weatherIcon.image= [UIImage imageNamed:tempWeather.weatherConditionIcon];
    [UIView animateWithDuration:3.0f animations:^{
    weatherIcon.frame = CGRectMake(133.0f, 140.0f, weatherIcon.frame.size.width, weatherIcon.frame.size.height);
       
    }];
    
    //setting the tempreture value
    NSString *tempTemperature = [NSString stringWithFormat:@"%.0f", round(tempWeather.temperature)];
    temperatureLabel.text = [tempTemperature stringByAppendingString:@"℃"];
    
    
    //min and max tempreture
    NSString *minMax = [[NSNumber numberWithFloat:minTemp] stringValue];
    minMax = [minMax stringByAppendingString:@"℃ / "];
    minMax = [minMax stringByAppendingString:([[NSNumber numberWithFloat:maxTemp] stringValue])];
    minMax = [minMax stringByAppendingString:@"℃"];
    minMaxTemp.text = minMax;
    [self.tableView reloadData];    
}
// represented by the "Go" button
// creates the OpenWeatherMap URL for the city name entered in the text field
- (IBAction)loadDataFromCity:(id)sender {
    NSString *city =  cityTextField.text;
    if (!([city isEqualToString:@"Type city name here"] || ([city length] == 0))) {
        city = [city stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *api = @"http://api.openweathermap.org/data/2.5/forecast?q=";
        api = [api stringByAppendingString:city];
        // add option to chose between metric and farhenheit
        api = [api stringByAppendingString:@"&units=metric&appid="];
        api = [api stringByAppendingString:key];
        NSLog(@"%@", api);
        cityName.text = cityTextField.text;
        NSURL *url = [NSURL URLWithString:api];
        currentDay=1;
        [self loadDataFromURL:url];
    }
}


 //removes keyboard from view 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(![touch.view isMemberOfClass:[UITextField class]]) {
        [touch.view endEditing:YES];
    }
}


//updating the acceleration and rotation and reloading data base on the movment of the device
// checks if the 'flick' motion has been registered and changes the day seen as necessary
-(void)UpdateAccelerationInfo:(CMAcceleration)UpdateAccelerationInfo
{
    CMRotationRate rot = self.motionManager.gyroData.rotationRate;
    if(UpdateAccelerationInfo.x>1.5 && currentDay<5 && rot.z<-5) {
        currentDay++;
        [self loadTableDataFromArray:_forecastDays Day:currentDay];
    }
    
    else if(UpdateAccelerationInfo.x<-1.5 && currentDay>1 && rot.z>5) {
        currentDay--;
        [self loadTableDataFromArray:_forecastDays Day:currentDay];
    }
}

    // taking back the user to local city by clicking on this button
- (IBAction)reloadData:(id)sender {
    currentDay = 1;
    [self getUserLocation];
}

//updating rotation. not used
-(void)UpdateRotationInfo:(CMRotationRate)UpdateRotationInfo {}

// hides keyboard when 'return' is pressed
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end
