//
//  ViewController.h
//  mealbot
//
//  Created by Amr Adawi on 2015-06-12.
//  Copyright (c) 2015 Mealbot inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <SpeechKit/SpeechKit.h>
#import "MBotAPIClient.h"
#import "CAPSPageMenu.h"
#import "RecipeTableViewCell.h"

@interface TestViewController : UIViewController <UITextFieldDelegate, SpeechKitDelegate, SKRecognizerDelegate, SKVocalizerDelegate, UITableViewDelegate, UITableViewDataSource>

// UI
@property (strong, nonatomic) SKRecognizer * voiceSearch;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (nonatomic) CAPSPageMenu *pagemenu;

// stuff
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *tableViewDisplayDataArray;
@property (strong, nonatomic) NSString* searchCriteria;
@property (strong, nonatomic) SKVocalizer* vocalizer;
@property (strong, nonatomic) MBotAPIClient *client;

@property BOOL isSpeaking;

@end


