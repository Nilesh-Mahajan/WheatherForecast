//
//  ViewController.h
//  LeftShiftTask
//
//  Created by Nilesh Mahajan on 12/12/14.
//  Copyright (c) 2014 sci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>{
    int index;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@property (strong, nonatomic) IBOutlet UITableView *whetherForeCastTable;
@property(strong,nonatomic) NSMutableArray *arrayForcastWhether;
@property(strong,nonatomic) NSMutableArray *arrayOfCities;
@property (strong, nonatomic) IBOutlet UITextField *txtCityName;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentCity;
@property(strong,nonatomic) NSString *strCurrentCity;
- (IBAction)btnGetWheatherForecastTapped:(id)sender;

- (IBAction)btnAddCity:(id)sender;

@end

