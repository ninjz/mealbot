//
//  ListeningViewController.h
//  mealbot
//
//  Created by Amr Adawi on 2015-06-15.
//  Copyright (c) 2015 Mealbot inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>

@interface ListeningViewController : UIViewController

-(id)initWithVoiceSearch:(SKRecognizer *) voiceSearch;
@end
