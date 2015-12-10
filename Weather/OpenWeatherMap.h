//
//  OpenWeatherMap.h
//  Weather
//
//  Created by Sergey_Oleynich on 10.12.15.
//  Copyright © 2015 Sergey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kOpenWeatherMapReceiveWeatherIcon;

extern NSString *const kOpenWeatherMapReceiveWeatherIconKey;

typedef struct {
    
    CGFloat kelvin;
    NSInteger celsius;
    CGFloat fahrenheit;
    
} Temperature;

@interface OpenWeatherMap : NSObject

@property (copy, nonatomic, readonly) NSString *cityName;
@property (copy, nonatomic, readonly) NSString *weatherDescription;
@property (copy, nonatomic, readonly) NSString *currentTime;
@property (strong, nonatomic, readonly) UIImage *icon;

@property (assign, nonatomic, readonly) Temperature temperature;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
