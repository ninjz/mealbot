//
//  MbotBaseViewController.m
//  mealbot
//
//  Created by caL_ on 2015-06-13.
//  Copyright (c) 2015 Mealbot inc. All rights reserved.
//

#import "MbotBaseViewController.h"

@interface MbotBaseViewController ()
@property (nonatomic) CAPSPageMenu *pagemenu;
@end

@implementation MbotBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 320, 44);
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_dark.png"]];
    imgView.frame = CGRectMake(75, 0, 150, 44);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:imgView];
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:headerView];
    self.navigationController.navigationBar.topItem.titleView = headerView;
   
    // sexy UI colors
//    self.title = @"MEALBOT";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
    
    // Array to keep track of controllers in page menu
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    // Create variables for all view controllers you want to put in the
    // page menu, initialize them, and add each to the controller array.
    // (Can be any UIViewController subclass)
    // Make sure the title property of all view controllers is set
    // Example:
    TestViewController *controller = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    controller.title = @"RESULTS";
    [controllerArray addObject:controller];
    EmptyViewController *controller2 = [[EmptyViewController alloc] initWithNibName:@"EmptyViewController" bundle:nil];
    controller2.title = @"FILTER";
    [controllerArray addObject:controller2];
    
    
    
    // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
    // Example:
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0],
//                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor orangeColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(130.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    // Initialize page menu with controller array, frame, and optional parameters
    _pagemenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    
    // Lastly add page menu as subview of base view controller view
    // or use pageMenu controller in you view hierachy as desired
    [self.view addSubview:_pagemenu.view];
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

@end
