//
//  CityWhetherDetail.m
//  LeftShiftTask
//
//  Created by Nilesh Mahajan on 15/12/14.
//  Copyright (c) 2014 sci. All rights reserved.
//

#import "CityWhetherDetail.h"

@interface CityWhetherDetail ()

@end

@implementation CityWhetherDetail
@synthesize arrayOFWheatherDays,cityWheatherTable,txtViewCityWheather,ViewCityWheather,dictOfWheather;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _serverHandlerBlockMaps = [[RDServerHandler alloc] init];
    arrayOFWheatherDays = [[NSMutableArray alloc] init];
    _arrayOFWheathers = [[NSMutableArray alloc] init];
    dictOfWheather = [[NSDictionary alloc] init];
    if ([appDelegate.str_CityName length]!=0) {
        [self getWhetherForCast:appDelegate.str_CityName];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)getWhetherForCast :(NSString *)cityName{
    __block typeof(self) bself = self;
    //    NSString *stringURL = @"http://api.openweathermap.org/data/2.5/forecast/daily?q=Moscow&cnt=14&APPID=f144db168330d3fa636a0f0aec42577d";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringURL = @"http://api.openweathermap.org/data/2.5/forecast/daily?";
    NSString *stringContentType = @"application/x-www-form-urlencoded";  // Any content Type value
    NSString *stringMethodType = @"GET"; // GET/POST/PUT
   
    NSString *str_request = @"";
    stringURL = [stringURL stringByAppendingString:[NSString stringWithFormat:@"q=%@",cityName]];
    stringURL = [stringURL stringByAppendingString:@"&cnt=14"];
    stringURL = [stringURL stringByAppendingString:@"APPID=f144db168330d3fa636a0f0aec42577d"];
    
    _serverHandlerBlockMaps = [[RDServerHandler alloc] init];
    // Call a service with params mentioned in method call
    [_serverHandlerBlockMaps callServiceWithURL:[NSURL URLWithString:stringURL]
                                    contentType:stringContentType
                                  andBodyString:str_request
                                     withMethod:stringMethodType
                                  isSynchronous:YES
                                       username:@""
                                       password:@""];
    // Catch a response for above called service
    _serverHandlerBlockMaps.serverHandlerBlock = ^(NSString * responseString, NSDictionary *responseDictionary, NSError *error)
    {
        @try
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (error==nil || error == NULL)
                               {
                                   [bself setForeCastWhetherToTableView:responseDictionary];
                                   [MBProgressHUD hideHUDForView:bself.view animated:YES];
                               }
                           });
        }
        @catch (NSException *exception) {
            NSLog(@"Exception found - %@",exception);
            [MBProgressHUD hideHUDForView:bself.view animated:YES];
        }
    };
}

-(void)setForeCastWhetherToTableView:(NSDictionary *)wheatherDictionary{

    NSDictionary *dictCityDetails = [[NSDictionary alloc] initWithDictionary:wheatherDictionary] ;
    NSString *strCityDetail = @"";
    strCityDetail = [strCityDetail stringByAppendingString:[NSString stringWithFormat:@"%@,",[[dictCityDetails objectForKey:@"city"] objectForKey:@"name"]]];
    strCityDetail = [strCityDetail stringByAppendingString:[NSString stringWithFormat:@"%@",[[dictCityDetails objectForKey:@"city"] objectForKey:@"country"]]];
    strCityDetail = [strCityDetail stringByAppendingString:[NSString stringWithFormat:@"(Population - %@)",[[dictCityDetails objectForKey:@"city"] objectForKey:@"population"]]];
    _lblCityDetail.text = strCityDetail;
   
     NSString *strCityLatLon = [NSString stringWithFormat:@"Lat :%@ Lon :%@",[[[dictCityDetails objectForKey:@"city"] objectForKey:@"coord"] objectForKey:@"lat"],[[[dictCityDetails objectForKey:@"city"] objectForKey:@"coord"] objectForKey:@"lon"]];
    _lblCityLatLong.text = strCityLatLon;
    
    _arrayOFWheathers = [wheatherDictionary objectForKey:@"list"];
    NSMutableArray *arrWheatherList= [[NSMutableArray alloc] initWithArray:[wheatherDictionary objectForKey:@"list"]];
    

    for (int i=0; i<[arrWheatherList count]; i++) {
        [arrayOFWheatherDays insertObject:[NSString stringWithFormat:@"Day - %d",i] atIndex:i];
    }
    [cityWheatherTable reloadData];
    NSLog(@"City - %@ Wheather List - %@",[[wheatherDictionary objectForKey:@"city"] objectForKey:@"name"],arrayOFWheatherDays);

}

- (IBAction)btnViewWheatherClose:(id)sender {
    
    if (![ViewCityWheather isHidden]) {
        [ViewCityWheather setHidden:YES];
    }
}

- (IBAction)btnBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -TableView Delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayOFWheatherDays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.textLabel.text = [arrayOFWheatherDays objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dictOfWheather = [_arrayOFWheathers objectAtIndex:indexPath.row];
    NSString *stringWheatherDetail = @"Temprature:\n";
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Day: %@\n",[[dictOfWheather objectForKey:@"temp"] objectForKey:@"day"]]];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Min: %@\n",[[dictOfWheather objectForKey:@"temp"] objectForKey:@"min"]]];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Max: %@\n",[[dictOfWheather objectForKey:@"temp"] objectForKey:@"max"]]];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Night: %@\n",[[dictOfWheather objectForKey:@"temp"] objectForKey:@"night"]]];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Eve: %@\n",[[dictOfWheather objectForKey:@"temp"] objectForKey:@"eve"]]];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Morn: %@\n",[[dictOfWheather objectForKey:@"temp"] objectForKey:@"morn"]]];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:@"\n\n"];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Pressure: %@\n",[dictOfWheather objectForKey:@"pressure"]]];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:@"\n\n"];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Humidity: %@\n",[dictOfWheather objectForKey:@"humidity"]]];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:@"\n\n"];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Weather:\n Main:%@ \n Description: %@\n",[[[dictOfWheather objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"],[[[dictOfWheather objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"]]];
     stringWheatherDetail = [stringWheatherDetail stringByAppendingString:@"\n\n"];
     stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Speed: %@\n",[dictOfWheather objectForKey:@"speed"]]];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:@"\n\n"];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Clouds: %@\n",[dictOfWheather objectForKey:@"clouds"]]];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:@"\n\n"];
    stringWheatherDetail = [stringWheatherDetail stringByAppendingString:[NSString stringWithFormat:@"Snow: %f",[[dictOfWheather objectForKey:@"snow"] doubleValue]]];
    [txtViewCityWheather setText:stringWheatherDetail];
    [ViewCityWheather setHidden:NO];
}

@end
