//
//  ViewController.m
//  Weather
//
//  Created by Sergey_Oleynich on 10.12.15.
//  Copyright © 2015 Sergey. All rights reserved.
//

#import "ViewController.h"
#import "OpenWeatherMap.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage:) name:kOpenWeatherMapReceiveWeatherIcon object:nil];
    
    NSString *urlString = @"http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=2de143494c0b295cca9337e1e96b00e0";
    //http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=2de143494c0b295cca9337e1e96b00e0
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error == nil) {
            NSDictionary *weatherJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@", weatherJSON);
            
            NSNumber *temperature = [weatherJSON valueForKeyPath:@"main.temp"];
            
            NSLog(@"%@", temperature);
            
            OpenWeatherMap *weather = [[OpenWeatherMap alloc] initWithDictionary:weatherJSON];
            
            NSLog(@"%@", weather.cityName);
            NSLog(@"%f", weather.temperature.kelvin);
            NSLog(@"%f", weather.temperature.fahrenheit);
            NSLog(@"%li", (long)weather.temperature.celsius);
            NSLog(@"%@", weather.currentTime);
            NSLog(@"%@", weather.icon);
            
        } else {
            NSLog(@"%@", error);
        }
        
    }];
    
    [task resume];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification

- (void)updateImage:(NSNotification *)notification {
    
    NSLog(@"%@", [[notification userInfo] objectForKey:kOpenWeatherMapReceiveWeatherIconKey]);
    
    [self.weatherIcon setImage:[[notification userInfo] objectForKey:kOpenWeatherMapReceiveWeatherIconKey]];

    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.weatherIcon]];
    
    [animator addBehavior:gravityBehavior];
    
}

@end
