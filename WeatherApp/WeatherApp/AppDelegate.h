//
//  AppDelegate.h
//  WeatherApp
//
//  Created by Bradley Mark Gavan on 2016-03-23.
//  Copyright © 2016 Bradley Mark Gavan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;
@end

