//
//  WeatherTableViewCell.h
//  WeatherApp
//
//  Created by Bradley Mark Gavan on 2016-04-04.
//  Copyright © 2016 Bradley Mark Gavan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeatherTableViewCell : UITableViewCell

//creating lables and text fields for the cutomed UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *minMaxTemp;
@property (strong, nonatomic) IBOutlet UILabel *weatherDescription;

@end
