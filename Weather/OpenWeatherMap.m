//
//  OpenWeatherMap.m
//  Weather
//
//  Created by Sergey_Oleynich on 10.12.15.
//  Copyright © 2015 Sergey. All rights reserved.
//

#import "OpenWeatherMap.h"

NSString *const kOpenWeatherMapReceiveWeatherIcon = @"OpenWeatherMapReceiveWeatherIcon";
NSString *const kOpenWeatherMapReceiveWeatherIconKey = @"OpenWeatherMapReceiveWeatherIconKey";

static CGFloat const forCelsius = 273.15;

@implementation OpenWeatherMap

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        if (dict[@"name"]) {
            _cityName = dict[@"name"];
        } else {
            _cityName = @"No city";
        }
        
        if ([dict valueForKeyPath:@"main.temp"]) {
            
            _temperature.kelvin = [[dict valueForKeyPath:@"main.temp"] floatValue];
            _temperature.celsius = lrintf(_temperature.kelvin - forCelsius);
            _temperature.fahrenheit = _temperature.kelvin * 9 / 5 - 459.67;
            
        }
        
        if (dict[@"weather"]) {
            NSArray *temp = dict[@"weather"];
            
            if ([[temp firstObject] objectForKey:@"description"]) {
                _weatherDescription = [[temp firstObject] objectForKey:@"description"];
            } else {
                _weatherDescription = @"No weather";
            }
            
            if ([[temp firstObject] objectForKey:@"icon"]) {
                [self weatherIcon:[[temp firstObject] objectForKey:@"icon"] withCompletionBlock:^(NSData *response) {
                    
                    _icon = [UIImage imageWithData:response];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kOpenWeatherMapReceiveWeatherIcon object:nil userInfo:@{kOpenWeatherMapReceiveWeatherIconKey : [UIImage imageWithData:response]}];
                    });
                    
                }];
            } else {
                _icon = nil;
            }
            
        }
        
        if (dict[@"dt"]) {
            _currentTime = [self timeFromUnix:[dict[@"dt"] integerValue]];
        }
        

    }
    return self;
}

- (NSString *)timeFromUnix:(NSInteger)unixTime {
    
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:unixTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    
    return [dateFormatter stringFromDate:currentTime];
    
}

- (void)weatherIcon:(NSString *)stringIcon withCompletionBlock:(void(^)(NSData *response))block {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", stringIcon]];
    
    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            block ([NSData dataWithContentsOfURL:location]);
        }
        
    }] resume];
        
}

@end
