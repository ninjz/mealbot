//
//  ViewController.m
//  mealbot
//
//  Created by Amr Adawi on 2015-06-12.
//  Copyright (c) 2015 Mealbot inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, strong) NSArray *recipes;
@end

const unsigned char SpeechKitApplicationKey[] = {0x45, 0x49, 0xd6, 0xb3, 0xe4, 0xeb, 0xe3, 0xb0, 0x93, 0x75, 0x14, 0x1e, 0xab, 0x8c, 0x95, 0xa7, 0x6f, 0xb6, 0x33, 0x3c, 0xed, 0xae, 0x09, 0x5f, 0xb0, 0xd7, 0x04, 0xb4, 0xee, 0xdc, 0xad, 0x33, 0x25, 0x84, 0xe7, 0x09, 0x6f, 0xca, 0xba, 0x02, 0x3f, 0xce, 0x21, 0xeb, 0x5a, 0xb6, 0x92, 0xc9, 0x6d, 0xc5, 0x05, 0x5a, 0x73, 0x0f, 0xba, 0x23, 0xe6, 0xbe, 0xd7, 0xd4, 0x9a, 0x84, 0x08, 0xc0};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageLabel.text = @"Tap on the mic";
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.appDelegate setupSpeechKitConnection];
    // Do any additional setup after loading the view, typically from a nib.
    self.client = [MBotAPIClient sharedClient];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordButtonTapped:(id)sender {
    self.recordButton.selected = !self.recordButton.isSelected;
    
    // This will initialize a new speech recognizer instance
    if (self.recordButton.isSelected) {
        self.voiceSearch = [[SKRecognizer alloc] initWithType:SKSearchRecognizerType
                                                    detection:SKShortEndOfSpeechDetection
                                                     language:@"en_US"
                                                     delegate:self];
    }
    
    // This will stop existing speech recognizer processes
    else {
        if (self.voiceSearch) {
            [self.voiceSearch stopRecording];
            [self.voiceSearch cancel];
        }
    }
}

# pragma mark - SKRecognizer Delegate Methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer {
    self.messageLabel.text = @"Listening..";
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer {
    self.messageLabel.text = @"Done Listening..";
}
- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results {
    long numOfResults = [results.results count];
    
    if (numOfResults > 0) {
        // update the text of text field with best result from SpeechKit
        self.searchTextField.text = [results firstResult];
        
        NSArray *ingredients = [[results firstResult] componentsSeparatedByString:@" "];
        
        [self.client getRecipesWithIngredients:ingredients
                                  success:^(NSURLSessionDataTask *task, id responseObject){
                                      NSLog(@"Success -- %@", responseObject);
                                      self.recipes = responseObject[@"results"];
                                      [self.resultTableView reloadData];
                                  }
                                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      NSLog(@"Failure -- %@", error);
                                  }];

    }
    
    self.recordButton.selected = !self.recordButton.isSelected;
    
    if (self.voiceSearch) {
        [self.voiceSearch cancel];
    }
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion {
    self.recordButton.selected = NO;
    self.messageLabel.text = @"Connection error";
    self.activityIndicator.hidden = YES;
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)vocalizer:(SKVocalizer *)vocalizer willBeginSpeakingString:(NSString *)text {
    self.isSpeaking = YES;
}

- (void)vocalizer:(SKVocalizer *)vocalizer didFinishSpeakingString:(NSString *)text withError:(NSError *)error {
    if (error !=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        if (self.isSpeaking) {
            [self.vocalizer cancel];
        }
    }
    
    self.isSpeaking = NO;
}

@end
