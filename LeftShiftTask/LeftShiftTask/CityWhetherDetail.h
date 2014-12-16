//
//  CityWhetherDetail.h
//  LeftShiftTask
//
//  Created by Nilesh Mahajan on 15/12/14.
//  Copyright (c) 2014 sci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDServerHandler.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface CityWhetherDetail : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)RDServerHandler *serverHandlerBlockMaps;
@property (strong, nonatomic) IBOutlet UITableView *cityWheatherTable;
@property (strong, nonatomic) NSMutableArray *arrayOFWheatherDays;
@property (strong, nonatomic) NSMutableArray *arrayOFWheathers;
@property (strong, nonatomic) NSDictionary *dictOfWheather;
@property (strong, nonatomic) IBOutlet UILabel *lblCityDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblCityLatLong;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
@property (strong,nonatomic) IBOutlet UITextView *txtViewCityWheather;
@property (strong,nonatomic) IBOutlet UIView *ViewCityWheather;

- (void)getWhetherForCast :(NSString *)cityName;
- (void)setForeCastWhetherToTableView:(NSDictionary *)wheatherDictionary;
- (IBAction)btnViewWheatherClose:(id)sender;
- (IBAction)btnBackPressed:(id)sender;


@end
