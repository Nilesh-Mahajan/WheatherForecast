//
//  ViewController.m
//  LeftShiftTask
//
//  Created by Nilesh Mahajan on 12/12/14.
//  Copyright (c) 2014 sci. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize whetherForeCastTable,arrayForcastWhether,arrayOfCities;
@synthesize strCurrentCity;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    index = 0;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
    strCurrentCity = [[NSString alloc] init];
    arrayForcastWhether = [[NSMutableArray alloc] initWithObjects:@"Forecast 1",@"Forecast 2",@"Forecast 3", nil];
    arrayOfCities = [[NSMutableArray alloc] init];
    _txtCityName.text = @"";
    _txtCityName.delegate = self;
    [[[UIAlertView alloc] initWithTitle:@"Add Cities" message:@"Enter City Names to check wheather forecast" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ] show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [arrayOfCities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [arrayOfCities objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.str_CityName = [NSString stringWithFormat:@"%@",[arrayOfCities objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"segCityWhether" sender:self];
}

- (IBAction)btnGetWheatherForecastTapped:(id)sender {
    
    if ([strCurrentCity length]!=0 && ![strCurrentCity isEqualToString:@""]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.str_CityName = strCurrentCity;
        [self performSegueWithIdentifier:@"segCityWhether" sender:self];

    }
}

- (IBAction)btnAddCity:(id)sender {
    
    if ([_txtCityName.text length]==0) {
         [[[UIAlertView alloc] initWithTitle:@"Empty Text" message:@"Please enter valid city name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ] show];
    }
    else{
        [arrayOfCities insertObject:_txtCityName.text atIndex:index];
        index++;
        [whetherForeCastTable reloadData];
    }
    
}

#pragma mark-
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtCityName resignFirstResponder];
    return YES;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
        }
    } ];
    
    strCurrentCity = placemark.locality;
    _lblCurrentCity.text = [NSString stringWithFormat:@"Current City - %@",strCurrentCity];
}

@end
