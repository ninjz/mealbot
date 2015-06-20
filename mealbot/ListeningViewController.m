//
//  ListeningViewController.m
//  mealbot
//
//  Created by Amr Adawi on 2015-06-15.
//  Copyright (c) 2015 Mealbot inc. All rights reserved.
//

#import "ListeningViewController.h"


@interface ListeningViewController()
@property (strong, nonatomic) SKRecognizer * voiceSearch;
@end

@implementation ListeningViewController

-(id)initWithVoiceSearch:(SKRecognizer *)voiceSearch
{
 if (self = [super init])
 {
     self.voiceSearch = voiceSearch;
 }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:54./256. green:70./256. blue:93./256. alpha:1.];
    
    [self createCloseButton];
}

- (void)createCloseButton
{
    CGFloat y = 300;
    CGFloat width = 50;
    CGFloat height = width;
    CGFloat x = (320 - width) / 2.;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    
    [closeButton setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(didCloseButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeButton];
}

- (void)didCloseButtonTouch
{
    if (self.voiceSearch) {
        [self.voiceSearch stopRecording];
        [self.voiceSearch cancel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end